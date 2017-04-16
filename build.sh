#!/bin/bash

set -e

cd $(dirname $0)

IFS=$'\n'
SHOULD_BUILD=0
for source in *.tex ; do
	OUTPUT_FILE="$(basename $source '.tex').pdf"
	if [[ ! -f "$OUTPUT_FILE" || `git status -uno | grep "Your branch is behind"` ]] ; then
		SHOULD_BUILD=1
	fi
done

if [[ ${SHOULD_BUILD} -eq 1 ]]; then
	echo "We are behind, building a new release..."
	git pull origin master
	docker pull deigote/cv
	docker run -it --rm -v "$(pwd)":/cv-src -w /cv-out deigote/cv bash -c "\
		set -e; \
		cp /cv-src/*.tex . && \
		cp /cv-src/*.png . && \
		cp /cv-src/lib/* . && \
		IFS=$'\n' && \
		for source in *.tex ; do \
			echo Building \$source && \
			lualatex --interaction=batchmode \"\$source\" &> /dev/null && \
			echo Built \$source ; \
		done && \
		mv *.pdf /cv-src"
	curl -X PURGE http://deigote.com/cv &> /dev/null
	curl -X PURGE "http://deigote.com/cv/Diego%20Toharia%20-%20CV%20(English).pdf" &> /dev/null
else
	echo "Everything is up to date"
fi
