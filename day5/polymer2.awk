# usage: awk -f polymer1.awk input

BEGIN { FS="" }

{
	 polymer = $0
	 delete units
	 for (n = 1; n <= NF; n++)
		  units[tolower($n)] = 1

	 min = length
	 for (u in units) {
		  gsub("[" u toupper(u) "]", "")

		  x = 1
		  do {
			   changed = 0
			   for (n = 2; n <= NF; n++) {
					if ($(n-1) != $n && tolower($(n-1)) == tolower($n)) {
						 $(n-1) = $n = ""
						 changed = 1
					}
			   }

			   j = 1
			   for (i = 1; i <= NF; i++)
					if ($i != "")
						 $(j++) = $i
			   NF = j - 1
		  } while (changed);

		  if (NF < min)
			   min = NF
		  $0 = polymer
	 }

	 print min
}
