#ifndef __AST_H__
#define __AST_H__

#include "symbol.h"

typedef enum {
  IF, ELIF, IF_ELSE,
  BIT_NOT, BIT_AND, BIT_OR, BOOL_NOT,
  INT_CONST_LIST, TYPE, CHAR, STR, TRUE, FALSE,
  L_VALUE, FUNC_DEF, ID_LIST, LET, FOR, SEQ,
  ID, CONST, PLUS, MINUS, TIMES, DIV, MOD,
  LT, GT, LE, GE, EQ, NE, AND, OR, VAR_DEF, BLOCK
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
//ast ast_for (ast l, ast r);
//ast ast_if (ast l, ast r);
ast ast_seq (ast f, ast s);
ast ast_var_def (char *string, ast f, ast s);
//ast ast_block (ast f, ast s);
ast ast_func_def (ast f, ast s, ast t);
ast ast_id_list (char *s, ast f);
ast ast_l_value (ast f, ast s);
ast ast_type (Type t, ast f);
ast ast_int_const_list (int n, ast f);
ast ast_bool_not (ast f);
ast ast_bit_not (ast f);
ast ast_if (ast f, ast s, ast t);
ast ast_elif (ast f, ast s, ast t);
ast ast_if_else (ast f, ast s, ast t, ast l);

void ast_sem (ast t);

int ast_run (ast t);

#endif
