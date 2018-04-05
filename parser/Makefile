.PHONY: clean distclean default

CC=gcc
CFLAGS=-Wall

default: dana_unindent

all: dana_unindent dana_indent

###########################################################
lexer_unindent.c: dana_lexer_for_parser.l
	flex -s -o lexer_unindent.c dana_lexer_for_parser.l

lexer_unindent.o: lexer_unindent.c parser_unindent.h

parser_unindent.h parser_unindent.c: dana_parser_unindent.y
	bison -dv -o parser_unindent.c dana_parser_unindent.y

parser_unindent.o: parser_unindent.c

dana_unindent: lexer_unindent.o parser_unindent.o
	$(CC) $(CFLAGS) -o dana_unindent $^ -lfl
###########################################################
lexer_indent.c: dana_lexer_for_parser.l
	flex -s -o lexer_indent.c dana_lexer_for_parser.l

lexer_indent.o: lexer_indent.c parser_indent.h

parser_indent.h parser_indent.c: dana_parser_indent.y
	bison -dv -o parser_indent.c dana_parser_indent.y

parser_indent.o: parser_indent.c

dana_indent: lexer_indent.o parser_indent.o
	$(CC) $(CFLAGS) -o dana_indent $^ -lfl
###########################################################
clean:
	$(RM) lexer_unindent.c parser_unindent.c parser_unindent.h parser_unindent.output lexer_indent.c parser_indent.c parser_indent.h parser_indent.output *.o *~

distclean: clean
	$(RM) dana_unindent dana_indent
