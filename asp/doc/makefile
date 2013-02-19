
NAME=paper
OUTPUT=$(NAME).pdf

all: compile

compile:
	pdflatex $(NAME).tex 
	bibtex $(NAME).aux 
	pdflatex $(NAME).tex 
	pdflatex $(NAME).tex 

show: compile
	apvlv $(OUTPUT)

clean: 
	rm -f $(NAME).log
	rm -f $(NAME).aux
	rm -f $(NAME).bbl
	rm -f $(NAME).blg
	rm -f $(NAME).dvi
	rm -f $(NAME).log

