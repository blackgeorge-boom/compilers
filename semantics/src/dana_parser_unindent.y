%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "symbol.h"

void yyerror (const char *msg);
void debug (const char *msg);

extern int line_number;
extern int command_line_flag;
extern int boom;
ast t;

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
	char c;
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
%type<t> type
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
  func_def { t = $$ = $1; }
;

func_def:
"def" header local_def_list block { $$ = ast_func_def($2, $3, $4); }//printf("func_def %s\n", $2->id);}                 
;


local_def_list:
  /* nothing */ { $$ = NULL; }
| local_def local_def_list { $$ = ast_seq($1, $2); }//printf("local_def_list\n");}
;

header:
  T_id { $$ = ast_id($1);  }//printf("header %s\n", $1);}
| T_id "is" data_type
| T_id ':' fpar_def fpar_def_list
| T_id "is" data_type ':' fpar_def fpar_def_list
;

fpar_def_list:
  /* nothing */
| ',' fpar_def fpar_def_list
;

fpar_def:
  T_id id_list "as" fpar_type
;

id_list:
  /* nothing */ { $$ = NULL; }
| T_id id_list { $$ = ast_id_list($1, $2); }//printf("id_list\n");}
;

data_type:
  "int" { $$ = typeInteger; }//printf("data_type int\n");}
| "byte" { $$ = typeInteger; }


type:
  data_type int_const_list { $$ = ast_type($1, $2); printf("type\n");}
;


fpar_type:
  type 
| "ref" data_type 
| data_type '[' ']' int_const_list
;   

int_const_list:
  /* nothing */ { $$ = NULL; printf("int_const_list - nothing\n");}
| '[' T_const ']' int_const_list { $$ = ast_int_const_list($2, $4); printf("int_const_list\n");}
;

local_def:
  func_def 
| func_decl
| var_def { $$ = $1; }//printf("local_def\n");}
;

func_decl:
  "decl" header
;

var_def:
  "var" T_id id_list "is" type { $$ = ast_var_def($2, $3, $5); }//printf("var_def %c %d\n", $2, ($5)->kind);}
;     

stmt:
  "skip" { $$ = NULL; }//printf("stmt_skip\n");}
| l_value ":=" expr { $$ = ast_let($1, $3);} //printf("stmt_lvalue %s  \n",$1->id);}
| proc_call 
| "exit"
| "return" ':' expr 
| "if" cond ':' block elif_list 
| "if" cond ':' block elif_list "else" ':' block
| "loop" ':' block 
| "loop" T_id ':' block 
| "break"
| "break" ':' T_id
| "continue"
| "continue" ':' T_id
;

elif_list:
  /* nothing */
| "elif" cond ':' block elif_list
;

block:
  "begin" stmt stmt_list "end"  { $$ = ast_seq($2, $3); } //printf("blockn");}
;

stmt_list:
  /* nothing */ { $$ = NULL; }
| stmt stmt_list { $$ = ast_seq($1, $2); }//printf("stmt_list\n");}
;

proc_call:
  T_id 
| T_id':' expr expr_list
;  

expr_list:
  /* nothing */
| ',' expr expr_list
;

func_call:
  T_id '('')'
| T_id '(' expr expr_list ')'
; 

l_value:
  T_id { $$ = ast_l_value($1, NULL, NULL); printf("T_id is : %s\n", $1);}
| T_str 
| l_value '[' expr ']' { $$ = ast_l_value('\0', $1, $3); }
;

expr:
  T_char
| T_const { $$ = ast_const($1); printf("const\n");}
| l_value { $$ = ast_id($1->id); printf("expr_lvalue\n");}
| '(' expr ')' { $$ = $2; }
| func_call
| '+' expr { $$ = ast_op(ast_const(0), PLUS, $2); }	%prec UPLUS
| '-' expr { $$ = ast_op(ast_const(0), MINUS, $2); } %prec UMINUS
| expr '+' expr { $$ = ast_op($1, PLUS, $3); } 
| expr '-' expr { $$ = ast_op($1, MINUS, $3); }  
| expr '*' expr { $$ = ast_op($1, TIMES, $3); } 
| expr '/' expr { $$ = ast_op($1, DIV, $3); } 
| expr '%' expr { $$ = ast_op($1, MOD, $3); } 
| "true" 
| "false"
| '!' expr 			%prec BYTE_NOT
| expr '&' expr
| expr '|' expr
;

cond:
  expr 
| x_cond
;

x_cond:
  '(' x_cond ')'
| "not" cond 		%prec NOT
| cond "and" cond
| cond "or" cond
| expr '=' expr
| expr "<>" expr
| expr '<' expr
| expr '>' expr
| expr "<=" expr
| expr ">=" expr 
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

  if (argc > 1) {
    printf("Usage: dana_unindent [input-file] \n");
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
  ast_sem(t);
  printf("after ast_sem\n");
  destroySymbolTable();
  return 0;
}
