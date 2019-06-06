#ifndef __AST_H__
#define __AST_H__

extern "C" {
#include "error.h"
#include "symbol.h"
}

#include <string>

typedef enum {
  IARRAY_TYPE, CHAR, PROGRAM, PROC_CALL, HEADER,
  FPAR_DEF, IF, ELIF, IF_ELSE, LOOP,
  BREAK, CONTINUE, BIT_NOT, BIT_AND, BIT_OR,
  BOOL_NOT, BOOL_AND, BOOL_OR, INT_CONST_LIST, FUNC_DECL,
  TYPE, REF_TYPE, STR, TRUE, FALSE,
  L_VALUE, FUNC_DEF, ID_LIST, LET, FOR,
  SEQ, ID, CONST, PLUS, MINUS,
  TIMES, DIV, MOD, LT, GT,
  LE, GE, EQ, NE, AND,
  OR, VAR_DEF, FUNC_CALL, RETURN,
} kind;

typedef struct node {
  kind k;
  char* id;
  int num;
  struct node *first, *second, *third, *last;
  Type type;
  int nesting_diff;  // ID and LET nodes
  int offset;        // ID and LET nodes
  int num_vars;      // BLOCK node
} *ast;

ast ast_id (char* s);
ast ast_const (int n);
ast ast_char(int n);
ast ast_str (char* s);
ast ast_true ();
ast ast_false ();
ast ast_op (ast f, kind op, ast s);
ast ast_let (ast f, ast s);
ast ast_seq (ast f, ast s);
ast ast_var_def (char* string, ast f, ast s);
ast ast_func_def (ast f, ast s, ast t);
ast ast_func_decl (ast f);
ast ast_id_list (char* s, ast f);
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
ast ast_loop (char* s, ast f);
ast ast_break (char* s);
ast ast_continue (char* s);
ast ast_header(char* string, ast f, ast s, Type t);
ast ast_fpar_def(char* string, ast f, ast s);
ast ast_ref_type(Type t);
ast ast_iarray_type(ast f, Type t);
ast ast_proc_call(char* string, ast f, ast s);
ast ast_func_call(char* string, ast f, ast s);
ast ast_program(ast f);
ast ast_return(ast f);

void ast_sem(ast t);

//int ast_run(ast t);

#endif
