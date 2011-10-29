
NAME=asp-spin
OUTPUT=$(NAME).pdf

all: show 

compile:
	pdflatex $(NAME).tex 

show: compile
	apvlv $(OUTPUT)

clean: 
	rm $(NAME).log
	rm $(NAME).aux
	rm $(NAME).pdf

