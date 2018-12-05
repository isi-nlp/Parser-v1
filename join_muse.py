import sys

# assump
# argv 1 : guo vocab
# 

vocab = open(sys.argv[1],'r').read().strip("\n").split("\n")
vocab = set(vocab)


for lang in "de en fr es it pt sv".split():
	emb_file = "wrd-emb/%s-en/%s-en/vectors-%s.txt" % (lang,lang,lang) if lang!="en" else \
						 "wrd-emb/cc.en.300.vec"
	for line in open(emb_file,'r'):
		line = line.strip("\n")
		if line=="": continue
		cols = line.split()
		if len(cols)<3: continue
		w = cols[0] + "_"+lang
		if w in vocab:
			print(line)
	#
#
