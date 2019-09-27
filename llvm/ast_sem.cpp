//
// Created by blackgeorge on 28/8/19.
//

#include "ast_sem.h"

void ast_sem(ast t) {
    if (t == nullptr) return;
    switch (t->k) {
        case LET: {
            ast_sem(t->first);
            ast_sem(t->second);
            if (!equalType(t->first->type, t->second->type))
                error("Type mismatch in assignment");
            t->nesting_diff = t->first->nesting_diff;
            t->offset = t->first->offset;
            return;
        }
        case SEQ:
            ast_sem(t->first);
            //if (t->second != nullptr)
            ast_sem(t->second);
            return;
        case ID: { //TODO for n-dimensional array
            SymbolEntry* e = lookup(t->id);

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
            check_op_type(t->first->type, typeChar, "!");
            t->type = t->first->type;
            return;
        case BIT_AND:
            ast_sem(t->first);
            ast_sem(t->second);
            // Both must bytes
            check_op_type(t->first->type, typeChar, "&");
            t->type = check_op_type(t->first->type, t->second->type, "&");
            return;
        case BIT_OR:
            ast_sem(t->first);
            ast_sem(t->second);
            // Both must bytes
            check_op_type(t->first->type, typeChar, "|");
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
        case UN_PLUS:
            ast_sem(t->second);
            // UN_PLUS operand must be integer
            t->type = check_op_type(typeInteger, t->second->type, "unary +");
            return;
        case UN_MINUS:
            ast_sem(t->second);
            // UN_MINUS operand must be integer
            t->type = check_op_type(typeInteger, t->second->type, "unary -");
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
            ast_sem(t->first);
            closeScope();
            return;
        case L_VALUE:
        {
            ast p = l_value_type(t, 0);
            t->type = p->type;
            t->nesting_diff = p->nesting_diff;
            t->offset = p->offset;
            free(p);
            return;
        }
        case R_VALUE:
        {
            ast_sem(t->first);
            t->type = t->first->type;
            return;
        }
        case TYPE:
            t->type = var_def_type(t->type, t->first);
            return;
        case REF_TYPE:
            t->type = typePointer(t->type);
            return;
        case IARRAY_TYPE:
        {
            Type my_type = var_def_type(t->type, t->first);
            t->type = typeIArray(my_type);
            return;
        }
        case INT_CONST_LIST:
            return;
        case IF:
            ast_sem(t->first);
            if (!equalType(t->first->type, typeInteger) && !equalType(t->first->type, typeChar))
                error("Condition must be Integer or Byte!");
            ast_sem(t->second);
            ast_sem(t->third);
            return;
        case ELIF:
            ast_sem(t->first);
            if (!equalType(t->first->type, typeInteger) && !equalType(t->first->type, typeChar))
                error("Condition must be Integer or Byte!");
            ast_sem(t->second);
            ast_sem(t->third);
            return;
        case IF_ELSE:
            ast_sem(t->first);
            if (!equalType(t->first->type, typeInteger) && !equalType(t->first->type, typeChar))
                error("Condition must be Integer or Byte!");
            ast_sem(t->second);
            ast_sem(t->third);
            ast_sem(t->last);
            return;
        case LOOP:
        {
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
            if (t->id != nullptr) {
                if (!look_up_loop(t->id)) {
                    error("Loop identifier does not exist!\n");
                    exit(1);
                }
            }
            else if (current_LR == nullptr) error("No loop to continue");
            return;

            // We need to iterate for every parameter definition (fpar_def)
            // and for every parameter in each definition (T_id).
        case HEADER: {
            Type func_type = typeVoid;
            if (t->type != nullptr) {
                func_type = t->type;    // Check func or proc
            }

            SymbolEntry* f = insertFunction(t->id, func_type);
            if (f == nullptr) {
                return;    // f == nullptr means, function was declared before
            }                        // The rest have already been done

            // We open the scope of the current function that was
            // just inserted. The name of the function itself, though, has
            // been inserted to the previous scope.
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
            SymbolEntry* proc = lookup(t->id);
            if (proc->u.eFunction.resultType != typeVoid)
                fatal("Cannot call function as a procedure\n");
            check_parameters(proc, t->first, t->second, "proc");
            return;
        }
        case FUNC_CALL:
        {
            SymbolEntry* func = lookup(t->id);
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
            ast_sem(t->first);
            SymbolEntry* curr_func = lookup(curr_func_name);
            Type curr_func_type = curr_func->u.eFunction.resultType;
            Type return_type = t->first->type;
            check_result_type(curr_func_type, return_type, curr_func_name);
            return;
        }
        case EXIT:
        {
            SymbolEntry* curr_func = lookup(curr_func_name);
            Type curr_func_type = curr_func->u.eFunction.resultType;
            Type return_type = typeVoid;
            check_result_type(curr_func_type, return_type, curr_func_name);
            return;
        }
        case SKIP:return;
    }
}