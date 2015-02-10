#!/bin/bash

cd $(dirname $0)

OUTPUT_DIR="$(pwd)/out/"
if [ -d "$1" ] ; then
	OUTPUT_DIR="$1"
fi
OUTPUT_FILE=Diego\ Toharia\ -\ CV\ \(English\).pdf

git remote update
if [[ ! -f "$OUTPUT_DIR/$OUTPUT_FILE" || `git status -uno | grep "Your branch is behind"` ]] ; then 
        echo "We are behind, building a new release..."
        git pull origin master
	docker build -t cv-updater .
	docker run --rm -v "$(pwd)":/cv-src -v "$OUTPUT_DIR":/cv-out -i -t cv-updater bash -c \
		"cd /cv-src && pdflatex Diego\ Toharia\ -\ CV\ \(English\).tex && mv '$OUTPUT_FILE' /cv-out"
        curl -X PURGE http://deigote.com/cv &> /dev/null
	curl -X PURGE "http://deigote.com/cv/Diego%20Toharia%20-%20CV%20(English).pdf" &> /dev/null
else 
        echo "Everything is up to date"
fi
