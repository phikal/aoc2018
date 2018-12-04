# usage: ./loop.sh input | awk -f freq2.awk

{
	 val += int($0)
	 hist[val] = 1
}

hist[val] {
	 print val
	 exit
}
