# usage: awk -f polymer1.awk input

BEGIN { FS="" }

{
	 do {
		  changed = 0
		  for (n = 2; n <= NF; n++) {
			   if ($(n-1) != $n &&
				   tolower($(n-1)) == tolower($n)) {
					$(n-1) = $(n) = ""
					changed = 1
			   }
		  }

		  j = 1
		  for (i = 1; i <= NF; i++)
			   if ($i != "")
					$(j++) = $i
		  NF = j

		  print length
	 } while (changed);

	 print length
}
