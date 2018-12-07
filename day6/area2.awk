# usage: awk -v dist=10000 -f area2.awk input

BEGIN {
	 FS=","
	 OFS="\t"
	 if (!dist) {
		  print "specify \"dist\""
		  exit 1
	 }
}

function abs(x) { return x >= 0 ? x : -x }

function manhd(x1, y1, x2, y2) { # "manhattan distance"
	 return abs(x2 - x1) + abs(y2 - y1)
}

function sumdist(x, y) {
	 d = 0
	 for (p in points)
		  d += manhd(points[p][0], points[p][1], x, y)
	 return d
}

{
	 sum_x += points[NR][0] = int($1)
	 sum_y += points[NR][1] = int($2)
}

END {
	 x = int(sum_x / NR)
	 y = int(sum_y / NR)

	 # snake-walk around field
	 direction = 0
	 for (i = 1; 1; i++) {
		  # set dx, dy
		  if (direction == 0)		{ dx = 0; dy = 1; }
		  else if (direction == 1)	{ dx = -1; dy = 0; }
		  else if (direction == 2)	{ dx = 0; dy = -1; }
		  else if (direction == 3)	{ dx = 1; dy = 0; }

		  # mark fields
		  for (j = 0; j < int(i/2); j++) {
			   if (sumdist(x += dx, y += dy) < dist) {
					area++
			   }
		  }

		  # next
		  direction++
		  if (direction > 3) direction = 0

		  # check
		  if (direction == 0) {
			   if (area == oldarea) {
					break
			   }
			   oldarea = area
		  }
	 }

	 print area + 1
}
