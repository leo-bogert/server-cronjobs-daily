#!/bin/bash
if ! source "lib-bash-leo.sh" ; then
	echo 'lib-bash-leo.sh is missing in PATH!'
	exit 1
fi

DIRS=( '/home/multimedia' )
DAYS_TO_KEEP_WRITEABLE=7

for_files() {
	show_parameters chattr +i "$1"
}

for_directories() {
	show_parameters chattr +i "$1"
}

main() {
	for dir in "${DIRS[@]}" ; do
		while IFS= read -r -d $'\0' file ; do
			if [ -f "$file" ] ; then
				for_files "$file"
			elif [ -d "$file" ] ; then
				for_directories "$file"
		    else
				stderr "Unknown file type: $file"
			fi
		done < <(find "$dir" -mount \( -type f -o -type d \) -writable -atime +"$DAYS_TO_KEEP_WRITEABLE" -ctime +"$DAYS_TO_KEEP_WRITEABLE" -mtime +"$DAYS_TO_KEEP_WRITEABLE"  -print0)
	done
}

main "$@"
