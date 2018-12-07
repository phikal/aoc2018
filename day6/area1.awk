# usage: awk -f area1.awk input

BEGIN { FS=","; OFS="\t" }

function abs(x) { return x >= 0 ? x : -x }

function manhd(x1, y1, x2, y2) { # "manhattan distance"
	 return abs(x2 - x1) + abs(y2 - y1)
}

function closest(x, y) {
	 min = -1
	 for (p in points) {
		  d = manhd(points[p][0], points[p][1], x, y)
		  if (min == -1 || d < min) {
			   min = d
			   c = p
		  }
	 }

	 l = 0
	 for (p in points)
		  if (manhd(x, y, points[p][0], points[p][1]) == min)
			   l++

	 return (l > 2) ? -1 : c
}

function mark_closest(x, y) {
	 c = closest(x, y)
	 if (c != -1 && !((x, y) in marked)) {
		  area[c]++
		  marked[x][y]++
	 }

	 print x, y, c > "/dev/stderr"
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
	 for (i = 2; 1; i++) {
		  # set dx, dy
		  if (direction == 0)		{ dx = 0; dy = 1; }
		  else if (direction == 1)	{ dx = -1; dy = 0; }
		  else if (direction == 2)	{ dx = 0; dy = -1; }
		  else if (direction == 3)	{ dx = 1; dy = 0; }

		  # mark fields
		  for (j = 0; j < int(i/2); j++)
			   mark_closest(x += dx, y += dy)

		  # next
		  direction++
		  if (direction > 3) direction = 0

		  if (direction == 0) {
			   done = 1
			   for (a in area)
					if (last[a] / area[a] <= 0.95) done = 0
			   if (done) break;
			   for (a in area) last[a] = area[a]
		  }
	 }

	 for (a in area)
		  if (area[a] > max &&
			  area[a] == last[a]) # check if nearly-"finite"
			   max = area[a]
	 print max
}
