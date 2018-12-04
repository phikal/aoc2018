# usage: awk -f cksum2.awk input

BEGIN { FS = "" }

{ line[NR] = $0 }

END {
	 for (i = 1; i <= NR; i++) {
		  for (j = 1; j <= NR; j++) {
			   diff = 0
			   for (k = 1; k <= length(line[i]); k++)
					if (substr(line[i], k, 1) != substr(line[j], k, 1))
						 diff++;

			   if (diff == 1) {
					for (k = 1; k <= length(line[i]); k++)
						 if (substr(line[i], k, 1) == substr(line[j], k, 1))
							  printf("%c", substr(line[i], k, 1))
					printf("\n")
					exit
			   }

		  }
	 }
}
