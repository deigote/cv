#!/bin/bash

if [ -z "$1" ] ; then
	echo "Missing argument: file to build"
	exit 1
fi

docker build -t cv-updater .
docker run -it --name 'cv-updater' --rm -v "$(pwd)":/cv-src -e FILE="$1" -w /cv-out cv-updater bash -c "\
	while true; do \
		find /cv-src/ -name '*.tex' -o -name '*.cls' -o -name '*.sty' | inotifywait --fromfile - && \
		cp /cv-src/*.tex . && \
		cp /cv-src/*.png . && \
		cp /cv-src/lib/* . && \
		lualatex --interaction=nonstopmode -halt-on-error \"\$FILE\" && \
		mv *.pdf /cv-src ; \
	done"

