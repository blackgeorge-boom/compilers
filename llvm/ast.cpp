#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

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

void print_loop_list () {

    loop_record t = current_LR;

    printf("===== Loop Records : ======\n");

    while (t != nullptr) {
        if (t->id == nullptr) printf("Unamed loop\n");
        else printf("%s\n", t->id);
        t = t->previous;
    }

    printf("==========\n");
}

int look_up_loop (char *s) {

    loop_record t = current_LR;

    while (t != nullptr) {
        if (t->id != nullptr)
            if (strcmp(t->id, s) == 0) return 1;
        t = t->previous;
    }

    return 0;
}


ast find_code (char *func_name) {

    function_code_list temp = current_CL;
    while (temp != nullptr) { // TODO maybe optimize
        if (strcmp(temp->name, func_name) == 0) return temp->code;
        temp = temp->next;
    }

    return nullptr;
}

void print_code_list () {

    function_code_list temp = current_CL;
    printf("===== Current Code List =====\n");
    while (temp != nullptr) {
        printf("%s\n", temp->name);
        temp = temp->next;
    }
    printf("=============================\n");
}

void insert_func_code (char *func_name, ast code) {

    auto new_code = new struct function_code_list_t;
    new_code->name = func_name;
    new_code->code = code;
    new_code->next = current_CL;
    current_CL = new_code;
}

/*
int ast_run (ast t) {
    if (t == nullptr) return NOTHING;
    switch (t->k) {
//    case PRINT:
//      printf("%d\n", ast_run(t->first));
//      return NOTHING;
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
//          case DECL:
//            return NOTHING;
        case BLOCK: {
            auto new_AR =
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
//          case NOT:
//            return !ast_run(t->first);
        case IARRAY_TYPE:break;
        case CHAR:break;
        case PROGRAM:break;
        case PROC_CALL:break;
        case HEADER:break;
        case FPAR_DEF:break;
        case ELIF:break;
        case IF_ELSE:break;
        case LOOP:break;
        case BREAK:break;
        case CONTINUE:break;
        case BIT_NOT:break;
        case BIT_AND:break;
        case BIT_OR:break;
        case BOOL_NOT:break;
        case BOOL_AND:break;
        case BOOL_OR:break;
        case INT_CONST_LIST:break;
        case TYPE:break;
        case REF_TYPE:break;
        case STR:break;
        case TRUE:break;
        case FALSE:break;
        case L_VALUE:break;
        case FUNC_DEF:break;
        case ID_LIST:break;
        case VAR_DEF:break;
        case FUNC_CALL:break;
        case RETURN:break;
    }
}
*/

SymbolEntry* lookup(char *s) {
    char *name;
    name = s;
    return lookupEntry(name, LOOKUP_ALL_SCOPES, true);
}

SymbolEntry* insert(char *s, Type t) {
    char *name;
    name = s;
    return newVariable(name, t);
}

/*
 * If function does not exists in the symbol table, insert it.
 * Else if it does exist, check if it was declared (but not defined) before.
 * This is done by looking it up in the code_list.
 * If it does not exist in the code list, return nullptr. It will be handled later.
 * If it does exist in the code list, it means it was redefined -> exit with error.
 */
SymbolEntry* insertFunction(char *s, Type t) {
    char *name;
    name = s;
    if (lookupEntry(name, LOOKUP_ALL_SCOPES, false)) {
        if (find_code(name)) fatal("Function %s already defined", name);
        return nullptr;
    }
//    printf("inserted function %s\n", name);
    SymbolEntry *e = newFunction(name);
    e->u.eFunction.resultType = t;
    return e;
}

SymbolEntry * insertParameter(char *s, Type t, SymbolEntry *f) {
    char *name;
    name = s;
    PassMode mode = PASS_BY_VALUE;
    if (t->kind == Type_tag::TYPE_POINTER) {
        mode = PASS_BY_REFERENCE;
        t = t->refType;
    }
    SymbolEntry *e = newParameter(name, t, mode, f);
    return e;
}

void print_ast_node (ast f) {

    printf("====== Node Info =====\n");
    if (f == nullptr) {
        printf("nullptr node\n");
        printf("======================\n");
        return;
    }

    printf(" Kind : %d\n", f->k);
    printf(" Id : %s\n", f->id);
    printf(" Num : %d\n", f->num);
    if (f->type == nullptr) printf(" Type : nullptr\n");
    else {
        printf(" Type : %d\n", f->type->kind);
        if (f->type->refType != nullptr)
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
//    printf("var_def_type \n");
    if (f == nullptr) return t;
//    printf("var_def_type3\n");
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
ast l_value_type (ast f, int count)
{
    if (f->k == ID) {

        SymbolEntry * e = lookup(f->id);
        if (e == nullptr) error("l_value_type - Undeclared variable : %s", f->id);

        int i;
        Type temp = e->u.eVariable.type;
        for (i = count; i > 0; --i) {
            if (temp->refType == nullptr)
                error("Too many dimensions");
            temp = temp->refType;
        }

        ast p;
        if ((p = new struct node) == nullptr)
            exit(1);
        p->type = temp;
        p->nesting_diff = currentScope->nestingLevel - e->nestingLevel;
        p->offset = e->u.eVariable.offset;
        return p;
    }
    else if (f->k == STR) {
        Type temp = f->type;

        if (count > 1) {
            error("Too many dimensions for string");
        }
        else if (count == 1) {
            temp = temp->refType;
        }

        ast p;
        if ((p = new struct node) == nullptr)
            exit(1);
        p->type = temp;

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

Type check_op_type(Type first, Type second, std::string op) {

    Type result = typeInteger;

    if (equalType(first, typeInteger)) {
        if (!equalType(second, typeInteger) && !equalType(second, typeChar))
            error("type mismatch in %s operator", op.c_str());
        else
            result = typeInteger;
    }
    else if (equalType(first, typeChar)) {
        if (!equalType(second, typeInteger) && !equalType(second, typeChar))
            error("type mismatch in %s operator", op.c_str());
        else if (equalType(second, typeInteger))
            result = typeInteger;
        else
            result = typeChar;
    }
    else
        error("type mismatch in %s operator", op.c_str());

    return result;
}

/*
 * This function is called during a 'return' command. 
 * It takes the result type of a function
 * and the type of the returned expression
 * and checks if they are compatible.
 */
void check_result_type (Type first, Type second, std::string func_name)
{
    // Check if the return was during a procedure
    if (equalType(first, typeVoid)) {
        fatal("Proc %s does not return value", func_name.c_str());
    }
        // Check if an integer is returned as byte
    else if (equalType(first, typeChar) && equalType(second, typeInteger)) {
        fatal("Result type must be a byte, not an integer in %s", func_name.c_str());
    }
}

/*
 * This function compares the real and the typical parameters during
 * a function or a procedure call. 
 * f : the callers name
 * first : first real parameter
 * second : list with the rest real parameters
 * call_type : "func" or "proc", to help messages
 */
void check_parameters (SymbolEntry *f, ast first, ast second, std::string call_type) {

    ast real_param = first;
    ast real_param_list = second;
    SymbolEntry *func_param = f->u.eFunction.firstArgument;

    while (real_param != nullptr && func_param != nullptr) {
        ast_sem(real_param);
        Type real_param_type = real_param->type;
        Type func_param_type = func_param->u.eParameter.type;

        /*
         * If the types of the real and the typical parameters are not equal
         * then print error message.
         * Except when the 1st dimension of the
         * real parameter is an Array and
         * the 1st dimension of the typical parameter is an IArray.
         * Both Arrays must refer to the same types.
         */
        if (!equalType(real_param_type, func_param_type) &&
            !(real_param_type->kind == Type_tag::TYPE_ARRAY
              && func_param_type->kind == Type_tag::TYPE_IARRAY
              && equalType(real_param_type->refType, func_param_type->refType)))
            fatal("Type mismatch in	%s call argument %s", call_type.c_str(), func_param->id);
        func_param = func_param->u.eParameter.next;
        if (real_param_list == nullptr) {
            real_param = nullptr;
            break;
        }
        real_param = real_param_list->first;
        real_param_list = real_param_list->second;
    }
    if (real_param != nullptr || func_param != nullptr)
        fatal("Incorrect number of parameters at %s call", call_type.c_str());
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
//            printf("FUNC_DEF curr_func_name : %s \n", curr_func_name);
            ast_sem(t->third);
            insert_func_code(t->first->id, t->third);
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
//            printf("HEADER\n");
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
//            printf("PROGRAM\n");
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
