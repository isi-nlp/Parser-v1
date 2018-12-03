import argparse
import numpy as np
from collections import Counter
import pdb

deprels_to_keep = [
"p",
"adpmod",
"adpobj",
"det",
"nsubj",
"ROOT",
]

upos = [
  "NOUN",
  "PROPN",
  "ADJ",
  "ADV",
  "ADP",
  "AUX",
  "CCONJ" ,
  "SCONJ" ,
  "DET" ,
  "INTJ"  ,
  "NUM" ,
  "PART"  ,
  "PRON"  ,
  "SYM" ,
  "VERB"  ,
  "X"   ,
  "PUNCT" ,
]

utpos = [
  "NOUN"  ,
  "ADJ" ,
  "ADV" ,
  "ADP" ,
  "CONJ" ,
  "DET" ,
  "NUM" ,
  "PRT"  ,
  "PRON" ,
  "VERB"  ,
  "X"   ,
  "." ,
]


if __name__ == "__main__":
  parser = argparse.ArgumentParser() 
  parser.add_argument("--input","-i", type=str, help="conll(u) file to noise")
  parser.add_argument("--cnt_file","-c", type=str, help="POS counts file")
  parser.add_argument("--tg_id","-tid", type=str, default="ud", help="tagset id [ud,ut]")
  
  args = parser.parse_args()

  np.random.seed(42)

  punct_pos = "PUNCT"
  if args.tg_id=="ut":
    punct_pos = "."
  tagset = utpos if args.tg_id=="ut" else upos
  tagset_no_punct = tagset[:-1]

  pos_counts = {}
  for line in open(args.cnt_file,'r'):
    line = line.strip("\n").strip(" ")
    tmp = line.split()
    if len(tmp)<2: continue
    c,p = tmp
    if p in tagset_no_punct:
      pos_counts[p] = int(c)
  #
  total = sum(pos_counts.values())
  p_wgts = map(lambda x: pos_counts[x]*1.0/total, tagset_no_punct)
  p_wgts = list(p_wgts)

  sent_cols = []
  for line in open(args.input,'r'):
    line = line.strip("\n")
    if line == "":
      n = len(sent_cols)
      to_replace = np.ones(n,dtype=bool)
      sampled = np.random.choice(tagset_no_punct,size=n,p=p_wgts)

      for i,cols in enumerate(sent_cols):
        pos = cols[3]
        head = int(cols[6])
        deprel = cols[7]
        if pos==punct_pos or deprel in deprels_to_keep:
          to_replace[i] = False
          if head>0:
            to_replace[head-1] = False
        #
      #
      # for i,cols in enumerate(sent_cols):
      #   npos = sampled[i] if to_replace[i] else cols[3]
      #   print("%2s - %5s - %5s - %7s - %2s - %d" % (cols[0], cols[3], npos, cols[7], cols[6], to_replace[i]))

      # pdb.set_trace()

      for i,cols in enumerate(sent_cols):
        cols[3] = sampled[i] if to_replace[i] else cols[3]
        print("\t".join(cols))
      #
      sent_cols = []
      print()
    else:
      sent_cols.append(line.split("\t"))
      
      # rnd_pid = np.random.randint(0,len(tagset)-1,1)[0]  # exclude PUNCT from the sample pool
      # cols[3] = tagset[rnd_pid]
    #
    
    # print("%30s | %5s | %5s | %10s" % (cols[1],pos,cols[3],deprel) )
  #
