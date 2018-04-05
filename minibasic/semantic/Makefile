.PHONY: clean distclean default

CC=gcc
CFLAGS=-Wall -g

default: minibasic

lexer.c: lexer.l
		flex -s -o lexer.c lexer.l

lexer.o: lexer.c parser.h

parser.h parser.c: parser.y
		bison -dv -o parser.c parser.y

minibasic: lexer.o parser.o ast.o general.o error.o symbol.o
		$(CC) $(CFLAGS) -o minibasic $^ -lfl

clean:
		$(RM) lexer.c parser.c parser.h parser.output *.o *~

distclean: clean
		$(RM) minibasic

