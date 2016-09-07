#!/bin/bash

cd $(dirname $0)

OUTPUT_DIR="$(pwd)/out/"
if [ ! -z "$1" ] ; then
	OUTPUT_DIR="$1"
	mkdir -p $OUTPUT_DIR
fi

IFS=$'\n'
for source in *.tex ; do
	OUTPUT_FILE="$(basename $source '.tex').pdf"
	OUTPUT="$OUTPUT_DIR$OUTPUT_FILE"
	if [[ ! -f "$OUTPUT" || `git status -uno | grep "Your branch is behind"` ]] ; then 
	        echo "We are behind, building a new release..."
        	git pull origin master
		docker build -t cv-updater .
		docker run --rm -v "$(pwd)":/cv-src -v "$OUTPUT_DIR":/cv-out -i -t cv-updater bash -c \
			"cd /cv-src && pdflatex '$source' && mv '$OUTPUT_FILE' /cv-out"
	        curl -X PURGE http://deigote.com/cv &> /dev/null
		curl -X PURGE "http://deigote.com/cv/Diego%20Toharia%20-%20CV%20(English).pdf" &> /dev/null
	else 
        	echo "Everything is up to date"
	fi
done
