import sys

deprels_to_keep = [
"p",
"adpmod",
"adpobj",
"det",
"nsubj",
"ROOT",
]

count = 0
total = 0
for line in open(sys.argv[1],'r'):
	line = line.strip("\n")
	if line=="": continue
	cols = line.split("\t")
	if cols[7] in deprels_to_keep:
		count += 1
	total += 1
#
print("kept dep rels: %d/%d, %.4f" % (count,total,1.0*count/total) )