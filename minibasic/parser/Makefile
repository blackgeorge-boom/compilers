.PHONY: clean distclean default

CC=gcc
CFLAGS=-Wall

default: minibasic

lexer.c: lexer.l
		flex -s -o lexer.c lexer.l

lexer.o: lexer.c parser.h

parser.h parser.c: parser.y
		bison -dv -o parser.c parser.y

parser.o: parser.c

minibasic: lexer.o parser.o
		$(CC) $(CFLAGS) -o minibasic $^ -lfl

clean:
		$(RM) lexer.c parser.c parser.h parser.output *.o *~

distclean: clean
		$(RM) minibasic

