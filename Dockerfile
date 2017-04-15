FROM debian:testing

RUN \
	apt-get update && \
	apt-get install -y texlive-latex-base texlive-latex-extra texlive-latex-extra-doc cm-super texlive-fonts-recommended texlive-fonts-extra texlive-luatex texlive-xetex && \
	apt-get install -y inotify-tools

