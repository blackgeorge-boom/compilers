.PHONY: clean distclean default

CC=gcc
CFLAGS=-Wall -g

default: dana

lexer.c: lexer.l
		flex -s -o lexer.c lexer.l

lexer.o: lexer.c parser.h

parser.h parser.c: parser_indent.y
		bison -dv -o parser.c parser_indent.y

dana: lexer.o parser.o ast.o general.o error.o symbol.o
		$(CC) $(CFLAGS) -o dana $^ -lfl

clean:
		$(RM) lexer.c parser.c parser.h parser.output *.o *~

distclean: clean
		$(RM) dana

