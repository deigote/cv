FROM dockerfile/ubuntu

RUN \
	apt-get update && \
	apt-get install -y texlive-latex-base texlive-latex-extra texlive-latex-extra-doc cm-super texlive-fonts-recommended
