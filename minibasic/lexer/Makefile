NY: clean distclean default

CC=gcc
CFLAGS=-Wall

default: minibasic

lexer.c: lexer.l
		flex -s -o lexer.c lexer.l

minibasic: lexer.o
		$(CC) $(CFLAGS) -o minibasic $^ -lfl

clean:
		$(RM) lexer.c *.o *~

distclean: clean
		$(RM) minibasic
