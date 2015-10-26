FROM ubuntu:14.04.1

RUN \
	apt-get update && \
	apt-get install -y texlive-latex-base texlive-latex-extra texlive-latex-extra-doc cm-super texlive-fonts-recommended
