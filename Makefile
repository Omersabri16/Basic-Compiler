all: deadcode

deadcode: lex.yy.c y.tab.c
	g++ lex.yy.c y.tab.c -o deadcode

lex.yy.c: deadcode.l
	lex deadcode.l

y.tab.c: deadcode.y
	yacc -d deadcode.y

clean:
	rm -f lex.yy.c y.tab.c y.tab.h deadcode

run:
	./deadcode input.txt