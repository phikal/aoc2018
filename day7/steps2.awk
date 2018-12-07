# usage: awk -v workers=5 -f steps2.awk input

@include "/usr/share/awk/ord.awk"

BEGIN {
	if (!workers) {
		print "variable \"workers\" not defined" > "/dev/stderr"
		exit 1
	}
}

function durat(s) {
	v = ord(s) - ord("A") + 1 + 60
	return v
}

function finished(w, t) {
	done[t] = 1
	if (!(t in require)) return
	for (n in require[t]) {
		# check if all requirements are fulfulled
		ready = 1
		for (m in demand[n])
			if (!done[m]) ready = 0
		if (!ready) continue

		task[length(task)+1] = n
	}

	work[w][0] = -1
	delete work[w][1]
}

function next_task() {
	if (length(task) == 0)
		return
	asort(task)
	t = task[1]
	delete task[1]
	return t
}

function work_done() {
	d = 0
	for (w in work) if (work[w][0] > 0) d = 1

	printf("%4d ", seconds)
	for (w in work) printf("%1s", work[w][1])
	print ""

	return d || (length(task) > 0)
}

match($0, / ([A-Z]) .* ([A-Z]) /, a) {
	require[a[1]][a[2]] = 1
	demand[a[2]][a[1]] = 1
	for (n in task)
		if (task[n] == a[1])
			next
	task[NR] = a[1]
}

END {
	# clean `node` of all targets that require something
	for (j in require)
		for (i in require[j])
			for (n = 0; n < length(task); n++)
				if (task[n] == i) delete task[n]
	for (n in task) if (!task[n]) delete task[n]

	# set all "worker-elf" to "ready"
	for (i = 0; i < workers; i++)
		work[i][0] = -1

	# clock
	seconds = 0
	while (work_done()) {
		for (w in work) {
			work[w][0]--
			if (work[w][0] == 0)
				finished(w, work[w][1])

			# can work and have work
			if (work[w][0] < 0 && (work[w][1] = next_task())) {
				work[w][0] = durat(work[w][1])
			}

		}
		seconds++
	}

	print seconds - 1
}
