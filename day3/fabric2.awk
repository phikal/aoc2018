# usage: awk -f fabric.awk input input

!readin && match($0, /^#\w+ @ ([[:digit:]]+),([[:digit:]]+): ([[:digit:]]+)x([[:digit:]]+)$/, a) {
	 for (x = a[1]; x < a[1] + a[3]; x++)
		  for (y = a[2]; y < a[2] + a[4]; y++)
			   fabric[x][y]++
}

readin && match($0, /^#([[:digit:]]+) @ ([[:digit:]]+),([[:digit:]]+): ([[:digit:]]+)x([[:digit:]]+)$/, a) {
	 canditate = 1
	 for (x = a[2]; x < a[2] + a[4]; x++)
		  for (y = a[3]; y < a[3] + a[5]; y++)
			   if (fabric[x][y] != 1)
					canditate = 0
	 if (canditate)
		  print a[1]
}

ENDFILE { readin = 1 }
