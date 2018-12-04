# usage: awk -f sleep2.awk input

{
	 match($0, /^\[(....)-(..)-(..) (..):(..)\]/, a)

 	 tdiff  = (a[1] - year)  * 60 * 24 * 365.25
 	 tdiff += (a[2] - month) * 60 * 24 * 30.5
	 tdiff += (a[3] - day)   * 60 * 24
 	 tdiff += (a[4] - hour)  * 60
	 tdiff += a[5] - minute

	 year = a[1]
	 month = a[2]
	 day = a[3]
	 hour = a[4]
	 minute = a[5]
}

/Guard #[[:digit:]]+ begins shift/ {
	 match($0, /#([[:digit:]]+)/, d)
	 current = d[1]
}

/wakes up/ {
	 for (i = 0; i < tdiff; i++)
		  asleep[current][minute - i - 1]++
}

END {
	 max = 0
	 for (g in asleep) {
		  for (m in asleep[g]) {
			   if (asleep[g][m] > max) {
					print max, asleep[g][m], m, g
					max = asleep[g][m]
					minute = m
					id = g
			   }
		  }
	 }

	print id * minute
}
