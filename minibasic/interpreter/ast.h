#ifndef __AST_H__
#define __AST_H__

typedef enum {
  PRINT, LET, FOR, IF, SEQ,
  ID, CONST, PLUS, MINUS, TIMES, DIV, MOD
} kind;

typedef struct node {
  kind k;
  char id;
  int num;
  struct node *left, *right;
} *ast;

ast ast_id (char c);
ast ast_const (int n);
ast ast_op (ast l, kind op, ast r);
ast ast_print (ast l);
ast ast_let (char c, ast l);
ast ast_for (ast l, ast r);
ast ast_if (ast l, ast r);
ast ast_seq (ast l, ast r);

int ast_run (ast t);

#endif
