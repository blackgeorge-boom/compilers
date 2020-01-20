//
// Created by blackgeorge on 5/27/19.
//

#ifndef DANA_LLVM_AUXILIARY_H
#define DANA_LLVM_AUXILIARY_H

#include "ast.h"

/*******************************************
 * Auxiliary functions for symbol table
 *******************************************/

SymbolEntry* lookup(char* s);
SymbolEntry* insertVariable(char* s, Type t);

/**
 * If function does not exists in the symbol table, insert it.
 * Else if it does exist, check if it was declared (but not defined) before.
 * This is done by looking it up in the code_list.
 * If it does not exist in the code list, return nullptr. It will be handled later.
 * If it does exist in the code list, it means it was redefined -> exit with error.
 */
SymbolEntry* insertFunction(char* s, Type t);

SymbolEntry* insertParameter(char* s, Type t, SymbolEntry* f);

/*******************************************
 * Auxiliary functions
 *******************************************/

void print_ast_node(ast f);

/**
 * This function returns the Type of the
 * expression x[i1]...[in].
 * x is either "int" or "byte".
 */
Type var_def_type(Type t, ast f);

/**
 * This function handles expressions:
 * 1) x[i1]...[in]
 * 2) "abc" or "abc"[i]
 * First, it checks the dimensions from right to left,
 * while it traverses the l_value ast tree.
 * and then it returns an ast with the appropriate type.
 * For case 1), it returns also nesting diff and offset.
 */
ast l_value_type(ast f, int count);

/*******************************************
 * Semantic check functions
 *******************************************/

/**
 * This function takes two types as input, and returns
 * the result type or exits with an error for type mismatch.
 * The result type is :
 *  1) Integer `op` Integer ==> Integer
 *  2) Integer `op` Byte ==> Integer
 *  3) Byte `op` Integer ==> Integer
 *  4) Byte `op` Byte ==> Byte
 *  5) Anything else ==> Type mismatch
 */
Type check_op_type(Type first, Type second, std::string op);

/**
 * This function is called during a 'return' command.
 * It takes the result type of a function
 * and the type of the returned expression
 * and checks if they are compatible.
 */
void check_result_type(Type first, Type second, std::string func_name);

/**
 * This function compares the real and the typical parameters during
 * a function or a procedure call.
 * f : the callers name
 * first : first real parameter
 * second : list with the rest real parameters
 * call_type : "func" or "proc", to help messages
 */
void check_parameters(SymbolEntry* f, ast first, ast second, const std::string& call_type);

/**
 * Activation record
 */
struct activation_record_tag {
  struct activation_record_tag* previous;
  int data[0];
};

typedef struct activation_record_tag* activation_record;

/**
 * Loop Record
 * This struct represents a list of nested loops.
 * -Id is the identifier of the current loop.
 * -State is boolean. If state becomes false, then
 *  this struct (which represents a loop) must terminate.
 * -Previous points to the loop of the next outermost scope.
 */
struct loop_record_tag {
    char* id;
    char state;
    llvm::BasicBlock* loop_block;
    llvm::BasicBlock* after_block;
    struct loop_record_tag* previous;
};

typedef struct loop_record_tag* loop_record;

extern loop_record current_LR;

void print_loop_list();

loop_record look_up_loop(char* s);

/**
 * Function code list
 * Each node of the list has :
 * 1) a function name
 * 2) a pointer to the corresponding ast
 *    which represents the code of the function
 * 3) the function result type (typeVoid for proc)
 * 4) a pointer to the next node
 */
struct function_code_list_t {
    char* name;
    ast code;
    struct function_code_list_t* next;
};

typedef struct function_code_list_t* function_code_list;

extern function_code_list current_CL;

ast find_code(char* func_name);
void print_code_list();
void insert_func_code(char* func_name, ast code);

extern std::vector<char*> func_names;
extern char* curr_func_name;

std::vector<llvm::Type*> var_members(ast t);

std::vector<std::string> fix_arg_names(ast t);

#endif //DANA_LLVM_AUXILIARY_H
