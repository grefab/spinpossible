NAME=test
PRE=new
OUTPUT=$(NAME).pdf

all: pre

compile:
	pdflatex $(NAME).tex 

show: compile
	apvlv $(OUTPUT)

pre:
	pandoc --template beamer.template -i $(PRE).mk -o $(PRE).tex
	perl -pe 's/\\section/\\end{frame}\n\\begin{frame}[fragile]\n\\frametitle/' -i $(PRE).tex
	perl -pe 's/\\end{document}/\\end{frame}\n\\end{document}/' -i $(PRE).tex
	pdflatex $(PRE).tex
#	apvlv $(PRE).pdf

clean: 
	rm -f pre.tex
	rm -f *.aux
	rm -f *.log
	rm -f *.html
	rm -f *.nav
	rm -f *.out
	rm -f *.snm
	rm -f *.toc
	rm -f *.vrb
	rm -f *.pdf

