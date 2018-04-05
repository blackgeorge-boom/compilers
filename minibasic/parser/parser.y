%{
#include <stdio.h>
#include <stdlib.h>

void yyerror (const char *msg);

extern int linenumber;
%}

%token T_for "for"
%token T_print "print"
%token T_let "let"
%token T_if "if"
%token T_then "then"
%token T_do "do"
%token T_begin "begin"
%token T_end "end"
%token T_id
%token T_const 

%left '+' '-'
%left '*' '/' '%'
%left UMINUS
   
%%

program:
	     stmt_list
;

stmt_list:
		   /* nothing */
| stmt stmt_list
;

stmt:
	  "print" expr
| "let" T_id '=' expr
| "begin" stmt_list "end"
| "for" expr "do" stmt
| "if" expr "then" stmt
;

expr:
	  T_id
| T_const
| '(' expr ')'
| expr '+' expr
| expr '-' expr
| expr '*' expr
| expr '/' expr
| expr '%' expr
| '-' expr         %prec UMINUS
;

%%

void yyerror (const char *msg) {
  fprintf(stderr, "Minibasic error: %s\n", msg);
  fprintf(stderr, "Aborting, I've had enough with line %d...\n",
          linenumber);
  exit(1);
}

int main() {
  if (yyparse()) return 1;
  printf("Compilation was successful.\n");
  return 0;
}
   

