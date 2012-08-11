#!/bin/bash
find /usr/share -print0 \
| while read -d $'\0' -r file
do
	if ! rpm -qf --quiet -- "${file}" ; then
		if [ -L "${file}" ] ; then
			type=link
		elif [ -d "${file}" ] ; then
			type=directory
		else
			type=file
		fi
		echo "Weird ${type} ${file}, please check this out"
	fi
done
