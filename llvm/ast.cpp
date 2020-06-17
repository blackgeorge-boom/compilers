#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include "ast.h"
#include "auxiliary.h"
#include "logger.h"
#include "symbol.h"

// Keep the loop records.
loop_record current_LR = nullptr;

// Save a code list of every function.
function_code_list current_CL = nullptr;

// A flag for function mode.
enum {
    FUNC_DECLARATION,
    FUNC_DEFINITION
} func_mode;

// A vector of all the functions that we are inside of.
std::vector<char*> func_names;

// The current function name
char* curr_func_name;

// A vector of all the function names that are defined in our library
std::vector<std::string> lib_names{"writeInteger", "writeByte", "writeChar", "writeString",
                                   "readInteger", "readByte", "readChar", "readString",
                                   "extend", "shrink",
                                   "strlen", "strcmp", "strcpy", "strcat"};

// With ast make we create the abstract syntax tree (ast)
// Not every item of the struct ast will have a value. Some will be null pointer.
static ast ast_make(kind k, char* s, int n, ast first, ast second, ast third, ast last, Type t) {
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

ast ast_id (char* s) {
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

ast ast_var_def (char* string, ast f, ast s) {
    return ast_make(VAR_DEF, string, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_id_list (char* s, ast f) {
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

ast ast_l_value (ast f, ast s) {
    return ast_make(L_VALUE, nullptr, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_r_value (ast f) {
    return ast_make(R_VALUE, nullptr, 0, f, nullptr, nullptr, nullptr, nullptr);
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

ast ast_loop (char* s, ast f) {
    return ast_make(LOOP, s, 0, f, nullptr, nullptr, nullptr, nullptr);
}

ast ast_break (char* s) {
    return ast_make(BREAK, s, 0, nullptr, nullptr, nullptr, nullptr, nullptr);
}

ast ast_continue (char* s) {
    return ast_make(CONTINUE, s, 0, nullptr, nullptr, nullptr, nullptr, nullptr);
}

ast ast_header (char* string, ast f, ast s, Type t) {
    return ast_make(HEADER, string, 0, f, s, nullptr, nullptr, t);
}

ast ast_fpar_def (char* string, ast f, ast s) {
    return ast_make(FPAR_DEF, string, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_ref_type (Type t) {
    return ast_make(REF_TYPE, nullptr, 0, nullptr, nullptr, nullptr, nullptr, t);
}

ast ast_iarray_type (ast f, Type t) {
    return ast_make(IARRAY_TYPE, nullptr, 0, f, nullptr, nullptr, nullptr, t);
}

ast ast_proc_call (char* string, ast f, ast s) {
    return ast_make(PROC_CALL, string, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_func_call (char* string, ast f, ast s) {
    return ast_make(FUNC_CALL, string, 0, f, s, nullptr, nullptr, nullptr);
}

ast ast_program (ast f) {
    return ast_make(PROGRAM, nullptr, 0, f, nullptr, nullptr, nullptr, nullptr);
}


ast ast_return (ast f) {
    return ast_make(RETURN, nullptr, 0, f, nullptr, nullptr, nullptr, nullptr);
}

ast ast_skip () {
    return ast_make(SKIP, nullptr, 0, nullptr, nullptr, nullptr, nullptr, nullptr);
}

ast ast_exit () {
    return ast_make(EXIT, nullptr, 0, nullptr, nullptr, nullptr, nullptr, nullptr);
}

// Global LLVM variables related to the LLVM suite.
static llvm::LLVMContext TheContext;
static llvm::IRBuilder<> Builder(TheContext);
static std::unique_ptr<llvm::Module> TheModule;
static std::unique_ptr<llvm::legacy::FunctionPassManager> TheFPM;
static std::vector<llvm::StructType*> StackFrameTypes;
static std::vector<llvm::AllocaInst*> StackFrames;

// Useful LLVM types.
static llvm::Type* llvm_bit = llvm::IntegerType::get(TheContext, 1);
static llvm::Type* llvm_byte = llvm::IntegerType::get(TheContext, 8);
static llvm::Type* llvm_int = llvm::IntegerType::get(TheContext, 16);
static llvm::Type* llvm_void = llvm::Type::getVoidTy(TheContext);

// Useful LLVM helper functions.
inline llvm::ConstantInt* c1(char c) {
    return llvm::ConstantInt::get(TheContext, llvm::APInt(1, c, false));
}

inline llvm::ConstantInt* c8(char c) {
    return llvm::ConstantInt::get(TheContext, llvm::APInt(8, c, false));
}

inline llvm::ConstantInt* c16(int n) {
    return llvm::ConstantInt::get(TheContext, llvm::APInt(16, n, false));
}

inline llvm::ConstantPointerNull* llvm_null(llvm::PointerType* llvm_type) {
    return llvm::ConstantPointerNull::get(llvm_type);
}

/**
 * Create an alloca instruction in the entry block of
 * the function. This is used for mutable variables etc.
 */
static llvm::AllocaInst* CreateEntryBlockAlloca(llvm::Function* TheFunction,
                                                const std::string& VarName,
                                                llvm::Type* VarType)
{
    llvm::IRBuilder<> TmpB(&TheFunction->getEntryBlock(),
                           TheFunction->getEntryBlock().begin());

    return TmpB.CreateAlloca(VarType, 0, VarName.c_str());
}

// A vector that holds the merge blocks, needed for the if, elif, if_else statements.
// We use a vector and not a single basic block because we could have nested if, elif, if_else statements.
std::vector<llvm::BasicBlock*> merge_blocks;

llvm::Value* ast_compile(ast t)
{
    if (!t)
        return nullptr;

    switch (t->k) {

        case PROGRAM:
        {
            /** PROGRAM
             * Case program is only reached at the beginning of ast_compile
             * So the function name is (or is converted to main)
             *
             * t->first is the definition of main function (FUNC_DEF).
             */
            openScope();

            // Outer function should be called "main"
            // Change outer function name to "main" if necessary
            ast func_def_tree = t->first;
            char* outer_func_name = func_def_tree->first->id;
            free(outer_func_name);
            outer_func_name = (char*)malloc(strlen("main") + 1); // big enough to hold "main"
            strcpy(outer_func_name, "main");

            llvm::Value* V = ast_compile(t->first);
            closeScope();
            return V;
        }
        case FUNC_DECL:
        {
            /** FUNCTION DECLARATION
             * The declaration of a function.
             *
             * t->first is the header (HEADER)
             */
            func_mode = FUNC_DECLARATION; // Set the flag for header

            llvm::Function* V = static_cast<llvm::Function*>(ast_compile(t->first)); // Compile the header
            closeScope();

            return nullptr;
        }

        case FUNC_DEF:
        {
            /**
             * FUNCTION DEFINITION
             * The definition of a function.
             *
             * t->first is the header (HEADER)
             * t->second is the local definition list(local_def_list),
             *           which is a sequence of local_defs, meaning FUNC_DEF, FUNC_DECL, VAR_DEF.
             * t->third is the sequence of statements
             */
            func_mode = FUNC_DEFINITION;  // Set the flag for header

            curr_func_name = t->first->id;  // Set the current function name
            func_names.push_back(curr_func_name);  // Put the function name on the function name list

            llvm::Function* TheFunction = TheModule->getFunction(curr_func_name);

            if (!TheFunction)   // If the function is not previously declared, we create it from scratch,
                                // by compiling the header.
                TheFunction = static_cast<llvm::Function*>(ast_compile(t->first));
            else
                ast_compile(t->first);  // Else we just compile the header.

            if (!TheFunction)
                return nullptr;

            if (!TheFunction->empty())
                return (llvm::Function*)LogErrorV("Function cannot be redefined.");

            if (StackFrames.empty()) // That means this is the definition of main.
                currentScope->negOffset = 0;

            // Save the last basic block, in order to return to it.
            llvm::BasicBlock* OldBB = Builder.GetInsertBlock();

            // Create a new basic block to start insertion into.
            llvm::BasicBlock* BB = llvm::BasicBlock::Create(TheContext, "entry", TheFunction);
            Builder.SetInsertPoint(BB);

            // A vector that will hold all of the llvm types, necessary for creating the Stack frame of the function.
            std::vector<llvm::Type*> members;

            // For every function argument we will push their type to the members vector.
            for (auto& Arg : TheFunction->args()) {

                // Check if the selected type is the type of the pointer to the Stack Frame of the previous function.
                if (static_cast<llvm::PointerType*>(Arg.getType()) == StackFrameTypes.back()->getPointerTo(0)) {
                    members.push_back(Arg.getType());  // Push to members the type of the argument.
                    continue;
                }

                // Get the name of the argument.
                std::string ArgName(Arg.getName());
                char var_id[ArgName.size() + 1];
                strcpy(var_id, ArgName.c_str());  // ArgName is const.
                SymbolEntry* se = lookup(var_id); // Look up the argument in the Symbol Table.

                if (se->u.eParameter.type->kind == Type_tag::TYPE_IARRAY) {
                    /**
                     * If the case of the type of the argument is of unknown size array type,
                     * then push to "members" a pointer to a single-element array of the array type.
                     * e.g. int[][10] -> int*[1][10] will be pushed.
                     */
                    auto PointeeType = to_llvm_type(se->u.eParameter.type->refType);
                    members.push_back(llvm::PointerType::get(llvm::ArrayType::get(PointeeType, 1), 0));
                    continue;
                }

                members.push_back(Arg.getType());  // Push to members the type of the argument.
            }

            // Find all the llvm types of the function's local variables and push them to members.
            std::vector<llvm::Type*> local_vars = var_members(t->second);
            members.insert(members.end(), local_vars.begin(), local_vars.end());

            // Create type for the current stack frame.
            llvm::StructType* CurStackFrameType =
                    llvm::StructType::create(TheContext,
                                             llvm::ArrayRef<llvm::Type*>(members),
                                             std::string(curr_func_name) + "_type");
            StackFrameTypes.push_back(CurStackFrameType);

            // Create the current stack frame.
            llvm::AllocaInst* CurStackFrame =
                    CreateEntryBlockAlloca(TheFunction,
                                           std::string(curr_func_name) + "_frame",
                                           CurStackFrameType);
            StackFrames.push_back(CurStackFrame);

            llvm::Value* StructPtr;

            // For every function argument we will create the appropriate llvm command, which means store every
            // argument to the stack frame.
            for (auto& Arg : TheFunction->args()) {

                auto n = StackFrames.size();
                // Check if the argument is the stack frame of the previous function.
                // We just pushed the n-1 element to the StackFrames. So the n-2 is the previous one.
                if (n > 1 && static_cast<llvm::PointerType*>(Arg.getType()) == StackFrameTypes[n - 2]->getPointerTo(0)) {
                    StructPtr = Builder.CreateStructGEP(CurStackFrameType, CurStackFrame, 0, "");
                    Builder.CreateStore(&Arg, StructPtr); // Store the pointer of the previous Stack Frame
                    continue;
                }

                // Get the name of the argument.
                std::string ArgName(Arg.getName());
                char id[ArgName.size() + 1];
                strcpy(id, ArgName.c_str());  // ArgName is const.
                SymbolEntry* se = lookup(id);  // Look up the argument in the Symbol Table.
                // Create a pointer to the position of the argument in the frame structure.
                int offset = se->u.eVariable.offset;
                StructPtr = Builder.CreateStructGEP(CurStackFrameType, CurStackFrame, offset, ArgName + "_pos");

                if (se->u.eParameter.type->kind == Type_tag::TYPE_IARRAY) {
                    /**
                     * If the case of the type of the argument is of unknown size array type,
                     * then we need to do a bitcast to pointer to the array type.
                     * e.g. int*[10] -> int*[1][10]
                     * The reason we do this is because we want to be able to use the get element pointer(GEP)
                     * instruction afterwards.
                     * Meaning that, if we had an iarray of int[][10] then by converting it to type of *int[1][10] we can
                     * load (*int[i][10]) , where i can be greater than 1.
                     */
                    auto PointeeType = to_llvm_type(se->u.eParameter.type->refType);
                    auto Tmp = new llvm::BitCastInst(&Arg, llvm::PointerType::get(llvm::ArrayType::get(PointeeType, 1),0), "cast", BB);
                    Builder.CreateStore(Tmp, StructPtr);  // Store the value to the right position of the frame
                }
                else
                    Builder.CreateStore(&Arg, StructPtr);  // Store the value to the right position of the frame
            }

            if (strcmp(t->first->id, "main") == 0)
                declare_dana_libs();  // Declare all the required libraries for dana.

            // Compile Local def lists
            ast_compile(t->second);

            Builder.SetInsertPoint(BB);

            // TheBody should normally be nullptr after ast_compile()
            auto TheBody = static_cast<llvm::ConstantInt*>(ast_compile(t->third));

            if (TheBody == nullptr) {  // That happens if at the end of the function there was no terminating statement.
                if (TheFunction->getReturnType() == llvm_void) {  // In a procedure it is allowed to end without an exit statement.
                    // Finish off the proc.
                    Builder.CreateRetVoid();
                }
                else if (TheFunction->getReturnType() == llvm_byte) {
                    Builder.CreateRet(c8(0));
                }
                else {
                    Builder.CreateRet(c16(0));
                }
            }

            // Reset current function name.
            func_names.pop_back();
            curr_func_name = func_names.back();

//            TheFPM->run(*TheFunction);

            // Remove the frame from the vector of stack frames.
            StackFrames.pop_back();
            StackFrameTypes.pop_back();

            closeScope();
            if (OldBB)
                Builder.SetInsertPoint(OldBB); // Return to previous builder block.
            return TheFunction;
        }
        case HEADER:
        {
            /**
             * HEADER
             * The header of a function definition or declaration.
             *
             * t->id is the name of the function.
             * t->first is the first batch of function parameters(fpar_def).
             * t->second is the list of the other batches of function parameters(fpar_def_list).
             * t->type is the type of the function.
             */
            Type func_type = typeVoid;  // The symbolic type of the function.
            llvm::Type* llvm_func_type = llvm_void;  // The llvm type of the function.

            if (t->type != nullptr) {
                func_type = t->type;    // Check func or proc
                llvm_func_type = to_llvm_type(t->type);
            }

            SymbolEntry* f = newFunction(t->id);  // Create new symbol entry of the function.
            if (func_mode == FUNC_DECLARATION)
                forwardFunction(f);

            std::vector<llvm::Type*> Params;  // A vector for the function parameters
            std::vector<std::string> Args;  // A vector for the function parameters' types

            // Push a pointer to the previous stack frame type
            // and the previous stack frame.
            if (!StackFrameTypes.empty()) {
                Params.push_back(StackFrameTypes.back()->getPointerTo());
                Args.push_back(StackFrames.back()->getName());
            }

            // We open the scope of the current function that was
            // just inserted. The name of the function itself, though, has
            // been inserted to the previous scope.
            openScope();

            ast par_def = t->first;         // First is fpar_def
            ast fpar_def_list = t->second;  // Second is fpar_def_list

            Type par_type = nullptr;
            llvm::Type* llvm_par_ty= llvm_void;

            while (par_def != nullptr) {
                /**
                 * The parameter definition batch (fpar_def):
                 *
                 * t-> id is a name of the first parameter
                 * t-> first is a list of all the other parameters in the batch(if they exist).
                 * t-> second is the type of these function parameters
                 */
                // Compile the par_def->second in order to find the fpar_type.
                ast_compile(par_def->second);           // Second is fpar_type
                par_type = par_def->second->type;
                llvm_par_ty = to_llvm_type(par_type);   // Get corresponding llvm type. IArray becomes pointer to array.

                if (par_type->kind == Type_tag::TYPE_ARRAY)  // Create a pointer to the array because arrays are always passed by reference, not by value.
                    llvm_par_ty = llvm::PointerType::get(llvm_par_ty, 0);
//                else if (par_type->kind == Type_tag::TYPE_IARRAY)
//                    llvm_par_ty = llvm::PointerType::get(llvm_par_ty, 0);

                insertParameter(par_def->id, par_type, f);    // Insert first parameter

                Params.push_back(llvm_par_ty);
                Args.emplace_back(par_def->id);

                ast par_list = par_def->first;
                while (par_list != nullptr) {           // Insert the rest parameters
                    insertParameter(par_list->id, par_type, f);
                    Params.push_back(llvm_par_ty);
                    Args.emplace_back(par_list->id);
                    par_list = par_list->first;         // First is the rest of T_ids.
                }

                if (fpar_def_list == nullptr) {
                    break;
                }

                par_def = fpar_def_list->first;  // Now for the rest of fpar_defs. (Next batch of function parameters)
                fpar_def_list = fpar_def_list->second; // The rest of the list of batches.
            }

            endFunctionHeader(f, func_type);  // Finalize function in Symbol table.
            // Create function in llvm.
            llvm::FunctionType* FT =
                    llvm::FunctionType::get(llvm_func_type, Params, false);

            llvm::Function* F =
                    llvm::Function::Create(FT, llvm::Function::ExternalLinkage,
                                           t->id, TheModule.get());

            // Set names for all arguments.
            unsigned Idx = 0;
            for (auto& Arg : F->args()) {
                Arg.setName(Args[Idx++]);
            }

            return F;  // Return the function.
        }
        case SEQ:
        {
            /**
             * SEQUENCE
             * Compile
             * t->first and then t->second
             * whatever they are. They can be:
             * local_def local_def_list, fpar_def fpar_def_list, stmt stmt_list, expr expr_list,
             * respectively.
             */
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            if (t->second == nullptr)
                return F;
            else
                return S;
        }
        case SKIP:
        {
            return nullptr;
        }
        case TYPE:
        {
            /**
             * TYPE
             * Set t->type correctly with var_def_type function.
             */
            t->type = var_def_type(t->type, t->first);
            return nullptr;
        }
        case REF_TYPE:
        {
            /**
             * REFERENCE TYPE
             * Set t->type pointer of datatype.
             */
            t->type = typePointer(t->type);
            return nullptr;
        }
        case IARRAY_TYPE:
        {
            /**
             * UKNOWN SIZE ARRAY TYPE
             * Set t->type correctly with var_def_type function
             * and then set it to unknown size array type.
             */
            Type my_type = var_def_type(t->type, t->first);
            t->type = typeIArray(my_type);
            return nullptr;
        }
        case CONST:
        {
            /**
             * CONSTANT
             * Set type as integer for symbol table and
             * constant int of 16 bits in llvm.
             */
            t->type = typeInteger;
            return c16(t->num);
        }
        case CHAR:
        {
            /**
            * CHARACTER
            * Set type as character for symbol table and
            * constant int of 8 bits(1 byte) in llvm.
            */
            t->type = typeChar;
            return c8(t->num);
        }

        case IF:
        {
            /**
             * IF STATEMENT (without an else)
             * t->first is the condition of the if statement.
             * t->second is a block (sequence of statements).
             * t->third is an elif_list (list of elif statements).
             */
            llvm::Value* CondV = ast_compile(t->first);  // Compile the condition.

            if (!CondV)
                return nullptr;
            Type expr_type = t->first->type;

            // Check if condition is an integer or a character.
            if (!equalType(expr_type, typeInteger) && !equalType(expr_type, typeChar))
                error("Condition must be Integer or Byte!");

            // Cast byte to int if necessary
            if (equalType(expr_type, typeChar))
                CondV = Builder.CreateIntCast(CondV, llvm_int, true);

            // Convert condition to a bool by comparing non-equal to 0.0.
            CondV = Builder.CreateICmpNE(
                    CondV,
                    c16(0), "ifcond");

            llvm::Function* TheFunction = Builder.GetInsertBlock()->getParent();

            // Create blocks for the then and elif cases.  Insert the 'then' block at the
            // end of the function.
            llvm::BasicBlock* ThenBB = llvm::BasicBlock::Create(TheContext, "then", TheFunction);
            llvm::BasicBlock* ElifBB = llvm::BasicBlock::Create(TheContext, "elif");
            llvm::BasicBlock* MergeBB = llvm::BasicBlock::Create(TheContext, "ifcont");

            merge_blocks.push_back(MergeBB); // Push to merge_blocks.

            Builder.CreateCondBr(CondV, ThenBB, ElifBB); // Create a conditional branch.

            // Emit then value.
            Builder.SetInsertPoint(ThenBB);

            // Generate code for "then" block.
            llvm::Value* ExitStmt = ast_compile(t->second); // Compile sequence of statements.\
                                                              The llvm::Value of the last statement is returned.

            // Only escape statements return a non-null value. These are: EXIT, RETURN, CONTINUE, BREAK.
            if (!ExitStmt)
                Builder.CreateBr(MergeBB);

            // Emit elif block.
            TheFunction->getBasicBlockList().push_back(ElifBB); // Add elif block to the function. (only "then" block has been added so far)
            Builder.SetInsertPoint(ElifBB);

            // Generate code for "elif list" blocks
            ast_compile(t->third);

            Builder.CreateBr(MergeBB);  // Create branch to the merge basic block.

            // Emit merge block.
            TheFunction->getBasicBlockList().push_back(MergeBB);
            Builder.SetInsertPoint(MergeBB);

            merge_blocks.pop_back(); // Remove this last merge basic block.
            return nullptr;
        }
        case ELIF:
        {
            /**
            * ELIF STATEMENT
            * t->first is the condition of the elif statement.
            * t->second is a block (sequence of statements).
            * t->third is an elif_list (list of elif statements).
            */
            llvm::Value* CondV = ast_compile(t->first); // Compile the condition.

            if (!CondV)
                return nullptr;

            Type expr_type = t->first->type;

            // Check if condition is an integer or a character.
            if (!equalType(expr_type, typeInteger) && !equalType(expr_type, typeChar))
                error("Condition must be Integer or Byte!");

            // Cast byte to int if necessary
            if (equalType(expr_type, typeChar))
                CondV = Builder.CreateIntCast(CondV, llvm_int, true);

            // Convert condition to a bool by comparing non-equal to 0.0.
            CondV = Builder.CreateICmpNE(
                    CondV,
                    c16(0), "elifcond");

            llvm::Function* TheFunction = Builder.GetInsertBlock()->getParent();

            // Create blocks for the then and else cases.  Insert the 'then' block at the
            // end of the function.
            llvm::BasicBlock* ThenBB = llvm::BasicBlock::Create(TheContext, "elifthen", TheFunction);
            llvm::BasicBlock* ElifBB = llvm::BasicBlock::Create(TheContext, "elif");
            llvm::BasicBlock* MergeBB = llvm::BasicBlock::Create(TheContext, "elifcont");

            Builder.CreateCondBr(CondV, ThenBB, ElifBB); // Create a conditional branch.

            // Emit then value.
            Builder.SetInsertPoint(ThenBB);

            // Generate code for "elifthen" block
            auto ElifExitStmt = static_cast<llvm::ConstantInt *>(ast_compile(t->second));// Compile sequence of statements.\
                                                                                            The llvm::Value of the last statement is returned.
            // Only escape statements return a value. These are: EXIT, RETURN, CONTINUE, BREAK.
            if (!ElifExitStmt)
                Builder.CreateBr(merge_blocks.back());

            // Emit else block.
            TheFunction->getBasicBlockList().push_back(ElifBB);
            Builder.SetInsertPoint(ElifBB);

            // Generate code for "elif list" blocks
            auto ElifListExitStmt = static_cast<llvm::ConstantInt *>(ast_compile(t->third));// Compile sequence of statements.\
                                                                                                The llvm::Value of the last statement is returned.

            Builder.CreateBr(MergeBB);  // Create branch to MergeBB.

            // Emit merge block.
            TheFunction->getBasicBlockList().push_back(MergeBB);
            Builder.SetInsertPoint(MergeBB);

            if (t->third == nullptr) // No more elif statements. So return the value of the last elif statement.
                return ElifExitStmt;
            else if (ElifExitStmt != nullptr && ElifListExitStmt != nullptr &&
                     ElifExitStmt->getSExtValue() == 0 && ElifListExitStmt->getSExtValue() == 0)
                //  That means that all of the elif statements return either EXIT or RETURN(terminating statements).
                return c16(0); // Escape but also terminating statement.
            else return nullptr;

        }
        case IF_ELSE:
        {
            /**
             * IF-ELSE STATEMENT (with an else)
             * t->first is the condition of the if statement.
             * t->second is the block(sequence of statements) of the if statement.
             * t->third is an elif_list (list of elif statements).
             * t->last is the block(sequence of statements) of the else statement.
             */
            llvm::Value* CondV = ast_compile(t->first);  // Compile the condition.

            if (!CondV)
                return nullptr;

            Type expr_type = t->first->type;

            // Check if condition is an integer or a character.
            if (!equalType(expr_type, typeInteger) && !equalType(expr_type, typeChar))
                error("Condition must be Integer or Byte!");

            // Cast byte to int if necessary
            if (equalType(expr_type, typeChar))
                CondV = Builder.CreateIntCast(CondV, llvm_int, true);

            // Convert condition to a bool by comparing non-equal to 0.0.
            CondV = Builder.CreateICmpNE(
                    CondV,
                    c16(0), "ifcond");

            llvm::Function* TheFunction = Builder.GetInsertBlock()->getParent();

            // Create blocks for the then, elif and else cases.  Insert the 'then' block at the
            // end of the function.
            llvm::BasicBlock* ThenBB = llvm::BasicBlock::Create(TheContext, "then", TheFunction);
            llvm::BasicBlock* ElifBB = llvm::BasicBlock::Create(TheContext, "elif");
            llvm::BasicBlock* ElseBB = llvm::BasicBlock::Create(TheContext, "else");
            llvm::BasicBlock* MergeBB = llvm::BasicBlock::Create(TheContext, "ifcont");

            merge_blocks.push_back(MergeBB);  // Push to merge_blocks.

            Builder.CreateCondBr(CondV, ThenBB, ElifBB); // Create a conditional branch.

            // Emit then value.
            Builder.SetInsertPoint(ThenBB);

            // Generate code for "then" block
            auto ThenExitStmt = static_cast<llvm::ConstantInt*>(ast_compile(t->second));// Compile sequence of statements.\
                                                                                           The llvm::Value of the last statement is returned.
            // Only escape statements return a non-null value. These are: EXIT, RETURN, CONTINUE, BREAK.
            if (!ThenExitStmt)
                // Create branch to "ifcont"
                Builder.CreateBr(MergeBB);

            // Emit elif block.
            TheFunction->getBasicBlockList().push_back(ElifBB);
            Builder.SetInsertPoint(ElifBB);

            // Generate code for "elif list" blocks
            auto ElifExitStmt = static_cast<llvm::ConstantInt*>(ast_compile(t->third));

            if (t->third == nullptr) ElifExitStmt = c16(0); // If there is no elif, then we regard it as a terminating statement

            Builder.CreateBr(ElseBB);  // Create branch to the else basic block.

            // Emit else block.
            TheFunction->getBasicBlockList().push_back(ElseBB);
            Builder.SetInsertPoint(ElseBB);

            // Generate code for "else" block
            auto ElseExitStmt = static_cast<llvm::ConstantInt*>(ast_compile(t->last));// Compile sequence of statements.\
                                                                                         The llvm::Value of the last statement is returned.
            // Only escape statements return a non-null value. These are: EXIT, RETURN, CONTINUE, BREAK.

            if (!ElseExitStmt)
                // Create branch to "ifcont"
                Builder.CreateBr(MergeBB);

            // Emit merge block.
            TheFunction->getBasicBlockList().push_back(MergeBB);
            Builder.SetInsertPoint(MergeBB);

            merge_blocks.pop_back(); // Remove this last merge basic block.
            // If all the returned statements are EXIT or RETURN then "if cont" will never be reached so create unreachable.
            if (ThenExitStmt != nullptr && ElifExitStmt != nullptr && ElseExitStmt != nullptr &&
                ThenExitStmt->getSExtValue() == ElifExitStmt->getSExtValue() == ElseExitStmt->getSExtValue() == 0) {
                Builder.CreateUnreachable();
                return c16(0);  // Escape but also terminating statement.
            }

            return nullptr;
        }
        case LOOP:
        {
            /**
             * LOOP STATEMENT
             * t->id is the name of the loop(can be null).
             * t->first is the block(sequence of statements) of the loop.
             */
            if (t->id != nullptr)
                if (look_up_loop(t->id)) {
                    error("Loop identifier already exists!\n");
                    exit(1);
                }
            auto new_LR = new struct loop_record_tag; // Create new loop record.
            // Add it to the linked list.
            new_LR->id = t->id;
            new_LR->previous = current_LR;

            // Make the new basic block for the loop header, inserting after current block.
            llvm::Function* TheFunction = Builder.GetInsertBlock()->getParent();
            llvm::BasicBlock* LoopBB =
                    llvm::BasicBlock::Create(TheContext, "loop", TheFunction);
            llvm::BasicBlock* AfterBB =
                    llvm::BasicBlock::Create(TheContext, "afterloop");

            Builder.CreateBr(LoopBB); // Create branch to loop basic block.

            // Start insertion in LoopBB.
            Builder.SetInsertPoint(LoopBB);

            // Add the basic blocks to the loop record list.
            new_LR->loop_block = LoopBB;
            new_LR->after_block = AfterBB;
            current_LR = new_LR; // Set pointer of current loop record.

            // Emit the body of the loop.
            auto ExitStmt = static_cast<llvm::ConstantInt*>(ast_compile(t->first));  // Compile sequence of statements.\
                                                                                        The llvm::Value of the last statement is returned.
            // Only escape statements return a non-null value. These are: EXIT, RETURN, CONTINUE, BREAK.

            if (!ExitStmt) {
                // Insert the unconditional branch into the end of LoopBB.
                Builder.CreateBr(LoopBB);
            }

            TheFunction->getBasicBlockList().push_back(AfterBB);
            // Any new code will be inserted in AfterBB.
            Builder.SetInsertPoint(AfterBB);

            current_LR = current_LR->previous; // Set pointer of current loop record.
            free(new_LR);

            // If the returned statements is EXIT or RETURN(terminating), then AfterBB will never be reached, so create unreachable.
            if (ExitStmt != nullptr && ExitStmt->getSExtValue() == 0) {
                Builder.CreateUnreachable();
                return c16(0);  // Escape but also terminating statement.
            }

            return nullptr;
        }
        case FPAR_DEF:break;
        case BREAK:
        {
            /**
             * BREAK STATEMENT
             * t->id(can be null) is the name of the loop to be broken out of.
             */
            loop_record lr;
            if (t->id != nullptr) {  // If break statement has a name.
                lr = look_up_loop(t->id);  // Find the loop.
                if (!lr) {
                    error("Loop identifier does not exist!\n");
                    exit(1);
                }
                Builder.CreateBr(lr->after_block);  // Create branch to after block of the selected loop.
                return c16(1);  // Escape statement.
            }
            else if (current_LR == nullptr)
                error("No loop to break");
            else {
                Builder.CreateBr(current_LR->after_block); // Create branch to after block of the current loop.
                return c16(1);  // Escape statement.
            }
        }
        case CONTINUE:
        {
            /**
            * CONTINUE STATEMENT
            * t->id(can be null) is the name of the loop to continue from.
            */
            loop_record lr;
            if (t->id != nullptr) {  // If break statement has a name.
                lr = look_up_loop(t->id);  // Find the loop.
                if (!lr) {
                    error("Loop identifier does not exist!\n");
                    exit(1);
                }
                Builder.CreateBr(lr->loop_block);  // Create branch to loop block of the selected loop.
                return c16(1);  // Escape statement.
            }
            else if (current_LR == nullptr)
                error("No loop to continue");
            else {
                Builder.CreateBr(current_LR->loop_block);  // Create branch to loop block of the current loop.
                return c16(1);  // Escape statement.
            }
        }
        case EXIT:
        {
            /**
             * EXIT STATEMENT
             */
            SymbolEntry* curr_func = lookup(curr_func_name);  // Find the procedure in the Symbol entry.
            // Check if it is a procedure(has no return value).
            Type curr_func_type = curr_func->u.eFunction.resultType;
            Type return_type = typeVoid;
            check_result_type(curr_func_type, return_type, curr_func_name);

            Builder.CreateRetVoid();  // Create a return void.

            return c16(0);  // Escape but also terminating statement.
        }
        case RETURN:
        {
            /**
             * RETURN STATEMENT
             * t->first is an expression
             */
            // Compile the expression.
            llvm::Value* RetV = ast_compile(t->first);
            SymbolEntry* curr_func = lookup(curr_func_name);  // Find the function in the Symbol entry.
            // Check if the type of the expression is the same as that of the function.
            Type curr_func_type = curr_func->u.eFunction.resultType;
            Type return_type = t->first->type;
            check_result_type(curr_func_type, return_type, curr_func_name);

            // Cast byte to int if necessary
            if (equalType(curr_func_type, typeInteger) && equalType(return_type, typeChar))
                RetV = Builder.CreateIntCast(RetV, llvm_int, true);

            Builder.CreateRet(RetV); // Create return value.

            return c16(0);  // Escape but also terminating statement
        }
        case TRUE:
        {
            t->type = typeChar;
            return c8(1);
        }
        case FALSE:
        {
            t->type = typeChar;
            return c8(0);
        }
        case UN_PLUS:
        {
            /**
             * UN_PLUS EXPRESSION
             * t->second is the expression
             */
            llvm::Value* S = ast_compile(t->second);  // Compile the expression.
            // UN_PLUS operand must be integer
            t->type = check_op_type(t->second->type, typeInteger, "unary +");
            return Builder.CreateAdd(c16(0), S, "uaddtmp");  // Create addition instruction of (0 + expression)
        }
        case UN_MINUS:
        {
            /**
             * UN_MINUS EXPRESSION
             * t->second is the expression
             */
            llvm::Value* S = ast_compile(t->second);  // Compile the expression.
            // UN_MINUS operand must be integer
            t->type = check_op_type(t->second->type, typeInteger, "unary -");
            return Builder.CreateSub(c16(0), S, "usubtmp");  // Create subtraction instruction of (0 - expression)
        }
        case PLUS:
        {
            /**
             * PLUS EXPRESSION
             * t->first is the  first expression
             * t->second is the second expression
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            // Check both expressions are of the same type and set type of final expression.
            t->type = check_op_type(t->first->type, t->second->type, "+");
            return Builder.CreateAdd(F, S, "addtmp"); // Create addition instruction (first expression + second expression)
        }
        case MINUS:
        {
            /**
             * MINUS EXPRESSION
             * t->first is the  first expression
             * t->second is the second expression
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            // Check both expressions are of the same type and set type of final expression.
            t->type = check_op_type(t->first->type, t->second->type, "-");
            // Create subtraction instruction (first expression - second expression)
            return Builder.CreateBinOp(llvm::Instruction::Sub, F, S, "subtmp");
        }
        case TIMES:
        {
            /**
             * TIMES EXPRESSION
             * t->first is the  first expression
             * t->second is the second expression
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            // Check both expressions are of the same type and set type of final expression.
            t->type = check_op_type(t->first->type, t->second->type, "*");
            // Create multiplication instruction (first expression * second expression)
            return Builder.CreateMul(F, S, "multmp");
        }
        case DIV:
        {
            /**
             * DIVISION EXPRESSION
             * t->first is the  first expression
             * t->second is the second expression
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            // Check both expressions are of the same type and set type of final expression.
            t->type = check_op_type(t->first->type, t->second->type, "/");
            // Create multiplication instruction (first expression / second expression)
            return Builder.CreateSDiv(F, S, "divtmp");
        }
        case MOD:
        {
            /**
             * MODULO EXPRESSION
             * t->first is the  first expression
             * t->second is the second expression
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            // Check both expressions are of the same type and set type of final expression.
            t->type = check_op_type(t->first->type, t->second->type, "%");
            // Create modulo operation ((first expression) mod (second expression))
            return Builder.CreateSRem(F, S, "modtmp");
        }
        case BIT_NOT:
        {
            /**
             * BIT NOT EXPRESSION
             * t->first is the expression
             */
            // Compile the expression.
            llvm::Value* F = ast_compile(t->first);
            // Check expression to be type of character and set type of final expression as character.
            check_op_type(t->first->type, typeChar, "!");
            t->type = t->first->type;
            return Builder.CreateNot(F, "bitnot");  // Create bit not operation.
        }
        case BIT_AND:
        {
            /**
             * BIT AND EXPRESSION
             * t->first is the first expression
             * t->second is the second expression
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            // Check both expressions are of the type character and set type of final expression as character.
            check_op_type(t->first->type, typeChar, "&");
            t->type = check_op_type(t->first->type, t->second->type, "&");
            return Builder.CreateAnd(F, S, "bitand");  // Create bit and operation.
        }
        case BIT_OR:
        {
            /**
             * BIT OR EXPRESSION
             * t->first is the first expression.
             * t->second is the second expression.
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            // Check both expressions are of the type character and set type of final expression as character.
            check_op_type(t->first->type, typeChar, "|");
            t->type = check_op_type(t->first->type, t->second->type, "|");
            return Builder.CreateOr(F, S, "bitor");  // Create bit or operation.
        }
        case BOOL_NOT:
        {
            /**
             * BOOL NOT CONDITION
             * t->first is the condition
             */
            // Compile the condition.
            llvm::Value* CondV = ast_compile(t->first);

            if (!CondV)
                return nullptr;

            Type expr_type = t->first->type;
            if (!equalType(expr_type, typeInteger) && !equalType(expr_type, typeChar))
                error("Condition must be Integer or Byte!");

            // Cast byte to int if necessary
            if (equalType(expr_type, typeChar))
                CondV = Builder.CreateIntCast(CondV, llvm_int, true);

            // Convert condition to a bool by comparing non-equal to 0.0.
            CondV = Builder.CreateICmpNE(
                    CondV,
                    c16(0), "inttobit");

            t->type = typeChar;

            return Builder.CreateNot(CondV, "boolnot");  // Create not operation of the condition.
        }
        case BOOL_AND:
        {
            /**
             * BOOL AND CONDITION
             * t->first is the first condition
             * t->second is the second condition
             *
             * We compute the first operand.
             * If it is zero, result is zero.
             * Else result is (1 and second operand) = second operand.
             */
            llvm::Value* F = ast_compile(t->first);  // Compile first operand.

            if (!F)
                return nullptr;

            Type expr_type = t->first->type;
            if (!equalType(expr_type, typeInteger) && !equalType(expr_type, typeChar))
                error("Condition must be Integer or Byte!");

            // Cast byte to int if necessary
            if (equalType(expr_type, typeChar))
                F = Builder.CreateIntCast(F, llvm_int, true);

            // Convert condition to a bool by comparing non-equal to 0.0.
            F = Builder.CreateICmpEQ(F, c16(0), "finttobit");

            llvm::Function* TheFunction = Builder.GetInsertBlock()->getParent();

            // Create blocks for the then and else cases.  Insert the 'then' block at the
            // end of the function.
            llvm::BasicBlock* ThenBB = llvm::BasicBlock::Create(TheContext, "andshortcircuit", TheFunction);
            llvm::BasicBlock* ElseBB = llvm::BasicBlock::Create(TheContext, "andsecond");
            llvm::BasicBlock* MergeBB = llvm::BasicBlock::Create(TheContext, "andcont");

            Builder.CreateCondBr(F, ThenBB, ElseBB);

            // Emit then value.
            Builder.SetInsertPoint(ThenBB);

            Builder.CreateBr(MergeBB);

            // Codegen of 'Then' can change the current block, update ThenBB for the PHI.
            ThenBB = Builder.GetInsertBlock(); // ??

            // Emit else block.
            TheFunction->getBasicBlockList().push_back(ElseBB);
            Builder.SetInsertPoint(ElseBB);

            llvm::Value* S = ast_compile(t->second);  // Compile second operand.

            if (!S)
                return nullptr;

            expr_type = t->second->type;
            if (!equalType(expr_type, typeInteger) && !equalType(expr_type, typeChar))
                error("Condition must be Integer or Byte!");

            // Cast byte to int if necessary
            if (equalType(expr_type, typeChar))
                S = Builder.CreateIntCast(S, llvm_int, true);

            // Convert condition to a bool by comparing non-equal to 0.0.
            S = Builder.CreateICmpNE(S, c16(0), "sinttobit");

            Builder.CreateBr(MergeBB);
            // codegen of 'Else' can change the current block, update ElseBB for the PHI.
            ElseBB = Builder.GetInsertBlock(); // From this point on, after we exit BOOL_AND instructions are inserted here

            // Emit merge block.
            TheFunction->getBasicBlockList().push_back(MergeBB);
            Builder.SetInsertPoint(MergeBB);
            llvm::PHINode* PN = Builder.CreatePHI(llvm_bit, 2, "andtmp");

            PN->addIncoming(c1(0), ThenBB);
            PN->addIncoming(S, ElseBB);

            t->type = typeChar;

            return PN;
        }
        case BOOL_OR:
        {
            /**
             * BOOL OR X_CONDITION
             * t->first is the first condition.
             * t->second is the second condition.
             *
             * We compute the first operand.
             * If it is one, result is one.
             * Else result is (0 or second operand) = second operand.
             */
            llvm::Value* F = ast_compile(t->first);  // Compile first operand.

            if (!F)
                return nullptr;

            Type expr_type = t->first->type;
            if (!equalType(expr_type, typeInteger) && !equalType(expr_type, typeChar))
                error("Condition must be Integer or Byte!");

            // Cast byte to int if necessary
            if (equalType(expr_type, typeChar))
                F = Builder.CreateIntCast(F, llvm_int, true);

            // Convert condition to a bool by comparing non-equal to 0.0.
            F = Builder.CreateICmpNE(F, c16(0), "finttobit");

            llvm::Function* TheFunction = Builder.GetInsertBlock()->getParent();

            // Create blocks for the then and else cases.  Insert the 'then' block at the
            // end of the function.
            llvm::BasicBlock* ThenBB = llvm::BasicBlock::Create(TheContext, "orshortcircuit", TheFunction);
            llvm::BasicBlock* ElseBB = llvm::BasicBlock::Create(TheContext, "orsecond");
            llvm::BasicBlock* MergeBB = llvm::BasicBlock::Create(TheContext, "orcont");

            Builder.CreateCondBr(F, ThenBB, ElseBB);

            // Emit then value.
            Builder.SetInsertPoint(ThenBB);

            Builder.CreateBr(MergeBB);

            // Codegen of 'Then' can change the current block, update ThenBB for the PHI.
            ThenBB = Builder.GetInsertBlock();

            // Emit else block.
            TheFunction->getBasicBlockList().push_back(ElseBB);
            Builder.SetInsertPoint(ElseBB);

            llvm::Value* S = ast_compile(t->second);  // Compile second operand.

            if (!S)
                return nullptr;

            expr_type = t->second->type;
            if (!equalType(expr_type, typeInteger) && !equalType(expr_type, typeChar))
                error("Condition must be Integer or Byte!");

            // Cast byte to int if necessary
            if (equalType(expr_type, typeChar))
                S = Builder.CreateIntCast(S, llvm_int, true);

            // Convert condition to a bool by comparing non-equal to 0.0.
            S = Builder.CreateICmpNE(S,c16(0), "sinttobit");

            Builder.CreateBr(MergeBB);
            // codegen of 'Else' can change the current block, update ElseBB for the PHI.
            ElseBB = Builder.GetInsertBlock(); // From this point on, after we exit BOOL_OR instructions are inserted here

            // Emit merge block.
            TheFunction->getBasicBlockList().push_back(MergeBB);
            Builder.SetInsertPoint(MergeBB);
            llvm::PHINode* PN = Builder.CreatePHI(llvm_bit, 2, "ortmp");

            PN->addIncoming(F, ThenBB);
            PN->addIncoming(S, ElseBB);

            t->type = typeChar;

            return PN;
        }
        case EQ:
        {
            /**
             * EQUAL X_CONDITION
             * t->first is the first expression.
             * t->second is the second expression.
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            // Check both expressions are of the same type and set type of final expression.
            check_op_type(t->first->type, t->second->type, "=");

            t->type = typeChar;

            return  Builder.CreateICmpEQ(F, S, "eq");
        }
        case NE:
        {
            /**
             * NOT EQUAL X_CONDITION
             * t->first is the first expression.
             * t->second is the second expression.
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            // Check both expressions are of the same type and set type of final expression.
            check_op_type(t->first->type, t->second->type, "<>");

            t->type = typeChar;

            return  Builder.CreateICmpNE(F, S, "ne");
        }
        case LT:
        {
            /**
             * LESS THAN X_CONDITION
             * t->first is the first expression.
             * t->second is the second expression.
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            // Check both expressions are of the same type and set type of final expression.
            check_op_type(t->first->type, t->second->type, "<");

            t->type = typeChar;
            // Type char is unsigned, but type int is signed. So check which of those two types is the expression
            // and create unsigned "less than" operation or signed "less than" operation accordingly.
            if (t->first->type == typeChar)
                return  Builder.CreateICmpULT(F, S, "lt");
            else
                return  Builder.CreateICmpSLT(F, S, "lt");
        }
        case GT:
        {
            /**
             * GREATER THAN X_CONDITION
             * t->first is the first expression.
             * t->second is the second expression.
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            // Check both expressions are of the same type and set type of final expression.
            check_op_type(t->first->type, t->second->type, ">");

            t->type = typeChar;
            // Type char is unsigned, but type int is signed. So check which of those two types is the expression
            // and create unsigned "greater than" operation or signed "greater than" operation accordingly.
            if (t->first->type == typeChar)
                return  Builder.CreateICmpUGT(F, S, "gt");
            else
                return  Builder.CreateICmpSGT(F, S, "gt");
        }
        case LE:
        {
            /**
             * LESS THAN OR EQUAL TO X_CONDITION
             * t->first is the first expression.
             * t->second is the second expression.
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            // Check both expressions are of the same type and set type of final expression.
            check_op_type(t->first->type, t->second->type, "<=");

            t->type = typeChar;
            // Type char is unsigned, but type int is signed. So check which of those two types is the expression
            // and create unsigned "less than or equal to" operation or signed "less than or equal to" operation accordingly.
            if (t->first->type == typeChar)
                return  Builder.CreateICmpULE(F, S, "le");
            else
                return  Builder.CreateICmpSLE(F, S, "le");
        }
        case GE:
        {
            /**
             * GREATER THAN OR EQUAL TO X_CONDITION
             * t->first is the first expression.
             * t->second is the second expression.
             */
            // Compile the expressions.
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            // Check both expressions are of the same type and set type of final expression.
            check_op_type(t->first->type, t->second->type, ">=");

            t->type = typeChar;
            // Type char is unsigned, but type int is signed. So check which of those two types is the expression
            // and create unsigned "greater than or equal to" operation or signed "greater than or equal to" operation accordingly.
            if (t->first->type == typeChar)
                return  Builder.CreateICmpUGE(F, S, "ge");
            else
                return  Builder.CreateICmpSGE(F, S, "ge");
        }
        case INT_CONST_LIST:break;  // This case will never be reached.
        case ID_LIST:break;  // This case will never be reached.
        case LET:
        {
            /**
             * LET statement
             * t->first is the l_value
             * t->second is the expression
             */
            llvm::Value* LVal = ast_compile(t->first);  // Compile the l_value.

            llvm::Value* Expr = ast_compile(t->second); // Compile the expression.
            if (!Expr) return nullptr;

            if (!equalType(t->first->type, t->second->type))
                error("Type mismatch in assignment");
            t->nesting_diff = t->first->nesting_diff;
            t->offset = t->first->offset;

            Builder.CreateStore(Expr, LVal); // Create store command.

            return nullptr;
        }
        case VAR_DEF:
        {
            /**
             * VARIABLE DEFINITION
             * t->id is the id
             * t->first is the id_list
             * t->second is the type tree.
             */
            // Type is computed at var_members
            auto var_type = t->second->type;
            insertVariable(t->id, var_type);  // Insert first Variable to Symbol table.

            // Traverse the id_list and insert every id to the Symbol table.
            ast temp = t->first;
            while (temp != nullptr) {
                insertVariable(temp->id, var_type);
                temp = temp->first;
            }
            return nullptr;
        }
        case PROC_CALL:
        {
            /**
             * PROCEDURE CALL
             * t->id is the name(id) of the function.
             * t->first is the first expression.
             * t->second is the expression list.
             */
            SymbolEntry* proc = lookup(t->id);  // Find the procedure in the Symbol table.
            if (proc->u.eFunction.resultType != typeVoid)
                fatal("Cannot call function as a procedure\n");

            // Semantic check of expressions. (Sets correct type of expressions)
            ast_sem(t->first);
            ast_sem(t->second);
            // Check if all parameters(expressions) to the procedure are of the correct type.
            check_parameters(proc, t->first, t->second, "proc");

            // Look up the name in the global module table.
            llvm::Function* CalleeF = TheModule->getFunction(t->id);
            if (!CalleeF)
                return LogErrorV("Unknown procedure referenced");

            // ArgsV will hold the frame and the arguments of the callee procedure.
            std::vector<llvm::Value*> ArgsV;
            auto n = StackFrames.size();

            // If function is "main" or one of the lib functions,
            // there is no parent frame
            if (strcmp(t->id, "main") != 0 &&
                std::find(std::begin(lib_names), std::end(lib_names), std::string{t->id}) == std::end(lib_names)) {
                /**
                 * When the caller's nesting level is greater than callee's, it means that they are declared by the same
                 * outer function (e.g. during mutual recursion). Then, the caller should not provide the callee with his
                 * own frame, but with his parent frame. So, the caller and the callee will have the same parent frame.
                 */
                if (currentScope->nestingLevel > proc->nestingLevel && n > 1) {
                    llvm::Value* CurStackFramePtr = Builder.CreateStructGEP(StackFrameTypes.back(), StackFrames.back(), 0);
                    ArgsV.push_back(Builder.CreateLoad(CurStackFramePtr, ""));
                }
                // Else the caller must provide his own frame as parent frame for the callee.
                else
                    ArgsV.push_back(StackFrames.back());
            }

            ast param = t->first;        // The first expression.
            ast param_list = t->second;  // The exrpession list.

            SymbolEntry* func_param = proc->u.eFunction.firstArgument;
            bool passByReference;
            // For every parameter (argument of the procedure) do:
            while (param != nullptr) {

                passByReference = func_param->u.eParameter.mode == PASS_BY_REFERENCE ||
                                  func_param->u.eParameter.type->kind == Type_tag::TYPE_ARRAY;

                if (passByReference)
                    ArgsV.push_back(ast_compile(param->first)); // Compile the l_value of the expression and push it to the vector.
                else if (func_param->u.eParameter.type->kind == Type_tag::TYPE_IARRAY && param->first->k != STR) {
                    // If it's an IARRAY then create pointer to the l_value. STR is treated by the third case.
                    llvm::Value* Pointer;
                    std::vector<llvm::Value*> indexList{ c16(0), c16(0) };
                    llvm::Value* Id = ast_compile(param->first);
                    llvm::Type* PointeeType = Id->getType()->getPointerElementType();

                    Pointer = llvm::GetElementPtrInst::Create(PointeeType, Id, llvm::ArrayRef<llvm::Value*>(indexList), "lvalue_ptr", Builder.GetInsertBlock());
                    ArgsV.push_back(Pointer);
                }
                else
                    // Compile the expression and put it in the Vector.
                    ArgsV.push_back(ast_compile(param));

                if (!param_list)
                    break;

                param = param_list->first;        // Now for the rest of parameters.
                param_list = param_list->second;

                func_param = func_param->u.eParameter.next;
            }

            Builder.CreateCall(CalleeF, ArgsV, "");  // Create a call to this procedure with the arguments from the vector.

            return nullptr;
        }
        case FUNC_CALL:
        {
            /**
             * FUNCTION CALL
             * t->id is the name(id) of the function.
             * t->first is the first expression.
             * t->second is the expression list.
             */
            SymbolEntry* func = lookup(t->id);  // Find the function in the Symbol table.
            if (func->u.eFunction.resultType == typeVoid)
                fatal("Function must have a return type\n");

            // Semantic check of expressions. (Sets correct type of expressions)
            ast_sem(t->first);
            ast_sem(t->second);
            // Check if all parameters(expressions) to the procedure are of the correct type.
            check_parameters(func, t->first, t->second, "func");
            t->type = func->u.eFunction.resultType;

            // Look up the name in the global module table.
            llvm::Function* CalleeF = TheModule->getFunction(t->id);
            if (!CalleeF)
                return LogErrorV("Unknown function referenced");

            // Argsv will hold the frame and the arguments of the callee procedure.
            std::vector<llvm::Value*> ArgsV;
            auto n = StackFrames.size();

            // If function is "main" or one of the lib functions,
            // there is no parent frame
            if (strcmp(t->id, "main") != 0 &&
                std::find(std::begin(lib_names), std::end(lib_names), std::string{t->id}) == std::end(lib_names)) {
                SymbolEntry* se = lookup(t->id);  // Find function in Symbol table.
                /**
                 * When the caller's nesting level is greater than callee's, it means that they are declared by the same
                 * outer function (e.g. during mutual recursion). Then, the caller should not provide the callee with his
                 * own frame, but with his parent frame. So, the caller and the callee will have the same parent frame.
                 */
                if (currentScope->nestingLevel > se->nestingLevel && n > 1) {
                    llvm::Value* CurStackFramePtr = Builder.CreateStructGEP(StackFrameTypes.back(), StackFrames.back(), 0);
                    ArgsV.push_back(Builder.CreateLoad(CurStackFramePtr, ""));
                }
                // Else the caller must provide his own frame as parent frame for the callee.
                else
                    ArgsV.push_back(StackFrames.back());
            }

            ast param = t->first;        // The first expression.
            ast param_list = t->second;  // The expression list.

            SymbolEntry* func_param = func->u.eFunction.firstArgument;
            bool passByReference;
            // For every parameter (argument of the function) do:
            while (param != nullptr) {

                passByReference = func_param->u.eParameter.mode == PASS_BY_REFERENCE ||
                                  func_param->u.eParameter.type->kind == Type_tag::TYPE_ARRAY;

                if (passByReference)
                    ArgsV.push_back(ast_compile(param->first));  // Compile the l_value of the expression and push it to the vector.
                else if (func_param->u.eParameter.type->kind == Type_tag::TYPE_IARRAY && param->first->k != STR) {
                    // If it's an IARRAY then create pointer to the l_value.
                    llvm::Value* Pointer;
                    std::vector<llvm::Value*> indexList{ c16(0), c16(0) };
                    llvm::Value* Id = ast_compile(param->first);
                    llvm::Type* PointeeType = Id->getType()->getPointerElementType();

                    Pointer = llvm::GetElementPtrInst::Create(PointeeType, Id, llvm::ArrayRef<llvm::Value*>(indexList), "lvalue_ptr", Builder.GetInsertBlock());
                    ArgsV.push_back(Pointer);
                }
                else
                    // Compile the expression and put it in the Vector.
                    ArgsV.push_back(ast_compile(param));

                if (!param_list)
                    break;

                param = param_list->first;        // Now for the rest of parameters.
                param_list = param_list->second;

                func_param = func_param->u.eParameter.next;
            }

            return Builder.CreateCall(CalleeF, ArgsV, "fcalltmp");  // Create a call to this function with the arguments from the vector.
        }
        case ID:
        {
            /**
             * ID of a variable.
             * t->id is the id(name) of the variable.
             */
            SymbolEntry* se = lookup(t->id);  // Look up the variable in the symbol table.

            t->type = se->u.eVariable.type;

            // Find the nesting difference and the offset of the variable
            // in order to load it correctly from the stack frame.
            t->nesting_diff = int(currentScope->nestingLevel) - se->nestingLevel;
            t->offset = se->u.eVariable.offset;

            llvm::Value* CurStackFrame = StackFrames.back(); // A pointer to stack frame struct
            llvm::Type* CurStackFrameType = StackFrameTypes.back();
            // Load the correct stack frame, by loading sequentially from the current stack frame.
            for (auto i = t->nesting_diff; i > 0; --i) {
                // CurStackFramePtr is a pointer at position 0 of current stack frame which contains a pointer to the parent stack frame
                llvm::Value* CurStackFramePtr = Builder.CreateStructGEP(CurStackFrameType, CurStackFrame, 0);
                CurStackFrame = Builder.CreateLoad(CurStackFramePtr, "");
                CurStackFrameType = CurStackFrame->getType()->getPointerElementType();
            }

            // Through the offset, find the correct place of the variable in the stack frame.
            llvm::Value* Id = Builder.CreateStructGEP(CurStackFrameType, CurStackFrame, t->offset);
            // And load the variable from the correct place.
            if (llvm::dyn_cast<llvm::PointerType>(Id->getType()->getPointerElementType()))
                Id = Builder.CreateLoad(Id, "temp");

            return Id;
        }
        case STR:
        {
            /**
             * STRING
             * t->id is the string.
             */
            std::string s(t->id);
            return Builder.CreateGlobalString(s, "str");
        }
        case L_VALUE:
        {
            /**
             * L_VALUE
             * t->first is another l_value, meaning kind l_value or id or string.
             * t->second is an expression inside the brackets.
             */
            ast p = l_value_type(t, 0);  // Find the type of the l_value.
            t->type = p->type;
            free(p);

            std::vector<llvm::Value*> indexList;
            // Compile every expression that may exist in the l_value tree and push it to the vector.
            // Because of the way we traverse the l_value tree the indexList we will need later to reverse it.
            // If e.g. we have {id} [expr1] [expr2] [expr3], indexList will be {expr3, expr2, expr1}
            ast ast_iter = t;
            while (ast_iter->first != nullptr) {
                indexList.push_back(ast_compile(ast_iter->second));
                ast_iter = ast_iter->first;
            }
            indexList.push_back(c16(0));  // We push 0 to the list, because it is needed for the GetElementPtrInst.
            std::reverse(indexList.begin(), indexList.end());  // Reverse the list.

            llvm::Value* Id = ast_compile(ast_iter);

            // Get correct pointer to the element, using the indexList.
            llvm::Type* PointeeType = Id->getType()->getPointerElementType();
            llvm::Value* Pointer = llvm::GetElementPtrInst::Create(PointeeType, Id, llvm::ArrayRef<llvm::Value*>(indexList), "lvalue_ptr", Builder.GetInsertBlock());

            return Pointer;
        };
        case R_VALUE:
        {
            /**
             * R_VALUE
             * t->first is the l_value.
             */
            llvm::Value* LValue = ast_compile(t->first); // Compile l_value.
            t->type = t->first->type;

            if (t->first->k == STR)     // String as rvalue does not need to create a load. Just return the pointer
                return llvm::GetElementPtrInst::Create(LValue->getType()->getPointerElementType(), LValue, llvm::ArrayRef<llvm::Value*>(std::vector<llvm::Value*>{c16(0), c16(0)}), "str_ptr", Builder.GetInsertBlock());
            else
                return Builder.CreateLoad(LValue, "rvalue");  // Create Load to this l_value.
        }
    }
}

void llvm_compile_and_dump(ast t)
{
//    ast_sem(t);

    TheModule = llvm::make_unique<llvm::Module>("dana program", TheContext);

    TheFPM = std::make_unique<llvm::legacy::FunctionPassManager>(TheModule.get());

    TheFPM->add(llvm::createCFGSimplificationPass());
    TheFPM->add(llvm::createDeadStoreEliminationPass());
    TheFPM->add(llvm::createDeadInstEliminationPass());
    TheFPM->add(llvm::createMergedLoadStoreMotionPass());
    TheFPM->add(llvm::createGVNPass());
    TheFPM->add(llvm::createInstructionCombiningPass());
    TheFPM->add(llvm::createLICMPass()); // Loop Invariant Code Move
    TheFPM->add(llvm::createPromoteMemoryToRegisterPass());
    TheFPM->add(llvm::createConstantHoistingPass());

//    TheFPM->add(llvm::createAggressiveDCEPass());
//    TheFPM->add(llvm::createReassociatePass());
//    TheFPM->add(llvm::createEarlyCSEPass());
//    TheFPM->add(llvm::createSCCPPass()); // Only DCE has worked so far
//    TheFPM->add(llvm::createConstantPropagationPass());
//    TheFPM->add(llvm::createJumpThreadingPass());
//    TheFPM->add(llvm::createLoopDeletionPass()); // Check
//    TheFPM->add(llvm::createSimpleLoopUnrollPass());
//    TheFPM->add(llvm::createLoopUnrollPass());
//    TheFPM->add(llvm::createLCSSAPass());
//    TheFPM->add(llvm::createIndVarSimplifyPass());

//    TheFPM->add(llvm::createCorrelatedValuePropagationPass());
//    TheFPM->add(llvm::createVerifierPass());
//    TheFPM->add(llvm::createTailCallEliminationPass());
//    TheFPM->add(llvm::createLoopIdiomPass());

    ast_compile(t);

    // Verify and optimize the main function.
    bool bad = verifyModule(*TheModule, &llvm::errs());
    if (bad) {
        fprintf(stderr, "The faulty IR is:\n");
        fprintf(stderr, "------------------------------------------------\n\n");
        TheModule->print(llvm::errs(), nullptr);
        return;
    }

    fprintf(stdout, "Compilation was successful.\n");
    fprintf(stdout, "The IR is:\n");
    fprintf(stdout, "------------------------------------------------\n\n");
    TheModule->print(llvm::outs(), nullptr);
}

llvm::Type* to_llvm_type(Type type) {
    /**
     * Get corresponding llvm type.
     * Special case:
     * IARRAY returns a pointer to the part of the array that is known.
     * (e.g. int[][20] -> *int[20])
     */
    switch(type->kind) {
        case Type_tag::TYPE_VOID:
            return llvm_void;
        case Type_tag::TYPE_INTEGER:
            return llvm_int;
        case Type_tag::TYPE_CHAR:
            return llvm_byte;
        case Type_tag::TYPE_POINTER:
            return llvm::PointerType::get(to_llvm_type(type->refType), 0);
        case Type_tag::TYPE_ARRAY:
            return llvm::ArrayType::get(to_llvm_type(type->refType),type->size);
        case Type_tag::TYPE_IARRAY:
            return llvm::PointerType::get(to_llvm_type(type->refType),0);
        default:
            return nullptr;
    }
}

static llvm::Function* TheWriteInteger;
static llvm::Function* TheWriteChar;
static llvm::Function* TheWriteByte;
static llvm::Function* TheWriteString;
static llvm::Function* TheReadString;
static llvm::Function* TheReadInteger;
static llvm::Function* TheReadChar;
static llvm::Function* TheStrlen;
static llvm::Function* TheStrcmp;
static llvm::Function* TheStrcpy;
static llvm::Function* TheStrcat;
static llvm::Function* TheShrink;
static llvm::Function* TheExtend;
static llvm::Function* TheReadByte;

void declare_dana_libs()
{
    SymbolEntry* f;
    std::string func_name;
    char* cstr;

    std::string n_str = "n";
    std::string b_str = "b";
    std::string s_str = "s";
    std::string i_str = "i";
    std::string s1_str = "s1";
    std::string s2_str = "s2";
    std::string trg_str = "trg";
    std::string src_str = "src";

    char* n = &n_str[0];
    char* b = &b_str[0];
    char* s = &s_str[0];
    char* i = &i_str[0];
    char* s1 = &s1_str[0];
    char* s2 = &s2_str[0];
    char* trg = &trg_str[0];
    char* src = &src_str[0];

    // declare void @writeInteger(i32)
    func_name = "writeInteger";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(n, typeInteger, f);
    endFunctionHeader(f, typeVoid);
    closeScope();

    llvm::FunctionType* writeInteger_type =
            llvm::FunctionType::get(llvm_void,
                                    std::vector<llvm::Type*>{ llvm_int }, false);
    TheWriteInteger =
            llvm::Function::Create(writeInteger_type, llvm::Function::ExternalLinkage,
                                   "writeInteger", TheModule.get());

    // declare void @writeByte(i8)
    func_name = "writeByte";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(b, typeChar, f);
    endFunctionHeader(f, typeVoid);
    closeScope();

    llvm::FunctionType* writeByte_type =
            llvm::FunctionType::get(llvm_void,
                                    std::vector<llvm::Type*>{ llvm_byte }, false);
    TheWriteByte =
            llvm::Function::Create(writeByte_type, llvm::Function::ExternalLinkage,
                                   "writeByte", TheModule.get());


    // declare void @writeChar(i8)
    func_name = "writeChar";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(b, typeChar, f);
    endFunctionHeader(f, typeVoid);
    closeScope();

    llvm::FunctionType* writeChar_type =
            llvm::FunctionType::get(llvm::Type::getVoidTy(TheContext),
                                    std::vector<llvm::Type*>{ llvm_byte }, false);
    TheWriteChar =
            llvm::Function::Create(writeChar_type, llvm::Function::ExternalLinkage,
                                   "writeChar", TheModule.get());

    // declare void @writeString(i8*)
    func_name = "writeString";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(s, typeIArray(typeChar), f);
    endFunctionHeader(f, typeVoid);
    closeScope();

    llvm::FunctionType* writeString_type =
            llvm::FunctionType::get(llvm_void,
                                    std::vector<llvm::Type*>{ llvm::PointerType::get(llvm_byte, 0) },
                                    false);
    TheWriteString =
            llvm::Function::Create(writeString_type, llvm::Function::ExternalLinkage,
                                   "writeString", TheModule.get());

    // declare int @readInteger()

    func_name = "readInteger";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    endFunctionHeader(f, typeInteger);
    closeScope();

    llvm::FunctionType* readInteger_type =
            llvm::FunctionType::get(llvm_int,
                                    std::vector<llvm::Type*>{}, false);
    TheReadInteger =
            llvm::Function::Create(readInteger_type, llvm::Function::ExternalLinkage,
                                   "readInteger", TheModule.get());

    // declare i8 @readByte()
    func_name = "readByte";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    endFunctionHeader(f, typeChar);
    closeScope();

    llvm::FunctionType* readByte_type =
            llvm::FunctionType::get(llvm_byte,
                                    std::vector<llvm::Type*>{}, false);
    TheReadByte =
            llvm::Function::Create(readByte_type, llvm::Function::ExternalLinkage,
                                   "readByte", TheModule.get());

    // declare i8 @readChar()
    func_name = "readChar";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    endFunctionHeader(f, typeChar);
    closeScope();

    llvm::FunctionType* readChar_type =
            llvm::FunctionType::get(llvm_byte,
                                    std::vector<llvm::Type*>{}, false);
    TheReadChar =
            llvm::Function::Create(readChar_type, llvm::Function::ExternalLinkage,
                                   "readChar", TheModule.get());

    // declare void @readString(i32, i8*)
    func_name = "readString";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(n, typeInteger, f);
    insertParameter(s, typeIArray(typeChar), f);
    endFunctionHeader(f, typeVoid);
    closeScope();

    llvm::FunctionType* readString_type =
            llvm::FunctionType::get(llvm_void,
                                    std::vector<llvm::Type*>{ llvm_int, llvm::PointerType::get(llvm_byte, 0) },
                                    false);
    TheReadString =
            llvm::Function::Create(readString_type, llvm::Function::ExternalLinkage,
                                   "readString", TheModule.get());

    // declare int @extend(i8)
    func_name = "extend";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(b, typeChar, f);
    endFunctionHeader(f, typeInteger);
    closeScope();

    llvm::FunctionType* extend_type =
            llvm::FunctionType::get(llvm_int,
                                    std::vector<llvm::Type*>{ llvm_byte }, false);
    TheExtend =
            llvm::Function::Create(extend_type, llvm::Function::ExternalLinkage,
                                   "extend", TheModule.get());

    // declare byte @shrink(i32)
    func_name = "shrink";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(i, typeInteger, f);
    endFunctionHeader(f, typeChar);
    closeScope();

    llvm::FunctionType* shrink_type =
            llvm::FunctionType::get(llvm_byte,
                                    std::vector<llvm::Type*>{ llvm_int }, false);
    TheShrink =
            llvm::Function::Create(shrink_type, llvm::Function::ExternalLinkage,
                                   "shrink", TheModule.get());

    // declare int @strlen(i8*)
    func_name = "strlen";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(s, typeIArray(typeChar), f);
    endFunctionHeader(f, typeInteger);
    closeScope();

    llvm::FunctionType* strlen_type =
            llvm::FunctionType::get(llvm_int,
                                    std::vector<llvm::Type*>{ llvm::PointerType::get(llvm_byte, 0) },
                                    false);
    TheStrlen =
            llvm::Function::Create(strlen_type, llvm::Function::ExternalLinkage,
                                   "strlen", TheModule.get());

    // declare int @strcmp(i8*, i8*)
    func_name = "strcmp";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(s1, typeIArray(typeChar), f);
    insertParameter(s2, typeIArray(typeChar), f);
    endFunctionHeader(f, typeInteger);
    closeScope();

    llvm::FunctionType* strcmp_type =
            llvm::FunctionType::get(llvm_int,
                                    std::vector<llvm::Type*>{ llvm::PointerType::get(llvm_byte, 0),
                                                              llvm::PointerType::get(llvm_byte, 0) },
                                    false);
    TheStrcmp =
            llvm::Function::Create(strcmp_type, llvm::Function::ExternalLinkage,
                                   "strcmp", TheModule.get());

    // declare void @strcpy(i8*, i8*)
    func_name = "strcpy";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(trg, typeIArray(typeChar), f);
    insertParameter(src, typeIArray(typeChar), f);
    endFunctionHeader(f, typeVoid);
    closeScope();

    llvm::FunctionType* strcpy_type =
            llvm::FunctionType::get(llvm_void,
                                    std::vector<llvm::Type*>{ llvm::PointerType::get(llvm_byte, 0), llvm::PointerType::get(llvm_byte, 0) }, false);
    TheStrcpy =
            llvm::Function::Create(strcpy_type, llvm::Function::ExternalLinkage,
                                   "strcpy", TheModule.get());

    // declare void @strcat(i8*, i8*)
    func_name = "strcat";
    cstr = &func_name[0];
    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(trg, typeIArray(typeChar), f);
    insertParameter(src, typeIArray(typeChar), f);
    endFunctionHeader(f, typeVoid);
    closeScope();

    llvm::FunctionType* strcat_type =
            llvm::FunctionType::get(llvm_void,
                                    std::vector<llvm::Type*>{ llvm::PointerType::get(llvm_byte, 0), llvm::PointerType::get(llvm_byte, 0) }, false);
    TheStrcat =
            llvm::Function::Create(strcat_type, llvm::Function::ExternalLinkage,
                                   "strcat", TheModule.get());


}
