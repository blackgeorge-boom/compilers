#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "error.h"
#include "symbol.h"

static ast ast_make (kind k, char *s, int n,
	   				ast first, ast second, ast third, ast fourth, Type t) {
  ast p;
  if ((p = malloc(sizeof(struct node))) == NULL)
    exit(1);
  p->k = k;
  p->id = s;
  p->num = n;
  p->first = first;
  p->second = second;
  p->third = third;
  p->fourth = fourth;
  p->type = t;
  return p;
}

ast ast_id (char *s) {
  printf("ast_id %s\n", s);
  return ast_make(ID, s, 0, NULL, NULL, NULL, NULL, NULL);
}

ast ast_const (int n) {
  return ast_make(CONST, '\0', n, NULL, NULL, NULL, NULL, NULL);
}

ast ast_op (ast f, kind op, ast s) {
  return ast_make(op, '\0', 0, f, s, NULL, NULL, NULL);
}

ast ast_let (ast f, ast s) {
  return ast_make(LET, '\0', 0, f, s, NULL, NULL, NULL);
}
/*
ast ast_for (ast l, ast r) {
  return ast_make(FOR, '\0', 0, l, r, NULL);
}

ast ast_if (ast l, ast r) {
  return ast_make(IF, '\0', 0, l, r, NULL);
}
*/

ast ast_seq (ast f, ast s) {
  if (s == NULL) return f;
  return ast_make(SEQ, '\0', 0, f, s, NULL, NULL, NULL);
}

ast ast_var_def (char *s, ast f, Type t) {
  return ast_make(VAR_DEF, s, 0, f, NULL, NULL, NULL, t);
}

ast ast_id_list (char *s, ast f) {
  return ast_make(ID_LIST, s, 0, f, NULL, NULL, NULL, NULL);
}

ast ast_func_def (ast f, ast s, ast t) {
  return ast_make(FUNC_DEF, '\0', 0, f, s, t, NULL, NULL);
}

/*
ast ast_block (ast l, ast r) {
  if (r == NULL) return l;
  return ast_make(BLOCK, '\0', 0, l, r, NULL);
}
*/

#define NOTHING 0

struct activation_record_tag {
  struct activation_record_tag * previous;
  int data[0];
};

typedef struct activation_record_tag * activation_record;

activation_record current_AR = NULL;

int ast_run (ast t) {
  if (t == NULL) return NOTHING;
  switch (t->k) {
	  /*
  case PRINT:
    printf("%d\n", ast_run(t->first));
    return NOTHING;
	*/
  case LET: {
    activation_record ar = current_AR;
    for (int i = 0; i < t->nesting_diff; ++i) ar = ar->previous;
    ar->data[t->offset] = ast_run(t->first);
    return NOTHING;
  }
  case FOR:
    for (int i = 0, times = ast_run(t->first); i < times; ++i)
      ast_run(t->second);
    return NOTHING;
  case IF:
    if (ast_run(t->first) != 0) ast_run(t->second);
    return NOTHING;
  case SEQ:
    ast_run(t->first);
    ast_run(t->second);
    return NOTHING;
	/*
  case DECL:
    return NOTHING;
	*/
  case BLOCK: {
    activation_record new_AR =
        (activation_record) malloc(
            sizeof(struct activation_record_tag) +
            t->num_vars * sizeof(int));
    new_AR->previous = current_AR;
    current_AR = new_AR;
    for (int i = 0; i < t->num_vars; ++i) new_AR->data[i] = 0;
    ast_run(t->first);
    ast_run(t->second);
    current_AR = current_AR->previous;
    free(new_AR);
    return NOTHING;
  }
  case ID: {
    activation_record ar = current_AR;
    for (int i = 0; i < t->nesting_diff; ++i) ar = ar->previous;
    return ar->data[t->offset];
  }
  case CONST:
    return t->num;
  case PLUS:
    return ast_run(t->first) + ast_run(t->second);
  case MINUS:
    return ast_run(t->first) - ast_run(t->second);
  case TIMES:
    return ast_run(t->first) * ast_run(t->second);
  case DIV:
    return ast_run(t->first) / ast_run(t->second);
  case MOD:
    return ast_run(t->first) % ast_run(t->second);
  case LT:
    return ast_run(t->first) < ast_run(t->second);
  case GT:
    return ast_run(t->first) > ast_run(t->second);
  case LE:
    return ast_run(t->first) <= ast_run(t->second);
  case GE:
    return ast_run(t->first) >= ast_run(t->second);
  case EQ:
    return ast_run(t->first) == ast_run(t->second);
  case NE:
    return ast_run(t->first) != ast_run(t->second);
  case AND:
    return ast_run(t->first) && ast_run(t->second);
  case OR:
    return ast_run(t->first) || ast_run(t->second);
	/*
  case NOT:
    return !ast_run(t->first);
	*/
  }
}

SymbolEntry * lookup(char *s) {
  char *name;
  name = s;
  return lookupEntry(name, LOOKUP_ALL_SCOPES, true);
}

SymbolEntry * insert(char *s, Type t) {
  char *name;
  name = s;
  return newVariable(name, t);
}

void ast_sem (ast t) {
  if (t == NULL) return;
  switch (t->k) {
  case LET: {
	printf("LET\n");
    ast_sem(t->first);
    SymbolEntry * e = lookup(t->first->id);
    ast_sem(t->second);
    if (!equalType(e->u.eVariable.type, t->second->type))
      error("type mismatch in assignment");
    t->nesting_diff = currentScope->nestingLevel - e->nestingLevel;
    t->offset = e->u.eVariable.offset;
    return;
  }
/*
  case FOR:
    ast_sem(t->first);
    if (!equalType(t->first->type, typeInteger))
      error("for loop expects an integer number");
    ast_sem(t->second);
    return;
  case IF:
    ast_sem(t->first);
    if (!equalType(t->first->type, typeBoolean))
      error("if expects a boolean condition");
    ast_sem(t->second);
    return;
	*/
  case SEQ:
	printf("SEQ\n");
    ast_sem(t->first);
    ast_sem(t->second);
    return;
  case ID: {
	printf("ID %s\n", t->id);
    SymbolEntry *e = lookup(t->id);
	printf("ID2\n");
    t->type = e->u.eVariable.type;
	printf("ID3\n");
    t->nesting_diff = currentScope->nestingLevel - e->nestingLevel;
	printf("ID4\n");
    t->offset = e->u.eVariable.offset;
    return;
  }
  case CONST:
	printf("CONST\n");
    t->type = typeInteger;
    return;
  case PLUS:
	printf("PLUS\n");
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeInteger) ||
        !equalType(t->second->type, typeInteger))
      error("type mismatch in + operator");
    t->type = typeInteger;
    return;
  case MINUS:
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeInteger) ||
        !equalType(t->second->type, typeInteger))
      error("\rtype mismatch in - operator");
    t->type = typeInteger;
    return;
  case TIMES:
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeInteger) ||
        !equalType(t->second->type, typeInteger))
      error("type mismatch in * operator");
    t->type = typeInteger;
    return;
  case DIV:
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeInteger) ||
        !equalType(t->second->type, typeInteger))
      error("type mismatch in / operator");
    t->type = typeInteger;
    return;
  case MOD:
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeInteger) ||
        !equalType(t->second->type, typeInteger))
      error("type mismatch in % operator");
    t->type = typeInteger;
    return;
	/*
  case EQ:
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeInteger) ||
        !equalType(t->second->type, typeInteger))
      error("type mismatch in = operator");
    t->type = typeBoolean;
    return;
  case NE:
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeInteger) ||
        !equalType(t->second->type, typeInteger))
      error("type mismatch in <> operator");
    t->type = typeBoolean;
    return;
  case LT:
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeInteger) ||
        !equalType(t->second->type, typeInteger))
      error("type mismatch in < operator");
    t->type = typeBoolean;
    return;
  case LE:
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeInteger) ||
        !equalType(t->second->type, typeInteger))
      error("type mismatch in <= operator");
    t->type = typeBoolean;
    return;
  case GT:
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeInteger) ||
        !equalType(t->second->type, typeInteger))
      error("type mismatch in > operator");
    t->type = typeBoolean;
    return;
  case GE:
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeInteger) ||
        !equalType(t->second->type, typeInteger))
      error("type mismatch in >= operator");
    t->type = typeBoolean;
    return;
  case AND:
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeBoolean) ||
        !equalType(t->second->type, typeBoolean))
      error("type mismatch in and operator");
    t->type = typeBoolean;
    return;
  case OR:
    ast_sem(t->first);
    ast_sem(t->second);
    if (!equalType(t->first->type, typeBoolean) ||
        !equalType(t->second->type, typeBoolean))
      error("type mismatch in or operator");
    t->type = typeBoolean;
    return;
  case NOT:
    ast_sem(t->first);
    if (!equalType(t->first->type, typeBoolean))
      error("type mismatch in not operator");
    t->type = typeBoolean;
    return;
	*/
  case ID_LIST:
	printf("ID_LIST\n");
	return;
  case VAR_DEF:
	printf("VAR_DEF %s %d\n", t->id, t->type);
    insert(t->id, t->type);
	printf("VAR_DEF2\n");

	if (t->first != NULL) {
		printf("VAR_DEF3\n");		
		t->first->k = VAR_DEF;
		t->first->type = t->type;
		ast_sem(t->first);

	}

	return;
  case FUNC_DEF:
	printf("FUNC_DEF\n");
    openScope();
    //ast_sem(t->first);
    ast_sem(t->second);
    t->num_vars = currentScope->negOffset;
    ast_sem(t->third);
    closeScope();
    return;
  }
}
