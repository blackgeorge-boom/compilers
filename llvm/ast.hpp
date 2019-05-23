#ifndef __AST_HPP__
#define __AST_HPP__

#include <string>

#include "symbol.h"
#include "error.h"

typedef enum {
  IARRAY_TYPE, CHAR, PROGRAM, PROC_CALL, HEADER, 
  FPAR_DEF, IF, ELIF, IF_ELSE, LOOP, 
  BREAK, CONTINUE, BIT_NOT, BIT_AND, BIT_OR, 
  BOOL_NOT, BOOL_AND, BOOL_OR, INT_CONST_LIST, BLOCK,
  TYPE, REF_TYPE, STR, TRUE, FALSE,
  L_VALUE, FUNC_DEF, ID_LIST, LET, FOR, 
  SEQ, ID, CONST, PLUS, MINUS, 
  TIMES, DIV, MOD, LT, GT, 
  LE, GE, EQ, NE, AND, 
  OR, VAR_DEF, FUNC_CALL, RETURN
} kind;

typedef struct node {
  kind k;
  char *id;
  int num;
  struct node *first, *second, *third, *last;
  Type type;
  int nesting_diff;  // ID and LET nodes
  int offset;        // ID and LET nodes
  int num_vars;      // BLOCK node
} *ast;

ast ast_id (char *s);
ast ast_const (int n);
ast ast_char(int n);
ast ast_str (char *s);
ast ast_true ();
ast ast_false ();
ast ast_op (ast f, kind op, ast s);
ast ast_let (ast f, ast s);
ast ast_seq (ast f, ast s);
ast ast_var_def (char *string, ast f, ast s);
//ast ast_block (ast f, ast s);
ast ast_func_def (ast f, ast s, ast t);
ast ast_id_list (char *s, ast f);
ast ast_l_value (ast f, ast s);
ast ast_type (Type t, ast f);
ast ast_int_const_list (int n, ast f);
ast ast_bool_not (ast f);
ast ast_bool_and (ast f, ast s);
ast ast_bool_or (ast f, ast s);
ast ast_bit_not (ast f);
ast ast_bit_and (ast f, ast s);
ast ast_bit_or (ast f, ast s);
ast ast_if (ast f, ast s, ast t);
ast ast_elif (ast f, ast s, ast t);
ast ast_if_else (ast f, ast s, ast t, ast l);
ast ast_loop (char *s, ast f);
ast ast_break (char *s);
ast ast_continue (char *s);
ast ast_header(char *string, ast f, ast s, Type t);
ast ast_fpar_def(char *string, ast f, ast s);
ast ast_ref_type(Type t);
ast ast_iarray_type(ast f, Type t);
ast ast_proc_call(char *string, ast f, ast s);
ast ast_func_call(char *string, ast f, ast s);
ast ast_program(ast f);
ast ast_return(ast f);

const int NOTHING = 0;

struct activation_record_tag {
  struct activation_record_tag * previous;
  int data[0];
};

typedef struct activation_record_tag* activation_record;

activation_record current_AR = nullptr;

/*
 * This struct represents a list of nested loops.
 * -Id is the identifier of the current loop.
 * -State is boolean. If state becomes false, then
 *  this struct (which represents a loop) must terminate.
 * -Previous points to the loop of the next outermost scope.
 */
struct loop_record_tag {
	char *id;
	char state;
	struct loop_record_tag * previous;
};

typedef struct loop_record_tag * loop_record;

void print_loop_list ();

int look_up_loop (char *s);
    /*
 * Each node of the list has :
 *
 * 1) a function name
 * 2) a pointer to the corresponding ast
 *    which represents the code of the function
 * 3) the function result type (typeVoid for proc)
 * 4) a pointer to the next node
 */
struct function_code_list_t {
	char *name;
	ast code;
	struct function_code_list_t *next;
};

typedef struct function_code_list_t *function_code_list;

function_code_list current_CL = nullptr;

ast find_code (char *func_name);
void print_code_list ();
void insert_func_code (char *func_name, ast code);

char *curr_func_name;

int ast_run(ast t);

loop_record current_LR = nullptr;
SymbolEntry * lookup(char *s);
SymbolEntry * insert(char *s, Type t);
SymbolEntry * insertFunction(char *s, Type t);
SymbolEntry * insertParameter(char *s, Type t, SymbolEntry *f);

void print_ast_node (ast f);
Type var_def_type (Type t, ast f);
ast l_value_type (ast f, int count);
Type check_op_type (Type first, Type second, std::string op);
void check_result_type (Type first, Type second, std::string func_name);
void check_parameters (SymbolEntry *f, ast first, ast second, std::string call_type);

void ast_sem(ast t);

#endif
