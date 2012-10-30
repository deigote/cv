#!/bin/bash

git remote update
if [[ `git status -uno | grep "# Your branch is behind"` ]] ; then 
        echo "We are behind, building a new release..."
        git pull origin master
	pdflatex Diego\ Toharia\ -\ CV\ \(English\).tex        
        curl -X PURGE http://deigote.com/cv &> /dev/null
        curl -X PURGE http://deigote.com/cv/Diego\ Toharia\ -\ CV\ \(English\).pdf &> /dev/null
else 
        echo "Everything is up to date"
fi
