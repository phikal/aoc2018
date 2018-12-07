# usage: awk -f steps1.awk input

match($0, / ([A-Z]) .* ([A-Z]) /, a) {
	 require[a[1]][a[2]] = 1
	 demand[a[2]][a[1]] = 1
	 for (n in node)
		  if (node[n] == a[1])
			   next
	 node[NR] = a[1]
}

END {
	 for (j in require)
		  for (i in require[j])
			   for (n = 0; n < length(node); n++)
					if (node[n] == i) delete node[n]
	 for (n in node) if (!node[n]) delete node[n]

	 while (length(node) > 0) {
		  asort(node)
		  printf("%s", node[1])
		  done[node[1]] = 1

		  if (node[1] in require)
			   for (n in require[node[1]]) {
					ready = 1
					for (m in demand[n])
						 if (!done[m])
						 ready = 0
					if (!ready) continue

					node[length(node)+1] = n
			   }

		  x = node[1]
		  for (n in node) if (node[n] == x) delete node[n]
	 }
	 printf("\n")
}
