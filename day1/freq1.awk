# awk -f freq1.awk input

{ val += int($0) }

END { print val }
