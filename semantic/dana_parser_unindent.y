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
  func_def { t = $$ = ast_program($1); }
;

func_def:
"def" header local_def_list block { $$ = ast_func_def($2, $3, $4); }//printf("func_def %s\n", $2->id);}                 
;


local_def_list:
  /* nothing */ { $$ = NULL; }
| local_def local_def_list { $$ = ast_seq($1, $2); }//printf("local_def_list\n");}
;

header:
  T_id { $$ = ast_header($1, NULL, NULL, NULL); printf("header proc %s\n", $1); }
| T_id "is" data_type { $$ = ast_header($1, NULL, NULL, $3); printf("header func\n");}
| T_id ':' fpar_def fpar_def_list { $$ = ast_header($1, $3, $4, NULL); printf("header proc2\n");} 
| T_id "is" data_type ':' fpar_def fpar_def_list { $$ = ast_header($1, $5, $6, $3); printf("header func2\n");} 
;

fpar_def_list:
  /* nothing */ { $$ = NULL; }
| ',' fpar_def fpar_def_list { $$ = ast_seq($2, $3); printf("fpar_def_list\n");}
;

fpar_def:
  T_id id_list "as" fpar_type { $$ = ast_fpar_def($1, $2, $4); printf("fpar_def\n"); }
;

id_list:
  /* nothing */ { $$ = NULL; }
| T_id id_list { $$ = ast_id_list($1, $2); }//printf("id_list\n");}
;

data_type:
  "int" { $$ = typeInteger; }//printf("data_type int\n");}
| "byte" { $$ = typeChar; }


type:
  data_type int_const_list { $$ = ast_type($1, $2); printf("type\n");}
;


fpar_type:
  type { $$ = $1; printf("fpar_type - type\n"); }
| "ref" data_type { $$ = ast_ref_type($2); printf("fpar_type - ref_type\n"); }
| data_type '[' ']' int_const_list { $$ = ast_iarray_type($4, $1); printf("fpar_type - iarray\n"); }
;   

int_const_list:
  /* nothing */ { $$ = NULL; printf("int_const_list - nothing\n");}
| '[' T_const ']' int_const_list { $$ = ast_int_const_list($2, $4); printf("int_const_list\n");}
;

local_def:
  func_def { $$ = $1; } //printf("local_def\n");} 
| func_decl { $$ = $1;} //printf("local_def\n");} 
| var_def { $$ = $1;  } //printf("local_def\n");}
;

func_decl:
  "decl" header { $$ = $2; printf("func_decl\n"); }
;

var_def:
  "var" T_id id_list "is" type { $$ = ast_var_def($2, $3, $5); }//printf("var_def %c %d\n", $2, ($5)->kind);}
;     

stmt:
  "skip" { $$ = NULL; printf("stmt_skip\n");}
| l_value ":=" expr { $$ = ast_let($1, $3); printf("stmt_let\n");}
| proc_call { $$ = $1; printf("proc_calll\n"); }
| "exit" { $$ = NULL; printf("exit\n"); }
| "return" ':' expr { $$ = ast_return($3); printf("return\n"); }
| "if" cond ':' block elif_list { $$ = ast_if($2, $4, $5); printf("if\n"); }
| "if" cond ':' block elif_list "else" ':' block { $$ = ast_if_else($2, $4, $5, $8); printf("if-else\n"); }
| "loop" ':' block { $$ = ast_loop('\0', $3); printf("loop\n"); }
| "loop" T_id ':' block { $$ = ast_loop($2, $4); printf("loop id\n"); }
| "break" { $$ = ast_break('\0'); printf("break\n"); }
| "break" ':' T_id { $$ = ast_break($3); printf("break id\n"); }
| "continue" { $$ = ast_continue('\0'); printf("continue\n"); }
| "continue" ':' T_id { $$ = ast_continue($3); printf("continue id\n"); }
;

elif_list:
  /* nothing */ { $$ = NULL; }
| "elif" cond ':' block elif_list { $$ = ast_elif($2, $4, $5); printf("elif\n"); }
;

block:
  "begin" stmt stmt_list "end" { $$ = ast_seq($2, $3);  printf("block\n");}
;

stmt_list:
  /* nothing */ { $$ = NULL; }
| stmt stmt_list { $$ = ast_seq($1, $2); }//printf("stmt_list\n");}
;

proc_call:
  T_id { $$ = ast_proc_call($1, NULL, NULL); printf("proc_call1\n"); }
| T_id':' expr expr_list { $$ = ast_proc_call($1, $3, $4); printf("proc_call2\n"); }
;  

expr_list:
  /* nothing */ { $$ = NULL; }
| ',' expr expr_list { $$ = ast_seq($2, $3);  printf("expr_list\n");}
;

func_call:
  T_id '('')' { $$ = ast_func_call($1, NULL, NULL); printf("func_call1\n"); }
| T_id '(' expr expr_list ')' { $$ = ast_func_call($1, $3, $4); printf("func_call2\n"); }
; 

l_value:
  T_id { $$ = ast_id($1); printf("l_value T_id is : %s\n", $1);}
| T_str { $$ = ast_str($1); printf("l_value T_str : %s\n", $1); }
| l_value '[' expr ']' { $$ = ast_l_value($1, $3); printf("l_value expr\n");}
;

expr:
  T_char  { $$ = ast_char($1); printf("char\n");}
| T_const { $$ = ast_const($1); printf("const\n");}
| l_value { $$ = $1; printf("expr_lvalue\n");}
| '(' expr ')' { $$ = $2; }
| func_call { $$ = $1; printf("func_call\n"); }
| '+' expr { $$ = ast_op(ast_const(0), PLUS, $2); }	%prec UPLUS
| '-' expr { $$ = ast_op(ast_const(0), MINUS, $2); } %prec UMINUS
| expr '+' expr { $$ = ast_op($1, PLUS, $3); } 
| expr '-' expr { $$ = ast_op($1, MINUS, $3); }  
| expr '*' expr { $$ = ast_op($1, TIMES, $3); } 
| expr '/' expr { $$ = ast_op($1, DIV, $3); } 
| expr '%' expr { $$ = ast_op($1, MOD, $3); } 
| "true" { $$ = ast_true(); printf("true\n"); } 
| "false" { $$ = ast_false(); printf("false\n"); }
| '!' expr { $$ = ast_bit_not($2); printf("bit_not\n"); }	%prec BYTE_NOT
| expr '&' expr { $$ = ast_bit_and($1, $3); printf("bit_and\n"); }
| expr '|' expr { $$ = ast_bit_or($1, $3); printf("bit_or\n"); }
;

cond:
  expr { $$ = $1; } 
| x_cond { $$ = $1; }
;

x_cond:
  '(' x_cond ')' { $$ = $2; }
| "not" cond { $$ = ast_bool_not($2); printf("bool_not\n"); }		%prec NOT
| cond "and" cond { $$ = ast_bool_and($1, $3); printf("bool_and\n"); }
| cond "or" cond { $$ = ast_bool_or($1, $3); printf("bool_or\n"); }
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
  print_code_list();
  destroySymbolTable();
  return 0;
}
