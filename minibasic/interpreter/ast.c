#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

static ast ast_make (kind k, char c, int n, ast l, ast r) {
  ast p;
  if ((p = malloc(sizeof(struct node))) == NULL)
    exit(1);
  p->k = k;
  p->id = c;
  p->num = n;
  p->left = l;
  p->right = r;
  return p;
}
  
ast ast_id (char c) {
  return ast_make(ID, c, 0, NULL, NULL);
}

ast ast_const (int n) {
  return ast_make(CONST, '\0', n, NULL, NULL);
}

ast ast_op (ast l, kind op, ast r) {
  return ast_make(op, '\0', 0, l, r);
}

ast ast_print (ast l) {
  return ast_make(PRINT, '\0', 0, l, NULL);
}

ast ast_let (char c, ast l) {
  return ast_make(LET, c, 0, l, NULL);
}

ast ast_for (ast l, ast r) {
  return ast_make(FOR, '\0', 0, l, r);
}

ast ast_if (ast l, ast r) {
  return ast_make(IF, '\0', 0, l, r);
}

ast ast_seq (ast l, ast r) {
  if (r == NULL) return l;
  return ast_make(SEQ, '\0', 0, l, r);
}

#define NOTHING 0

static int var[26];

int ast_run (ast t) {
  if (t == NULL) return NOTHING;
  switch (t->k) {
  case PRINT:
    printf("%d\n", ast_run(t->left));
    return NOTHING;
  case LET:
    var[t->id - 'a'] = ast_run(t->left);
    return NOTHING;
  case FOR:
    for (int i = 0, times = ast_run(t->left); i < times; ++i)
      ast_run(t->right);
    return NOTHING;
  case IF:
    if (ast_run(t->left) != 0) ast_run(t->right);
    return NOTHING;
  case SEQ:
    ast_run(t->left);
    ast_run(t->right);
    return NOTHING;
  case ID:
    return var[t->id - 'a'];
  case CONST:
    return t->num;
  case PLUS:
    return ast_run(t->left) + ast_run(t->right);
  case MINUS:
    return ast_run(t->left) - ast_run(t->right);
  case TIMES:
    return ast_run(t->left) * ast_run(t->right);
  case DIV:
    return ast_run(t->left) / ast_run(t->right);
  case MOD:
    return ast_run(t->left) % ast_run(t->right);
  }
}
