# usage: awk -f metadata1.awk input

BEGIN { RS=" " }

function sum_md(sum, i, children, mdcount) {
	 children = data[pos++]
	 mdcount = data[pos++]

	 for (i = 0; i < children; i++)
		  sum += sum_md()

	 for (i = 0; i < mdcount; i++)
		  sum += data[pos++]

	 return sum
}

{ data[NR] = $0 }

END {
	 pos = 1
	 print sum_md()
}
