#!/bin/sh
[ -z "$1" ] && exit 1

while true
do
	cat "$1"
done
