# usage: awk -f cksum.awk input

BEGIN { FS = "" }

{
	 for (i = 1; i <= NF; i++)
		  chars[$i]++

	 has2 = 0
	 has3 = 0

	 for (i in chars) {
		  if (debug)
			   print $0, "has", chars[i], i "'s"

		  has2 += chars[i] == 2
		  has3 += chars[i] == 3
	 }

	 if (has2) twos++
	 if (has3) threes++

	 if (debug)
		  print ""
	 delete chars
}

END { print twos * threes }
