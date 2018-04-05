%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "symbol.h"

void yyerror (const char *msg);

extern int linenumber;
ast t;
%}

%union{
  ast a;
  char c;
  int n;
  Type t;
}

%token T_for "for"
%token T_print "print"
%token T_let "let"
%token T_if "if"
%token T_then "then"
%token T_do "do"
%token T_begin "begin"
%token T_end "end"
%token T_var "var"
%token T_int "int"
%token T_bool "bool"
%token T_and "and"
%token T_or "or"
%token T_not "not"
%token T_le "<="
%token T_ge ">="
%token T_ne "<>"
%token<c> T_id
%token<n> T_const

%left "or"
%left "and"
%left "not"
%nonassoc '<' '>' "<=" ">=" '=' "<>"
%left '+' '-'
%left '*' '/' '%'
%left UMINUS

%type<a> program
%type<a> stmt_list
%type<a> stmt
%type<a> expr
%type<a> decl_list
%type<a> decl
%type<t> type

%%

program:
	     decl_list stmt_list { t = $$ = ast_block($1, $2); }
;

stmt_list:
		   /* nothing */ { $$ = NULL; }
| stmt stmt_list { $$ = ast_seq($1, $2); }
;

stmt:
	  "print" expr { $$ = ast_print($2); }
| "let" T_id '=' expr { $$ = ast_let($2, $4); }
| "begin" decl_list stmt_list "end" { $$ = ast_block($2, $3); }
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
| expr '<' expr { $$ = ast_op($1, LT, $3); }
| expr '>' expr { $$ = ast_op($1, GT, $3); }
| expr "<=" expr { $$ = ast_op($1, LE, $3); }
| expr ">=" expr { $$ = ast_op($1, GE, $3); }
| expr '=' expr { $$ = ast_op($1, EQ, $3); }
| expr "<>" expr { $$ = ast_op($1, NE, $3); }
| expr "and" expr { $$ = ast_op($1, AND, $3); }
| expr "or" expr { $$ = ast_op($1, OR, $3); }
| "not" expr { $$ = ast_op($2, NOT, NULL); }
;

decl:
	"var" T_id ':' type { $$ = ast_decl($2, $4); }
;

decl_list:
		   /* nothing */ { $$ = NULL; }
| decl decl_list { $$ = ast_seq($1, $2); }
;

type:
	  "int"  { $$ = typeInteger; }
| "bool" { $$ = typeBoolean; }
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
  initSymbolTable(997);
  ast_sem(t);
  ast_run(t);
  destroySymbolTable();
  return 0;
}

