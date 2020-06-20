//
// Created by blackgeorge on 5/27/19.
//

extern "C" {
#include "error.h"
#include "symbol.h"
}

#include <cstring>
#include <iostream>
#include "auxiliary.h"
#include "symbol.h"


loop_record look_up_loop (char* s)
{
    loop_record t = current_LR;

    while (t != nullptr) {
        if (t->id != nullptr)
            if (strcmp(t->id, s) == 0) return t;
        t = t->previous;
    }

    return nullptr;
}

ast find_code(char* func_name)
{
    function_code_list temp = current_CL;
    while (temp != nullptr) {
        if (strcmp(temp->name, func_name) == 0) return temp->code;
        temp = temp->next;
    }

    return nullptr;
}


void insert_func_code(char* func_name, ast code)
{
    auto new_code = new struct function_code_list_t;
    new_code->name = func_name;
    new_code->code = code;
    new_code->next = current_CL;
    current_CL = new_code;
}

SymbolEntry* lookup(char* s)
{
    char* name;
    name = s;
    return lookupEntry(name, LOOKUP_ALL_SCOPES, true);
}

SymbolEntry* lookup_weak(char* s)
{
    char* name;
    name = s;
    return lookupEntry(name, LOOKUP_ALL_SCOPES, false);
}

SymbolEntry* insertVariable(char* s, Type t)
{
    char* name;
    name = s;
    SymbolEntry* v = newVariable(name, t);
    if (!v)
        exit(1);
    return v;
}

SymbolEntry* insertFunction(char* s, Type t)
{
    char* name;
    name = s;
    if (lookupEntry(name, LOOKUP_ALL_SCOPES, false)) {
        if (find_code(name)) fatal("Function %s already defined", name);
        return nullptr;
    }

    SymbolEntry* e = newFunction(name);
    e->u.eFunction.resultType = t;
    return e;
}

SymbolEntry* insertParameter(char* s, Type t, SymbolEntry* f)
{
    char* name;
    name = s;
    PassMode mode = PASS_BY_VALUE;
    if (t->kind == Type_tag::TYPE_POINTER) {
        mode = PASS_BY_REFERENCE;
        t = t->refType;
    }
    SymbolEntry* e = newParameter(name, t, mode, f);
    return e;
}

Type var_def_type (Type t, ast f)
{
    if (f == nullptr) return t;
    return typeArray(f->num, var_def_type(t, f->first));
}

/**
 * A tree of l_value will be like:
 * case a)
 *          id
 * case b)
 *          l_value
 *          l_value '[' expr ']'
 *          l_value '[' expr ']' '[' expr ']'
 *                ...
 *          id '[' expr ']' ... '[' expr ']' '[' expr ']'
 * case c)
 *          l_value
 *          l_value '[' expr ']'
 *          str '[' expr ']'
 * case d)
 *          str
 *
 * Keeping that in mind the l_value type will set correctly the type of the f tree.
 * f will be the current ast tree.
 * count will be the number of expressions that we have in brackets until now.
 * Function l_value_type will be called recursively traversing the tree as shown above.
 */
ast l_value_type (ast f, int count)
{
    if (f->k == ID) {

        SymbolEntry*  e = lookup(f->id);  // Find name in symbol table.
        if (e == nullptr) error("l_value_type - Undeclared variable : %s", f->id);

        int i;
        Type temp = e->u.eVariable.type;

        // If count is greater than 0 then the ID was an array, so traverse the symbol table to find the type.
        for (i = count; i > 0; --i) {
            if (temp->refType == nullptr)
                error("Too many dimensions");
            temp = temp->refType;
        }

        ast p;
        if ((p = new struct node) == nullptr)
            exit(1);
        p->type = temp;
        // Set nesting difference and offset.
        p->nesting_diff = currentScope->nestingLevel - e->nestingLevel;
        p->offset = e->u.eVariable.offset;
        return p;
    }
    else if (f->k == STR) {
        Type temp = f->type;

        if (count > 1) {
            error("Too many dimensions for string");
        }
        else if (count == 1) {  // This will mean that the type is a character.
            temp = temp->refType;
        }

        ast p;
        if ((p = new struct node) == nullptr)
            exit(1);
        p->type = temp;

        return p;
    }

    ast_sem(f->second);  // Semantic check of the expression inside the brackets.
    if (f->second->type != typeInteger && f->second->type != typeChar)
        error("Array index must be of type int or byte");
    return l_value_type(f->first, count + 1);  // Return after calling the l_value type again,
                                                     // until f->k is STR or ID
}

/**
 * Operands must be either both Integer or both Byte
 */
Type check_op_type(Type first, Type second, std::string op)
{
    Type result = typeInteger;

    if (equalType(first, typeInteger) && !equalType(second, typeInteger))
        error("type mismatch in %s operator", op.c_str());
    else if (equalType(first, typeChar) && !equalType(second, typeChar))
        error("type mismatch in %s operator", op.c_str());
    else if (!equalType(first, typeInteger) && !equalType(first, typeChar))
        error("types must be Integer or Byte in %s operator", op.c_str());

    return first;
}

void check_result_type (Type first, Type second, std::string func_name)
{
    // Check if "return" was during a procedure
    if (equalType(first, typeVoid) && !equalType(second, typeVoid)) {
        fatal("Proc %s does not return value", func_name.c_str());
    }
    // Check if "exit" was during a function
    else if (!equalType(first, typeVoid) && equalType(second, typeVoid)) {
        fatal("Function %s must return a value", func_name.c_str());
    }
    // Check if an integer is returned as byte (the reverse is allowed)
    else if (!equalType(first, second)) {
        fatal("Result type must be same as function type in %s", func_name.c_str());
    }
}

void check_parameters (SymbolEntry* f, ast first, ast second, const std::string& call_type)
{
    ast real_param = first;
    ast real_param_list = second;
    SymbolEntry* func_param = f->u.eFunction.firstArgument;

    while (real_param != nullptr && func_param != nullptr) {
        Type real_param_type = real_param->type;
        Type func_param_type = func_param->u.eParameter.type;

        // If the types of the real and the typical parameters are not equal
        // then print error message.
        // Except when the 1st dimension of the
        // real parameter is an Array and
        // the 1st dimension of the typical parameter is an IArray.
        // Both Arrays must refer to the same types.
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

/**
 * Dive into local definitions and create
 * a vector with the llvm types of all function's local variables,
 */
std::vector<llvm::Type*> var_members(ast t)
{
    std::vector<llvm::Type*> result;

    if (t == nullptr)
        return result;

    ast local_def = t->first;
    ast local_def_list = t->second;

    while (local_def != nullptr) {

        if (local_def->k == VAR_DEF) {
            ast_compile(local_def->second);
            auto var_type = local_def->second->type;
            auto llvm_var_type = to_llvm_type(var_type);

            do {
                result.push_back(llvm_var_type);
                local_def = local_def->first;
            } while (local_def != nullptr);
        }

        if (local_def_list == nullptr)
            break;

        local_def = local_def_list->first;
        local_def_list = local_def_list->second;
    }
    return result;
}
