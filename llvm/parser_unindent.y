%{
extern "C" {
    #include "symbol.h"
}

#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "auxiliary.h"

extern int yylex();
extern FILE* yyin;

void yyerror (const char *msg);
void debug (const char *msg);

extern int line_number;
extern int command_line_flag;
extern int boom;
ast tree;

struct stack_t {      
  int top, flag;      
  struct stack_t *next;
};
typedef struct stack_t *stack;

extern stack l;
extern int indent_level;
%}

%union{
	ast a;
	unsigned char c;
	char *s;
	int n;
	Type t;
}

%token T_and "and"
%token T_as "as"
%token T_begin "begin"
%token T_break "break"
%token T_byte "byte"
%token T_continue "continue"
%token T_decl "decl"
%token T_def "def"
%token T_elif "elif"
%token T_else "else"
%token T_end "end"
%token T_exit "exit"
%token T_false "false"
%token T_if "if"
%token T_is "is"
%token T_int "int"
%token T_loop "loop"
%token T_not "not"
%token T_or "or"
%token T_ref "ref"
%token T_return "return"
%token T_skip "skip"
%token T_true "true"
%token T_var "var"
%token<s> T_id
%token<n> T_const 
%token<c> T_char 
%token<s> T_str 
%token T_neq "<>"
%token T_leq "<="
%token T_geq ">="
%token T_assgn ":="

%left "or"
%left "and"
%right NOT
%nonassoc '=' "<>" '>' '<' "<=" ">="
%left '+' '-' '|'
%left '*' '/' '%' '&'
%right UMINUS UPLUS BYTE_NOT

%type<a> program
%type<a> func_def
%type<a> local_def_list
%type<a> header
%type<a> fpar_def_list
%type<a> fpar_def
%type<a> id_list
%type<t> data_type
%type<a> type
%type<a> fpar_type
%type<a> int_const_list
%type<a> local_def
%type<a> func_decl
%type<a> var_def
%type<a> stmt
%type<a> elif_list
%type<a> block
%type<a> stmt_list
%type<a> proc_call
%type<a> expr_list
%type<a> func_call
%type<a> l_value
%type<a> expr
%type<a> cond
%type<a> x_cond

%%

/* 
 * This parser recognises programms without offside rule
 * Blocks are determined by begin/end tokens.
 */

program:
  func_def { tree = $$ = ast_program($1); }
;

func_def:
"def" header local_def_list block { $$ = ast_func_def($2, $3, $4); }
;


local_def_list:
  /* nothing */ { $$ = NULL; }
| local_def local_def_list { $$ = ast_seq($1, $2); }
;

header:
  T_id { $$ = ast_header($1, NULL, NULL, NULL); }
| T_id "is" data_type { $$ = ast_header($1, NULL, NULL, $3); }
| T_id ':' fpar_def fpar_def_list { $$ = ast_header($1, $3, $4, NULL); }
| T_id "is" data_type ':' fpar_def fpar_def_list { $$ = ast_header($1, $5, $6, $3); }
;

fpar_def_list:
  /* nothing */ { $$ = NULL; }
| ',' fpar_def fpar_def_list { $$ = ast_seq($2, $3); }
;

fpar_def:
  T_id id_list "as" fpar_type { $$ = ast_fpar_def($1, $2, $4); }
;

id_list:
  /* nothing */ { $$ = NULL; }
| T_id id_list { $$ = ast_id_list($1, $2); }
;

data_type:
  "int" { $$ = typeInteger; }
| "byte" { $$ = typeChar; }


type:
  data_type int_const_list { $$ = ast_type($1, $2); }
;


fpar_type:
  type { $$ = $1; }
| "ref" data_type { $$ = ast_ref_type($2); }
| data_type '[' ']' int_const_list { $$ = ast_iarray_type($4, $1); }
;   

int_const_list:
  /* nothing */ { $$ = NULL; }
| '[' T_const ']' int_const_list { $$ = ast_int_const_list($2, $4); }
;

local_def:
  func_def { $$ = $1; }
| func_decl { $$ = $1; }
| var_def { $$ = $1; }
;

func_decl:
  "decl" header { $$ = ast_func_decl($2); }
;

var_def:
  "var" T_id id_list "is" type { $$ = ast_var_def($2, $3, $5); }
;     

stmt:
  "skip" { $$ = NULL; }
| l_value ":=" expr { $$ = ast_let($1, $3); }
| proc_call { $$ = $1; }
| "exit" { $$ = ast_exit(); }
| "return" ':' expr { $$ = ast_return($3); }
| "if" cond ':' block elif_list { $$ = ast_if($2, $4, $5); }
| "if" cond ':' block elif_list "else" ':' block { $$ = ast_if_else($2, $4, $5, $8); }
| "loop" ':' block { $$ = ast_loop((char*)'\0', $3); }
| "loop" T_id ':' block { $$ = ast_loop($2, $4); }
| "break" { $$ = ast_break((char*)'\0'); }
| "break" ':' T_id { $$ = ast_break($3); }
| "continue" { $$ = ast_continue((char*)'\0'); }
| "continue" ':' T_id { $$ = ast_continue($3); }
;

elif_list:
  /* nothing */ { $$ = NULL; }
| "elif" cond ':' block elif_list { $$ = ast_elif($2, $4, $5); }
;

block:
  "begin" stmt stmt_list "end" { $$ = ast_seq($2, $3); } 
;

stmt_list:
  /* nothing */ { $$ = NULL; }
| stmt stmt_list { $$ = ast_seq($1, $2); }
;

proc_call:
  T_id { $$ = ast_proc_call($1, NULL, NULL); }
| T_id':' expr expr_list { $$ = ast_proc_call($1, $3, $4); }
;  

expr_list:
  /* nothing */ { $$ = NULL; }
| ',' expr expr_list { $$ = ast_seq($2, $3); }
;

func_call:
  T_id '('')' { $$ = ast_func_call($1, NULL, NULL); }
| T_id '(' expr expr_list ')' { $$ = ast_func_call($1, $3, $4); }
; 

l_value:
  T_id { $$ = ast_id($1); }
| T_str { $$ = ast_str($1); }
| l_value '[' expr ']' { $$ = ast_l_value($1, $3); }
;

expr:
  T_char  { $$ = ast_char($1); }
| T_const { $$ = ast_const($1); }
| l_value { $$ = ast_r_value($1); }
| '(' expr ')' { $$ = $2; }
| func_call { $$ = $1; }
| '+' expr { $$ = ast_op(ast_const(0), UN_PLUS, $2); } %prec UPLUS
| '-' expr { $$ = ast_op(ast_const(0), UN_MINUS, $2); } %prec UMINUS
| expr '+' expr { $$ = ast_op($1, PLUS, $3); } 
| expr '-' expr { $$ = ast_op($1, MINUS, $3); }  
| expr '*' expr { $$ = ast_op($1, TIMES, $3); } 
| expr '/' expr { $$ = ast_op($1, DIV, $3); } 
| expr '%' expr { $$ = ast_op($1, MOD, $3); } 
| "true" { $$ = ast_true(); }
| "false" { $$ = ast_false(); }
| '!' expr { $$ = ast_bit_not($2); } %prec BYTE_NOT
| expr '&' expr { $$ = ast_bit_and($1, $3); }
| expr '|' expr { $$ = ast_bit_or($1, $3); }
;

cond:
  expr { $$ = $1; } 
| x_cond { $$ = $1; }
;

x_cond:
  '(' x_cond ')' { $$ = $2; }
| "not" cond { $$ = ast_bool_not($2); } %prec NOT
| cond "and" cond { $$ = ast_bool_and($1, $3); }
| cond "or" cond { $$ = ast_bool_or($1, $3); }
| expr '=' expr { $$ = ast_op($1, EQ, $3); } 
| expr "<>" expr { $$ = ast_op($1, NE, $3); } 
| expr '<' expr { $$ = ast_op($1, LT, $3); } 
| expr '>' expr { $$ = ast_op($1, GT, $3); } 
| expr "<=" expr { $$ = ast_op($1, LE, $3); } 
| expr ">=" expr  { $$ = ast_op($1, GE, $3); } 
;

%%

void yyerror (const char *msg) {
  fprintf(stderr, "Dana error: %s\n", msg);
  fprintf(stderr, "Aborting, I've had enough with line %d and boom is %d\n",
          line_number, boom);
  exit(1);
}

void debug (const char *msg){
  fflush(stdout);
  fprintf(stderr, "%s: indent_level = %d \n", msg, indent_level);
  return ;
}

int main(int argc, char **argv) {

  int c;

  if (argc == 2)
      yyin = fopen(argv[1], "r");
  else if (argc == 1)
      yyin = stdin;
  else {
      printf("Usage: <parser_executable> [input-file] \n");
      return 0;
  }

  command_line_flag = 0; /* No offside rule in dana_unindent. */

  if (command_line_flag) {
    l = (struct stack_t *)malloc(sizeof(struct stack_t));
    l->top = 0;
    l->flag = 0;
    l->next = NULL;
  }

  if (yyparse()) return 1;
  printf("Compilation was successful.\n");

  initSymbolTable(997);
  ast_sem(tree);
  printf("Semantic check was successful.\n");
  print_code_list();
  destroySymbolTable();
  return 0;
}
