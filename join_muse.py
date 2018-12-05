import sys

# assump
# argv 1 : guo vocab
# 

vocab = open(sys.argv[1],'r').read().strip("\n").split("\n")
vocab = set(vocab)


for lang in "de en fr es it pt sv".split():
	for line in open("wrd-emb/wiki.multi.%s.vec" % lang,'r'):
		line = line.strip("\n")
		if line=="": continue
		w = line.split()[0]
		if w in vocab:
			print(line)
	#
#
