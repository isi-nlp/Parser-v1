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

  for line in open(args.input,'r'):
    line = line.strip("\n")
    if line == "":
      print()
      continue
    cols = line.split("\t")
    pos = cols[3]
    deprel = cols[7]
    if pos!=punct_pos and deprel not in deprels_to_keep:
      new_pos = np.random.choice(tagset_no_punct,1,p=p_wgts)[0]
      cols[3] = new_pos

      # rnd_pid = np.random.randint(0,len(tagset)-1,1)[0]  # exclude PUNCT from the sample pool
      # cols[3] = tagset[rnd_pid]
    #
    print("\t".join(cols))
    # print("%30s | %5s | %5s | %10s" % (cols[1],pos,cols[3],deprel) )
  #
