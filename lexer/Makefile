.PHONY: clean distclean default

CC=gcc
CFLAGS=-Wall

default: dana_lexer 

lexer.c: lexer.l
	flex -s -o lexer.c dana_lexer.l

dana_lexer: lexer.o
	$(CC) $(CFLAGS) -o dana_lexer $^ -lfl

clean:
	$(RM) lexer.c *.o *~

distclean: clean
	$(RM) dana_lexer


