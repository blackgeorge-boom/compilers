//
// Created by blackgeorge on 5/27/19.
//

#ifndef DANA_LLVM_AUXILIARY_H
#define DANA_LLVM_AUXILIARY_H

#include "ast.h"

const int NOTHING = 0;

struct activation_record_tag {
  struct activation_record_tag * previous;
  int data[0];
};

typedef struct activation_record_tag* activation_record;

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

extern loop_record current_LR;

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

extern function_code_list current_CL;

ast find_code (char *func_name);
void print_code_list ();
void insert_func_code (char *func_name, ast code);

extern char *curr_func_name;

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

#endif //DANA_LLVM_AUXILIARY_H
