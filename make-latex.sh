#!/bin/bash

TEX=$1
AUX=`echo $1 | sed 's/tex$/aux/'`

ls -l | grep -q '.tex' $TEX
if [ $? = 0 ]; then
	grep -q \{biblatex\} $TEX
	if [ $? = 0 ]; then
		pdflatex $TEX
		bibtex $AUX
		pdflatex $TEX
		pdflatex $TEX
		exit 0
	else
		pdflatex $TEX
		pdflatex $TEX
		exit 0
	fi
else
	echo "Usage: File needs to be a LaTex file (.tex)!"
	exit 0
fi
