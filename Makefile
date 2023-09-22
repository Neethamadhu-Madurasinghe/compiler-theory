# Makefile for compiling Flex and Bison files into the 'calc' executable

calc: calc.tab.c lex.yy.c
	gcc -o calc calc.tab.c lex.yy.c -lfl

calc.tab.c: calc.y
	bison -d calc.y

lex.yy.c: calc.l
	flex -o lex.yy.c calc.l

clean:
	rm -f calc calc.tab.c lex.yy.c calc.tab.h calc.output

.PHONY: clean
