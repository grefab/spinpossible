#
# makefile for the analysis project.
#

CC = g++ -Wall -g -O3
#CC = g++ -Wall -g -oFast

all: start

start: analysis.o
	$(CC) bin/analysis.o -o bin/analysis
	./bin/analysis

analysis.o: analysis.h analysis.cpp
	$(CC) -o bin/analysis.o -c analysis.cpp

clean:
	rm -fr bin/*
