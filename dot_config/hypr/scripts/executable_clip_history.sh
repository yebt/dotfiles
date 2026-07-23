#!/usr/bin/env bash

mode=$1

[ -z "$mode" ] && exit 1


case "$mode" in
	wofi|w)
		selector="wofi -d"
		;;
	fzf|f)

		selector="fzf"
		;;
	*)
		echo 'no spport selector'
		exit 1
esac

selectedh=$(cliphist list | $selector)


if [ -z "$selectedh" ]; then
	exit 0
fi

echo "$selectedh" | cliphist decode | wl-copy

