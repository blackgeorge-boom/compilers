#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"
#include "error.h"
#include "symbol.h"

static ast ast_make (kind k, char *s, int n,
	   				 ast first, ast second, ast third, ast last, Type t) {
  ast p;
  if ((p = malloc(sizeof(struct node))) == NULL)
    exit(1);
  p->k = k;
  p->id = s;
  p->num = n;
  p->first = first;
  p->second = second;
  p->third = third;
  p->last = last;
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

ast ast_char (int n) {
  printf("INSIDE AST_CHAR\n");
  return ast_make(CHAR, '\0', n, NULL, NULL, NULL, NULL, NULL);
}

ast ast_str (char *s) {
  printf("ast_str %s\n", s);
  Type t = typeArray(strlen(s) + 1, typeChar);
  return ast_make(STR, s, 0, NULL, NULL, NULL, NULL, t);
}

ast ast_true () {
  return ast_make(TRUE, '\0', 1, NULL, NULL, NULL, NULL, NULL);
}

ast ast_false () {
  return ast_make(FALSE, '\0', 0, NULL, NULL, NULL, NULL, NULL);
}

ast ast_bit_not (ast f) {
  return ast_make(BIT_NOT, '\0', 0, f, NULL, NULL, NULL, NULL);
}

ast ast_bit_and (ast f, ast s) {
  return ast_make(BIT_AND, '\0', 0, f, s, NULL, NULL, NULL);
}

ast ast_bit_or (ast f, ast s) {
  return ast_make(BIT_OR, '\0', 0, f, s, NULL, NULL, NULL);
}

ast ast_bool_not (ast f) {
  return ast_make(BOOL_NOT, '\0', 0, f, NULL, NULL, NULL, NULL);
}

ast ast_bool_and (ast f, ast s) {
  return ast_make(BOOL_AND, '\0', 0, f, s, NULL, NULL, NULL);
}

ast ast_bool_or (ast f, ast s) {
  return ast_make(BOOL_OR, '\0', 0, f, s, NULL, NULL, NULL);
}

ast ast_op (ast f, kind op, ast s) {
  return ast_make(op, '\0', 0, f, s, NULL, NULL, NULL);
}

ast ast_let (ast f, ast s) {
  return ast_make(LET, '\0', 0, f, s, NULL, NULL, NULL);
}

ast ast_seq (ast f, ast s) {
  if (s == NULL) return f;
  return ast_make(SEQ, '\0', 0, f, s, NULL, NULL, NULL);
}

ast ast_var_def (char *string, ast f, ast s) {
  return ast_make(VAR_DEF, string, 0, f, s, NULL, NULL, NULL);
}

ast ast_id_list (char *s, ast f) {
  return ast_make(ID_LIST, s, 0, f, NULL, NULL, NULL, NULL);
}

ast ast_func_def (ast f, ast s, ast t) {
  return ast_make(FUNC_DEF, '\0', 0, f, s, t, NULL, NULL);
}

ast ast_type (Type t, ast f) {
  return ast_make(TYPE, '\0', 0, f, NULL, NULL, NULL, t);
}

ast ast_int_const_list (int n, ast f) {
  return ast_make(INT_CONST_LIST, '\0', n, f, NULL, NULL, NULL, NULL); 
} 
  
/*
ast ast_block (ast l, ast r) {
  if (r == NULL) return l;
  return ast_make(BLOCK, '\0', 0, l, r, NULL);
}
*/

ast ast_l_value (ast f, ast s) {
	return ast_make(L_VALUE, '\0', 0, f, s, NULL, NULL, NULL);
}

ast ast_if (ast f, ast s, ast t) {
	return ast_make(IF, '\0', 0, f, s, t, NULL, NULL);
}

ast ast_elif (ast f, ast s, ast t) {
	return ast_make(ELIF, '\0', 0, f, s, t, NULL, NULL);
}

ast ast_if_else (ast f, ast s, ast t, ast l) {
	return ast_make(IF_ELSE, '\0', 0, f, s, t, l, NULL);
}

ast ast_loop (char *s, ast f) {
  return ast_make(LOOP, s, 0, f, NULL, NULL, NULL, NULL);
}

ast ast_break (char *s) {
  return ast_make(BREAK, s, 0, NULL, NULL, NULL, NULL, NULL);
}

ast ast_continue (char *s) {
  return ast_make(CONTINUE, s, 0, NULL, NULL, NULL, NULL, NULL);
}

ast ast_header (char *string, ast f, ast s, Type t) {
  return ast_make(HEADER, s, 0, f, s, NULL, NULL, t);
}

ast ast_fpar_def (char *string, ast f, ast s) {
  return ast_make(FPAR_DEF, s, 0, f, s, NULL, NULL, NULL);
}

ast ast_ref_type (Type t) {
  return ast_make(REF_TYPE, '\0', 0, NULL, NULL, NULL, NULL, t);
}

ast ast_iarray_type (ast f, Type t) {
  return ast_make(IARRAY_TYPE, '\0', 0, f, NULL, NULL, NULL, t);
}

#define NOTHING 0

struct activation_record_tag {
  struct activation_record_tag * previous;
  int data[0];
};

typedef struct activation_record_tag * activation_record;

activation_record current_AR = NULL;

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

loop_record current_LR = NULL;

void print_loop_list () {

	loop_record t = current_LR;
	
	printf("===== Loop Records : ======\n");

	while (t != NULL) {
		printf("%s\n", t->id);
		t = t->previous;
	}

	printf("==========\n");

	return;
}


int look_up_loop (char *s) {
	
	loop_record t = current_LR;

	while (t != NULL) {
		if (t->id != NULL)
			if (strcmp(t->id, s) == 0) return 1;
		t = t->previous;
	}

	return 0;
}

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
    return ast_run(t->first) <= ast_run(t->second); case GE:
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

SymbolEntry * insertFunction(char *s, Type t) {
  char *name;
  name = s;
  SymbolEntry *e = newFunction(name);
  e->u.eFunction.resultType = t;
  return e;
}

SymbolEntry * insertParameter(char *s, Type t, SymbolEntry *f) {
  char *name;
  name = s;
  PassMode mode = PASS_BY_VALUE;
  if (t->kind == TYPE_POINTER) {
	  mode = PASS_BY_REFERENCE;
	  t = t->refType;
  }
  SymbolEntry *e = newParameter(name, t, mode, f);
  return e;
}

void print_ast_node (ast f) {

	printf("====== Node Info =====\n");
	if (f == NULL) {
		printf("NULL node\n");
		printf("======================\n");
		return;
	}

	printf(" Kind : %d\n", f->k);
	printf(" Id : %s\n", f->id);
	printf(" Num : %d\n", f->num);
	if (f->type == NULL) printf(" Type : NULL\n");
	else {
		printf(" Type : %d\n", f->type->kind);
		if (f->type->refType != NULL) 
			printf("    with refType : %d\n", f->type->refType->kind);
	}
	printf("======================\n");
	
}	

/*
 * This function returns the Type of the
 * expression x[i1]...[in].
 * x is either "int" or "byte".
 */
Type var_def_type (Type t, ast f) {
	printf("var_def_type \n");
	//print_ast_node(f);
	if (f == NULL) return t;
	printf("var_def_type3\n");
	return typeArray(f->num, var_def_type(t, f->first));
}

/*
 * This function handles expressions:
 * 1) x[i1]...[in]
 * 2) "abc" or "abc"[i] 
 * First, it checks the dimensions from right to left, 
 * while it traverses the l_value ast tree.
 * and then it returns an ast with the appropriate type.
 * For case 1), it returns also nesting diff and offset. 
 */
ast l_value_type (ast f, int count) {

	printf("l_value_type \n");
	print_ast_node(f);

	if (f->k == ID) {
		
		printf("l_value_type2 \n");
		SymbolEntry * e = lookup(f->id);
		if (e == NULL) error("l_value_type - Undeclared variable : %s", f->id);

		int i;
		Type temp = e->u.eVariable.type;
		for (i = count; i > 0; --i) {
			if (temp->refType == NULL) 
				error("Too many dimensions");
			temp = temp->refType;
		}

		ast p;
		if ((p = malloc(sizeof(struct node))) == NULL)
			exit(1);
		p->type = temp;
		p->nesting_diff = currentScope->nestingLevel - e->nestingLevel;
		p->offset = e->u.eVariable.offset;
		return p;
	}
	else if (f->k == STR) {
		
			
		printf("l_value_type3 \n");
		int i;
		Type temp = f->type;
		printType(temp);

		if (count > 1) {
			error("Too many dimensions for string");
		}
		else if (count == 1) {
			printf("l_value_type4 \n");
			temp = temp->refType;
			printf("l_value_type5 \n");
		}

		ast p;
		if ((p = malloc(sizeof(struct node))) == NULL)
			exit(1);
		p->type = temp;
		
		printf("end_l_value_type3 \n");
		return p;
	}
	
	ast_sem(f->second);
	if (f->second->type != typeInteger && f->second->type != typeChar) 
		error("Array index must be of type int or byte");
	return l_value_type(f->first, count + 1); 
} 

/*
 * This function takes two types as input, and returns 
 * the result type or exits with an error for type mismatch.
 * The result type is :
 *  1) Integer `op` Integer ==> Integer
 *  2) Integer `op` Byte ==> Integer
 *  3) Byte `op` Integer ==> Integer
 *  4) Byte `op` Byte ==> Byte
 *  5) Anything else ==> Type mismatch
 */

Type check_op_type (Type first, Type second, char *op) {

	Type result;

	if (equalType(first, typeInteger)) {
       	if (!equalType(second, typeInteger) && !equalType(second, typeChar))
			error("type mismatch in %s operator", op);
		else
			result = typeInteger;
	}
	else if (equalType(first, typeChar)) {
		if (!equalType(second, typeInteger) && !equalType(second, typeChar)) 
			error("type mismatch in %s operator", op);
		else if (equalType(second, typeInteger))
			result = typeInteger;
		else 
			result = typeChar;
	}
	else 
		error("type mismatch in %s operator", op);

	return result;
}


void ast_sem (ast t) {
  if (t == NULL) return;
  switch (t->k) {
  case LET: {
	printf("LET\n");
    ast_sem(t->first);
    ast_sem(t->second);
	printf("LET finished first - second\n");
	printType(t->first->type);
	printType(t->second->type);
	if (!equalType(t->first->type, t->second->type) && 
	    !(equalType(t->first->type, typeInteger) && equalType(t->second->type, typeChar))
	   )
    	error("Type mismatch in assignment");
    t->nesting_diff = t->first->nesting_diff;
    t->offset = t->first->offset;
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
	print_ast_node(t->first);
	//if (t->second != NULL)
   	ast_sem(t->second);
    return;
  case ID: { //TODO for n-dimensional array
	printf("ID %s\n", t->id);
    SymbolEntry *e = lookup(t->id);
	printf("ID - %s\n", t->id);
	
	if (e == NULL) 
		error("ID - Undeclared variable : %s", t->id);
/
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
  case CHAR:
  printf("CHAR --- %d\n",t->num);
    t->type = typeChar;
    return;
  case STR:
	printf("STR\n");
    return;
  case TRUE:
	printf("TRUE\n");
    t->type = typeChar;
    return;
  case FALSE:
	printf("FALSE\n");
    t->type = typeChar;
    return;
  case BIT_NOT:
	printf("BIT_NOT\n");
	ast_sem(t->first);
	print_ast_node(t->first);
    t->type = t->first->type;
    return;
  case BIT_AND:
	printf("BIT_AND\n");
	ast_sem(t->first);
	ast_sem(t->second);
    t->type = check_op_type(t->first->type, t->second->type, "&");
    return;
  case BIT_OR:
	printf("BIT_OR\n");
	ast_sem(t->first);
	ast_sem(t->second);
    t->type = check_op_type(t->first->type, t->second->type, "|");
    return;
  case BOOL_NOT:
    printf("BOOL_NOT\n");
    ast_sem(t->first);
    t->type = typeChar;
    return;
  case BOOL_AND:
	printf("BOOL_AND\n");
	ast_sem(t->first);
	ast_sem(t->second);
    t->type = check_op_type(t->first->type, t->second->type, "and");
    return;
  case BOOL_OR:
	printf("BOOL_OR\n");
	ast_sem(t->first);
	ast_sem(t->second);
    t->type = check_op_type(t->first->type, t->second->type, "or");
    return;
  case PLUS:
	printf("PLUS\n");
    ast_sem(t->first);
    ast_sem(t->second);
    t->type = check_op_type(t->first->type, t->second->type, "+");
    return;
  case MINUS:
    printf("MINUS\n");
    ast_sem(t->first);
    ast_sem(t->second);
    t->type = check_op_type(t->first->type, t->second->type, "-");
    return;
  case TIMES:
    printf("TIMES\n");
    ast_sem(t->first);
    ast_sem(t->second);
    t->type = check_op_type(t->first->type, t->second->type, "*");
    return;
  case DIV:
    printf("DIV\n");
    ast_sem(t->first);
    ast_sem(t->second);
    t->type = check_op_type(t->first->type, t->second->type, "/");
    return;
  case MOD:
    printf("MOD\n");
    ast_sem(t->first);
    ast_sem(t->second);
    t->type = check_op_type(t->first->type, t->second->type, "%");
    return;
  case EQ:
	printf("EQ\n");
    ast_sem(t->first);
    ast_sem(t->second);
    check_op_type(t->first->type, t->second->type, "=");
    t->type = typeChar;
    return;
  case NE:
	printf("NE\n");
    ast_sem(t->first);
    ast_sem(t->second);
    check_op_type(t->first->type, t->second->type, "<>");
    t->type = typeChar;
    return;
  case LT:
	printf("LT\n");
    ast_sem(t->first);
    ast_sem(t->second);
    check_op_type(t->first->type, t->second->type, "<");
    t->type = typeChar;
    return;
  case GT:
	printf("GT\n");
    ast_sem(t->first);
    ast_sem(t->second);
    check_op_type(t->first->type, t->second->type, ">");
    t->type = typeChar;
    return;
  case LE:
	printf("LE\n");
    ast_sem(t->first);
    ast_sem(t->second);
    check_op_type(t->first->type, t->second->type, "<=");
    t->type = typeChar;
    return;
  case GE:
	printf("GE\n");
    ast_sem(t->first);
    ast_sem(t->second);
    check_op_type(t->first->type, t->second->type, ">=");
    t->type = typeChar;
    return;
  case ID_LIST:
	printf("ID_LIST\n");
	return;
  case VAR_DEF:
	printf("VAR_DEF %s \n", t->id);
	ast_sem(t->second);
	Type type = t->type;
	printf("VAR_DEF2\n");
	//print_ast_node(ast_type(type, NULL));
    insert(t->id, type);
	printf("VAR_DEF3\n");

	ast temp = t->first;
	while (temp != NULL) {
		printf("VAR_DEF4 %s \n", temp->id);
		insert(temp->id, type);
		temp = temp->first;
	}
	print_ast_node(t);
	return;
  case FUNC_DEF:
	printf("FUNC_DEF\n");
    openScope();
    ast_sem(t->first);
    ast_sem(t->second);
    t->num_vars = currentScope->negOffset;
    ast_sem(t->third);
    closeScope();
    return;
  case L_VALUE:
    printf("L_VALUE\n");
	ast p = l_value_type(t, 0);
	t->type = p->type;
	t->nesting_diff = p->nesting_diff;
    t->offset = p->offset;
	free(p);	
	return;
  case TYPE:
	printf("TYPE\n");
	t->type = var_def_type(t->type, t->first);
	return;
  case REF_TYPE:
	printf("REF_TYPE\n");
	t->type = typePointer(t->type);
	return;
  case IARRAY_TYPE:
	printf("IARRAY_TYPE\n");
	Type type = var_def_type(t->type, t->first);
	t->type = typeIArray(type);
	return;
  case INT_CONST_LIST:
	printf("INT_CONST_LIST\n");
	return;
  case IF:
    printf("IF\n");
	ast_sem(t->first);
	if (!equalType(t->first->type, typeInteger) && !equalType(t->first->type, typeChar))
		error("Condition must be Integer or Byte!");
	ast_sem(t->second);
	ast_sem(t->third);
	return;
  case ELIF:
	printf("ELIF\n");
	ast_sem(t->first);
	if (!equalType(t->first->type, typeInteger) && !equalType(t->first->type, typeChar))
		error("Condition must be Integer or Byte!");
	ast_sem(t->second);
	ast_sem(t->third);
	return;
  case IF_ELSE:
	printf("IF_ELSE\n");
	ast_sem(t->first);
	if (!equalType(t->first->type, typeInteger) && !equalType(t->first->type, typeChar))
		error("Condition must be Integer or Byte!");
	ast_sem(t->second);
	ast_sem(t->third);
	ast_sem(t->last);
	return;
  case LOOP:
	printf("LOOP\n");
	print_ast_node(t);
	print_loop_list();
	if (t->id != NULL) 
		if (look_up_loop(t->id)) {
			error("Loop identifier already exists!\n");
			exit(1);
		}
	loop_record new_LR = malloc(sizeof(struct loop_record_tag));
	new_LR->id = t->id;
	new_LR->previous = current_LR;
	current_LR = new_LR;
	ast_sem(t->first);
	current_LR = current_LR->previous;
	free(new_LR);
	return;
  case BREAK:
	printf("BREAK\n");
	print_ast_node(t);
	if (t->id != NULL) { 
		if (!look_up_loop(t->id)) {
			error("Loop identifier does not exist!\n");
			exit(1);
		}
	}
    else if (current_LR == NULL) error("No loop to break");
	return;
  case CONTINUE:
	printf("CONTINUE\n");
	print_ast_node(t);
	if (t->id != NULL) {
		if (!look_up_loop(t->id)) {
			error("Loop identifier does not exist!\n");
			exit(1);
		}
	}
    else if (current_LR == NULL) error("No loop to continue");
	return;
	
  /*
   * We need to iterate for every parameter definition (fpar_def)
   * and for every parameter in each definition (T_id).
   */
  case HEADER:
	printf("HEADER\n");
	Type func_type = typeVoid;
	if (t->type != NULL) func_type = t->type;	// Check func or proc
	SymbolEntry *f = insertFunction(t->id, func_type);	
	ast par_def = t->first;	//First is fpar_def
	Type par_type = NULL;
	while (par_def != NULL) {
		ast par = par_def->first;	
		ast_sem(par->second); // Second is fpar_type
		par_type = par->second->type;	
		while (par != NULL) {
			insert(par->id, par_type);
			par = par->first;	// First is the rest of T_ids.
		}
		par_def = par_def->second; 	// Second is rest of fpar_defs.
	}
  }

}
