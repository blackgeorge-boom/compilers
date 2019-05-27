#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"
#include "auxiliary.h"

loop_record current_LR = nullptr;
function_code_list current_CL = nullptr;
char* curr_func_name;

static ast ast_make (kind k, char *s, int n,
                     ast first, ast second, ast third, ast last, Type t) {
    ast p;
    if ((p = new struct node) == nullptr)
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
    return ast_make(ID, s, 0, nullptr, nullptr, nullptr, nullptr, nullptr);
}

ast ast_const (int n) {
    return ast_make(CONST, nullptr, n, nullptr, nullptr, nullptr, nullptr, nullptr);
}

ast ast_char (int n) {
    return ast_make(CHAR, nullptr, n, nullptr, nullptr, nullptr, nullptr, nullptr);
}

ast ast_str (char* s) {
    Type t = typeArray(static_cast<RepInteger>(strlen(s) + 1), typeChar);
    return ast_make(STR, s, 0, nullptr, nullptr, nullptr, nullptr, t);
}

ast ast_true () {
    return ast_make(TRUE, nullptr, 1, nullptr, nullptr, nullptr, nullptr, nullptr);
}

ast ast_false () {
    return ast_make(FALSE, nullptr, 0, nullptr, nullptr, nullptr, nullptr, nullptr);
}

ast ast_bit_not (ast f) {
    return ast_make(BIT_NOT, nullptr, 0, f, nullptr, nullptr, nullptr, nullptr);
}

ast ast_bit_and (ast f, ast s) {
    return ast_make(BIT_AND, nullptr, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_bit_or (ast f, ast s) {
    return ast_make(BIT_OR, nullptr, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_bool_not (ast f) {
    return ast_make(BOOL_NOT, nullptr, 0, f, nullptr, nullptr, nullptr, nullptr);
}

ast ast_bool_and (ast f, ast s) {
    return ast_make(BOOL_AND, nullptr, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_bool_or (ast f, ast s) {
    return ast_make(BOOL_OR, nullptr, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_op (ast f, kind op, ast s) {
    return ast_make(op, nullptr, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_let (ast f, ast s) {
    return ast_make(LET, nullptr, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_seq (ast f, ast s) {
    //if (s == nullptr) return f;
    return ast_make(SEQ, nullptr, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_var_def (char *string, ast f, ast s) {
    return ast_make(VAR_DEF, string, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_id_list (char *s, ast f) {
    return ast_make(ID_LIST, s, 0, f, nullptr, nullptr, nullptr, nullptr);
}

ast ast_func_def (ast f, ast s, ast t) {
    return ast_make(FUNC_DEF, nullptr, 0, f, s, t, nullptr, nullptr);
}

ast ast_func_decl(ast f) {
    return ast_make(FUNC_DECL, nullptr, 0, f, nullptr, nullptr, nullptr, nullptr);
}

ast ast_type (Type t, ast f) {
    return ast_make(TYPE, nullptr, 0, f, nullptr, nullptr, nullptr, t);
}

ast ast_int_const_list (int n, ast f) {
    return ast_make(INT_CONST_LIST, nullptr, n, f, nullptr, nullptr, nullptr, nullptr);
}

/*
ast ast_block (ast l, ast r) {
  if (r == nullptr) return l;
  return ast_make(BLOCK, '\0', 0, l, r, nullptr);
}
*/

ast ast_l_value (ast f, ast s) {
    return ast_make(L_VALUE, nullptr, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_if (ast f, ast s, ast t) {
    return ast_make(IF, nullptr, 0, f, s, t, nullptr, nullptr);
}

ast ast_elif (ast f, ast s, ast t) {
    return ast_make(ELIF, nullptr, 0, f, s, t, nullptr, nullptr);
}

ast ast_if_else (ast f, ast s, ast t, ast l) {
    return ast_make(IF_ELSE, nullptr, 0, f, s, t, l, nullptr);
}

ast ast_loop (char *s, ast f) {
    return ast_make(LOOP, s, 0, f, nullptr, nullptr, nullptr, nullptr);
}

ast ast_break (char *s) {
    return ast_make(BREAK, s, 0, nullptr, nullptr, nullptr, nullptr, nullptr);
}

ast ast_continue (char *s) {
    return ast_make(CONTINUE, s, 0, nullptr, nullptr, nullptr, nullptr, nullptr);
}

ast ast_header (char *string, ast f, ast s, Type t) {
    return ast_make(HEADER, string, 0, f, s, nullptr, nullptr, t);
}

ast ast_fpar_def (char *string, ast f, ast s) {
    return ast_make(FPAR_DEF, string, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_ref_type (Type t) {
    return ast_make(REF_TYPE, nullptr, 0, nullptr, nullptr, nullptr, nullptr, t);
}

ast ast_iarray_type (ast f, Type t) {
    return ast_make(IARRAY_TYPE, nullptr, 0, f, nullptr, nullptr, nullptr, t);
}

ast ast_proc_call (char *string, ast f, ast s) {
    return ast_make(PROC_CALL, string, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_func_call (char *string, ast f, ast s) {
    return ast_make(FUNC_CALL, string, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_program (ast f) {
    return ast_make(PROGRAM, nullptr, 0, f, nullptr, nullptr, nullptr, nullptr);
}


ast ast_return (ast f) {
    return ast_make(RETURN, nullptr, 0, f, nullptr, nullptr, nullptr, nullptr);
}

void ast_sem (ast t) {
    if (t == nullptr) return;
    switch (t->k) {
        case LET: {
//            printf("LET\n");
            ast_sem(t->first);
            ast_sem(t->second);
//            printf("LET finished first - second\n");
            if (!equalType(t->first->type, t->second->type) &&
                !(equalType(t->first->type, typeInteger) && equalType(t->second->type, typeChar))
                    )
                error("Type mismatch in assignment");
            t->nesting_diff = t->first->nesting_diff;
            t->offset = t->first->offset;
            return;
        }
        case SEQ:
//            printf("SEQ\n");
            ast_sem(t->first);
            //if (t->second != nullptr)
            ast_sem(t->second);
            return;
        case ID: { //TODO for n-dimensional array
            SymbolEntry *e = lookup(t->id);

            if (e == nullptr)
                error("ID - Undeclared variable : %s", t->id);

            t->type = e->u.eVariable.type;
            t->nesting_diff = currentScope->nestingLevel - e->nestingLevel;
            t->offset = e->u.eVariable.offset;
            return;
        }
        case CONST:
            t->type = typeInteger;
            return;
        case CHAR:
            t->type = typeChar;
            return;
        case STR:
            return;
        case TRUE:
            t->type = typeChar;
            return;
        case FALSE:
            t->type = typeChar;
            return;
        case BIT_NOT:
            ast_sem(t->first);
            t->type = t->first->type;
            return;
        case BIT_AND:
            ast_sem(t->first);
            ast_sem(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "&");
            return;
        case BIT_OR:
            ast_sem(t->first);
            ast_sem(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "|");
            return;
        case BOOL_NOT:
            ast_sem(t->first);
            t->type = typeChar;
            return;
        case BOOL_AND:
            ast_sem(t->first);
            ast_sem(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "and");
            return;
        case BOOL_OR:
            ast_sem(t->first);
            ast_sem(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "or");
            return;
        case PLUS:
            ast_sem(t->first);
            ast_sem(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "+");
            return;
        case MINUS:
            ast_sem(t->first);
            ast_sem(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "-");
            return;
        case TIMES:
            ast_sem(t->first);
            ast_sem(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "*");
            return;
        case DIV:
            ast_sem(t->first);
            ast_sem(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "/");
            return;
        case MOD:
            ast_sem(t->first);
            ast_sem(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "%");
            return;
        case EQ:
            ast_sem(t->first);
            ast_sem(t->second);
            check_op_type(t->first->type, t->second->type, "=");
            t->type = typeChar;
            return;
        case NE:
            ast_sem(t->first);
            ast_sem(t->second);
            check_op_type(t->first->type, t->second->type, "<>");
            t->type = typeChar;
            return;
        case LT:
            ast_sem(t->first);
            ast_sem(t->second);
            check_op_type(t->first->type, t->second->type, "<");
            t->type = typeChar;
            return;
        case GT:
            ast_sem(t->first);
            ast_sem(t->second);
            check_op_type(t->first->type, t->second->type, ">");
            t->type = typeChar;
            return;
        case LE:
            ast_sem(t->first);
            ast_sem(t->second);
            check_op_type(t->first->type, t->second->type, "<=");
            t->type = typeChar;
            return;
        case GE:
            ast_sem(t->first);
            ast_sem(t->second);
            check_op_type(t->first->type, t->second->type, ">=");
            t->type = typeChar;
            return;
        case ID_LIST:
            return;
        case VAR_DEF:
        {
//            printf("VAR_DEF %s \n", t->id);
            ast_sem(t->second);
            insert(t->id, t->second->type);

            ast temp = t->first;
            while (temp != nullptr) {
                insert(temp->id, t->second->type);
                temp = temp->first;
            }
            return;
        }
        case FUNC_DEF:
            ast_sem(t->first);
            ast_sem(t->second);
            t->num_vars = currentScope->negOffset;
            //strcpy(curr_func_name, t->first->id);
            curr_func_name = t->first->id;
            printf("FUNC_DEF curr_func_name : %s \n", curr_func_name);
            ast_sem(t->third);
            insert_func_code(t->first->id, t->third);
            closeScope();
            return;
        case FUNC_DECL:
            printf("FUNC_DECL\n");
            ast_sem(t->first);
            closeScope();
            return;
        case L_VALUE:
        {
//            printf("L_VALUE\n");
            ast p = l_value_type(t, 0);
            t->type = p->type;
            t->nesting_diff = p->nesting_diff;
            t->offset = p->offset;
            free(p);
            return;
        }
        case TYPE:
//            printf("TYPE\n");
            t->type = var_def_type(t->type, t->first);
            return;
        case REF_TYPE:
//            printf("REF_TYPE\n");
            t->type = typePointer(t->type);
            return;
        case IARRAY_TYPE:
        {
//            printf("IARRAY_TYPE\n");
            Type my_type = var_def_type(t->type, t->first);
            t->type = typeIArray(my_type);
            return;
        }
        case INT_CONST_LIST:
            return;
        case IF:
//            printf("IF\n");
            ast_sem(t->first);
            if (!equalType(t->first->type, typeInteger) && !equalType(t->first->type, typeChar))
                error("Condition must be Integer or Byte!");
            ast_sem(t->second);
            ast_sem(t->third);
            return;
        case ELIF:
//            printf("ELIF\n");
            ast_sem(t->first);
            if (!equalType(t->first->type, typeInteger) && !equalType(t->first->type, typeChar))
                error("Condition must be Integer or Byte!");
            ast_sem(t->second);
            ast_sem(t->third);
            return;
        case IF_ELSE:
//            printf("IF_ELSE\n");
            ast_sem(t->first);
            if (!equalType(t->first->type, typeInteger) && !equalType(t->first->type, typeChar))
                error("Condition must be Integer or Byte!");
            ast_sem(t->second);
            ast_sem(t->third);
            ast_sem(t->last);
            return;
        case LOOP:
        {
//            printf("LOOP\n");
            if (t->id != nullptr)
                if (look_up_loop(t->id)) {
                    error("Loop identifier already exists!\n");
                    exit(1);
                }
            auto new_LR = new struct loop_record_tag;
            new_LR->id = t->id;
            new_LR->previous = current_LR;
            current_LR = new_LR;
            ast_sem(t->first);
            current_LR = current_LR->previous;
            free(new_LR);
            return;
        }
        case BREAK:
//            printf("BREAK\n");
            if (t->id != nullptr) {
                if (!look_up_loop(t->id)) {
                    error("Loop identifier does not exist!\n");
                    exit(1);
                }
            }
            else if (current_LR == nullptr)
                error("No loop to break");
            return;
        case CONTINUE:
//            printf("CONTINUE\n");
            if (t->id != nullptr) {
                if (!look_up_loop(t->id)) {
                    error("Loop identifier does not exist!\n");
                    exit(1);
                }
            }
            else if (current_LR == nullptr) error("No loop to continue");
            return;

            /*
             * We need to iterate for every parameter definition (fpar_def)
             * and for every parameter in each definition (T_id).
             */
        case HEADER: {
            Type func_type = typeVoid;
            if (t->type != nullptr) func_type = t->type;    // Check func or proc
            SymbolEntry *f = insertFunction(t->id, func_type);
            if (f == nullptr) {
                return;    // f == nullptr means, function was declared before
            }                        // The rest have already been done
            /*
             * We open the scope of the current function that was
             * just inserted. The name of the function itself, though, has
             * been inserted to the previous scope.
             */
            openScope();
            ast par_def = t->first;    // First is fpar_def
            Type par_type = nullptr;
            ast fpar_def_list = t->second;
            while (par_def != nullptr) {
                ast_sem(par_def->second); // Second is fpar_type
                par_type = par_def->second->type;
                insertParameter(par_def->id, par_type, f);    // Insert first parameter
                ast par_list = par_def->first;
                while (par_list != nullptr) {        // Insert the rest parameters
                    insertParameter(par_list->id, par_type, f);
                    par_list = par_list->first;    // First is the rest of T_ids.
                }
                if (fpar_def_list == nullptr) {
                    break;
                }
                par_def = fpar_def_list->first;    // Now for the rest of fpar_defs.
                fpar_def_list = fpar_def_list->second;
            }
            return;
        }
        case FPAR_DEF:
            return;
        case PROC_CALL:
        {
//            printf("PROC_CALL\n");
            SymbolEntry *proc = lookup(t->id);
            if (proc->u.eFunction.resultType != typeVoid)
                fatal("Cannot call function as a procedure\n");
            check_parameters(proc, t->first, t->second, "proc");
            return;
        }
        case FUNC_CALL:
        {
//            printf("FUNC_CALL\n");
            SymbolEntry *func = lookup(t->id);
            if (func->u.eFunction.resultType == typeVoid)
                fatal("Function must have a return type\n");
            check_parameters(func, t->first, t->second, "func");
            t->type = func->u.eFunction.resultType;
            return;
        }
        case PROGRAM:
            printf("PROGRAM\n");
            openScope();
            ast_sem(t->first);
            closeScope();
            return;
        case RETURN:
        {
//            printf("RETURN\n");
            ast_sem(t->first);
//            printf("curr_func_name : %s \n", curr_func_name);
            SymbolEntry *curr_func = lookup(curr_func_name);
            Type curr_func_type = curr_func->u.eFunction.resultType;
            Type return_type = t->first->type;
            check_result_type(curr_func_type, return_type, curr_func_name);
            return;
        }
        case BLOCK:break;
        case FOR:break;
        case AND:break;
        case OR:break;
    }

}
