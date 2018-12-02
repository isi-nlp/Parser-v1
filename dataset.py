#!/usr/bin/env python
# -*- coding: UTF-8 -*-

# Copyright 2016 Timothy Dozat
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import numpy as np
import tensorflow as tf
from collections import Counter
import pdb

from lib.etc.k_means import KMeans
from configurable import Configurable
from vocab import Vocab
from metabucket import Metabucket

#***************************************************************
class Dataset(Configurable):
  """"""
  
  #=============================================================
  def __init__(self, filename, vocabs, builder, *args, **kwargs):
    """"""
    
    super(Dataset, self).__init__(*args, **kwargs)
    self._file_iterator = self.file_iterator(filename)
    self._train = (filename == self.train_file)
    self._metabucket = Metabucket(self._config, n_bkts=self.n_bkts)
    self._data = None
    self.vocabs = vocabs
    self.rebucket()
    
    self.inputs = tf.placeholder(dtype=tf.int32, shape=(None,None,None), name='inputs') # added tr_clt,pretr_clt
    self.targets = tf.placeholder(dtype=tf.int32, shape=(None,None,None), name='targets')
    self.builder = builder()
  
  #=============================================================
  def file_iterator(self, filename):
    """"""
    
    with open(filename) as f:
      if self.lines_per_buffer > 0:
        buff = [[]]
        while True:
          line = f.readline()
          while line:
            line = line.strip().split()
            if line:
              buff[-1].append(line)
            else:
              if len(buff) < self.lines_per_buffer:
                if buff[-1]:
                  buff.append([])
              else:
                break
            line = f.readline()
          if not line:
            f.seek(0)
          else:
            buff = self._process_buff(buff)
            yield buff
            line = line.strip().split()
            if line:
              buff = [[line]]
            else:
              buff = [[]]
      else:
        buff = [[]]
        for line in f:
          line = line.strip().split()
          if line:
            buff[-1].append(line)
          else:
            if buff[-1]:
              buff.append([])
        if buff[-1] == []:
          buff.pop()
        buff = self._process_buff(buff)
        while True:
          yield buff
  
  #=============================================================
  def _process_buff(self, buff):
    """"""
    
    words, tags, rels, clts = self.vocabs
    wpt = 2 if words.use_pretrained else 1
    zero_we = self.zero_wrd_emb and self._name != "Trainset"
    wunk_pack = (words.UNK,words.UNK) if words.use_pretrained else (words.UNK,)

    for i, sent in enumerate(buff):
      for j, token in enumerate(sent):
        word, tag, head, rel, clt = token[words.conll_idx], \
                                    token[tags.conll_idx], \
                                    token[6], \
                                    token[rels.conll_idx], \
                                    token[clts.conll_idx]
        wid = words[word] if not zero_we else wunk_pack
        cid = ''
        if self.clt_src=="id":
          cid = clts[clt]
        else:
          cid = clts[clts.get_clt_map(word)] # emb_id of multi-ling clust id
        
        buff[i][j] = (word,) + wid + tags[tag] + cid + (int(head),) + rels[rel]

        # if use_pretrained, words[] returns trainable_id, pretr_id
      sent.insert(0, ['root'] + [Vocab.ROOT]*(wpt+1+1)+ [0, Vocab.ROOT])

      # if self._name != "Trainset":
      #   pdb.set_trace()
    return buff
  
  #=============================================================
  def reset(self, KM_obj):
    """"""
    
    self._data = []
    self._targets = []
    self._metabucket._n_bkts = KM_obj._k
    self._metabucket.reset(KM_obj.splits)
    return
  
  #=============================================================
  def rebucket(self):
    """"""

    print("rebucketing...")
    
    buff = self._file_iterator.next()
    len_cntr = Counter()
    
    for sent in buff:
      len_cntr[len(sent)] += 1

    print("init kmeans...")
    print("len cntr: ", len(len_cntr) )
    # pdb.set_trace()

    self.reset(KMeans(self.n_bkts, len_cntr))
    
    print("post kmeans..")

    for sent in buff:
      self._metabucket.add(sent)
    self._finalize()
    return
  
  #=============================================================
  def _finalize(self):
    """"""
    
    self._metabucket._finalize()
    return
  
  #=============================================================
  def get_minibatches(self, batch_size, input_idxs, target_idxs, shuffle=True):
    """"""
    
    minibatches = []
    for bkt_idx, bucket in enumerate(self._metabucket):
      if batch_size == 0:
        n_splits = 1
      else:
        n_tokens = len(bucket) * bucket.size
        n_splits = max(n_tokens // batch_size, 1)
      if shuffle:
        range_func = np.random.permutation
      else:
        range_func = np.arange
      arr_sp = np.array_split(range_func(len(bucket)), n_splits)
      for bkt_mb in arr_sp:
        minibatches.append( (bkt_idx, bkt_mb) )
    if shuffle:
      np.random.shuffle(minibatches)
    for bkt_idx, bkt_mb in minibatches:
      feed_dict = {}
      data = self[bkt_idx].data[bkt_mb]
      sents = self[bkt_idx].sents[bkt_mb]
      maxlen = np.max(np.sum(np.greater(data[:,:,0], 0), axis=1))
      
      # pdb.set_trace()

      feed_dict.update({
        self.inputs: data[:,:maxlen,input_idxs],
        self.targets: data[:,:maxlen,target_idxs]
      })

      yield feed_dict, sents
  
  #=============================================================
  @property
  def n_bkts(self):
    if self._train:
      return super(Dataset, self).n_bkts
    else:
      return super(Dataset, self).n_valid_bkts
  
  #=============================================================
  def __getitem__(self, key):
    return self._metabucket[key]
  def __len__(self):
    return len(self._metabucket)
