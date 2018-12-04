# usage: awk -f fabric1.awk input

match($0, /^#\w+ @ ([[:digit:]]+),([[:digit:]]+): ([[:digit:]]+)x([[:digit:]]+)$/, a) {
	 for (x = a[1]; x < a[1] + a[3]; x++)
		  for (y = a[2]; y < a[2] + a[4]; y++)
			   fabric[x][y]++
}

END {
	 for (x in fabric)
		  for (y in fabric[x])
			   if (fabric[x][y] >= 2)
					overlap++;
	 print overlap;
}
