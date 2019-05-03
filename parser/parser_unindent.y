%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern FILE* yyin;

void yyerror (const char *msg);
void debug (const char *msg);

extern int line_number;
extern int command_line_flag;
extern int boom;

struct stack_t {      
  int top, flag;      
  struct stack_t *next;
};
typedef struct stack_t *stack;

extern stack l;
extern int indent_level;
%}

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
%token T_id
%token T_const 
%token T_char 
%token T_str 
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


%%

/* 
 * This parser recognises programms without offside rule
 * Blocks are determined by begin/end tokens.
 */

program:
  func_def 
;

func_def:
"def" header local_def_list block                   
;


local_def_list:
  /* nothing */
| local_def local_def_list 
;

header:
  T_id 
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
  /* nothing */
| T_id id_list
;

data_type:
  "int" 
| "byte"
;

type:
  data_type int_const_list
;


fpar_type:
  type 
| "ref" data_type 
| data_type '[' ']' int_const_list
;   

int_const_list:
  /* nothing */
| '[' T_const ']' int_const_list
;

local_def:
  func_def 
| func_decl
| var_def
;

func_decl:
  "decl" header
;

var_def:
  "var" T_id id_list "is" type
;     

stmt:
  "skip" 
| l_value ":=" expr 
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
  "begin" stmt stmt_list "end"  
;

stmt_list:
  /* nothing */
| stmt stmt_list
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
  T_id
| T_str 
| l_value '[' expr ']' 
;

expr:
  T_char
| T_const
| l_value
| '(' expr ')'
| func_call
| '+' expr 			%prec UPLUS
| '-' expr 			%prec UMINUS
| expr '+' expr  
| expr '-' expr
| expr '*' expr
| expr '/' expr
| expr '%' expr
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

//  if (argc > 1) {
//    printf("Usage: dana_unindent [input-file] \n");
//    return 0;
//  }

  if (argc == 2)
      yyin = fopen(argv[command_line_flag + 1], "r");
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
  return 0;
}
