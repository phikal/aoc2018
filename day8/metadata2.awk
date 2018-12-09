# usage: awk -f metadata2.awk input
# UNFINISHED -- didn't solve problem, solved example

BEGIN { RS=" " }

function setup(c, _, i, children, mdcount) {
	 c = ++child
	 children = data[++pos]
	 mdcount = data[++pos]

	 for (i = 1; i <= children; i++)
		  tree[c][i] = setup()
	 for (i = 1; i <= mdcount; i++)
		  metadata[c][i] = data[++pos]

	 return c
}

function value(node, _, sum) {
	 sum = 0
	 if (node) {
		  if (node in tree) {
			   # has children?
			   for (v in metadata[node])
					sum += value(tree[node][metadata[node][v]])
		  } else if (node in metadata) {
			    # has metadata?
			   for (v in metadata[node])
					sum += metadata[node][v]
		  }
	 }

	 return sum
}

{ data[NR] = $0 }

END {
	 setup()
	 print value(1)
}
