NAME=test
PRE=new
OUTPUT=$(NAME).pdf

all: pre

compile:
	pdflatex $(NAME).tex 

pre:
	pandoc --template beamer.template -i $(PRE).mk -o $(PRE).tex
	perl -pe 's/\\section/\\end{frame}\n\\begin{frame}[fragile]\n\\frametitle/' -i $(PRE).tex
	perl -pe 's/\\end{document}/\\end{frame}\n\\end{document}/' -i $(PRE).tex
	pdflatex $(PRE).tex

clean: 
	rm -f *.tex
	rm -f *.aux
	rm -f *.log
	rm -f *.html
	rm -f *.nav
	rm -f *.out
	rm -f *.snm
	rm -f *.toc
	rm -f *.vrb
	rm -f *.pdf

