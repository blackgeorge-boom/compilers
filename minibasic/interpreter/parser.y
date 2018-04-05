%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

void yyerror (const char *msg);

extern int linenumber;
ast t;
%}

%union{
  ast a;
  char c;
  int n;
}

%token T_for "for"
%token T_print "print"
%token T_let "let"
%token T_if "if"
%token T_then "then"
%token T_do "do"
%token T_begin "begin"
%token T_end "end"
%token<c> T_id
%token<n> T_const

%left '+' '-'
%left '*' '/' '%'
%left UMINUS

%type<a> program
%type<a> stmt_list
%type<a> stmt
%type<a> expr

%%

program:
	     stmt_list { t = $$ = $1; }
;

stmt_list:
		   /* nothing */ { $$ = NULL; }
| stmt stmt_list { $$ = ast_seq($1, $2); }
;

stmt:
	  "print" expr { $$ = ast_print($2); }
| "let" T_id '=' expr { $$ = ast_let($2, $4); }
| "begin" stmt_list "end" { $$ = $2; }
| "for" expr "do" stmt { $$ = ast_for($2, $4); }
| "if" expr "then" stmt { $$ = ast_if($2, $4); }
;

expr:
	  T_id { $$ = ast_id($1); }
| T_const { $$ = ast_const($1); }
| '(' expr ')' { $$ = $2; }
| expr '+' expr { $$ = ast_op($1, PLUS, $3); }
| expr '-' expr { $$ = ast_op($1, MINUS, $3); }
| expr '*' expr { $$ = ast_op($1, TIMES, $3); }
| expr '/' expr { $$ = ast_op($1, DIV, $3); }
| expr '%' expr { $$ = ast_op($1, MOD, $3); }
| '-' expr { $$ = ast_op(ast_const(0), MINUS, $2); } %prec UMINUS
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
  ast_run(t);
  return 0;
}

