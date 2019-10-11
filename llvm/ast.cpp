#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include "ast.h"
#include "auxiliary.h"
#include "logger.h"
#include "symbol.h"


loop_record current_LR = nullptr;
function_code_list current_CL = nullptr;
std::vector<char*> func_names;
char* curr_func_name;
std::vector<llvm::BasicBlock*> merge_blocks;

static ast ast_make (kind k, char* s, int n,
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
static std::map<std::string, llvm::AllocaInst*> NamedValues;
static std::vector<std::map<std::string, llvm::AllocaInst*>> FunctionVariables;
static std::vector<std::map<std::string, llvm::AllocaInst*>> ShadowedVariables;

// Useful LLVM types.
static llvm::Type* llvm_bit = llvm::IntegerType::get(TheContext, 1);
static llvm::Type* llvm_byte = llvm::IntegerType::get(TheContext, 8);
static llvm::Type* llvm_int = llvm::IntegerType::get(TheContext, 32);
static llvm::Type* llvm_void = llvm::Type::getVoidTy(TheContext);
//static Type* i64 = IntegerType::get(TheContext, 64);

// Useful LLVM helper functions.
inline llvm::ConstantInt* c8(char c) {
  return llvm::ConstantInt::get(TheContext, llvm::APInt(8, c, false));
}

inline llvm::ConstantInt* c32(int n) {
  return llvm::ConstantInt::get(TheContext, llvm::APInt(32, n, false));
}

inline llvm::ConstantPointerNull* llvm_null(llvm::PointerType* llvm_type) {
    return llvm::ConstantPointerNull::get(llvm_type);
}

// CreateEntryBlockAlloca - Create an alloca instruction in the entry block of
// the function.  This is used for mutable variables etc.
static llvm::AllocaInst* CreateEntryBlockAlloca(llvm::Function* TheFunction,
                                                const std::string& VarName,
                                                llvm::Type* VarType)
{
    llvm::IRBuilder<> TmpB(&TheFunction->getEntryBlock(),
                           TheFunction->getEntryBlock().begin());

    return TmpB.CreateAlloca(VarType, 0, VarName.c_str());
}

llvm::Value* ast_compile(ast t)
{
    if (!t)
        return nullptr;

    switch (t->k) {

        case PROGRAM:
        {
            openScope();
            NamedValues.clear(); // TODO: check

            llvm::Value* V = ast_compile(t->first);
            closeScope();
            return V;
        }
        case FUNC_DECL:
        {
            llvm::Value* V = ast_compile(t->first);
            closeScope();
            return V;
        }
        case FUNC_DEF:
        {
            curr_func_name = t->first->id;
            func_names.push_back(curr_func_name);
            llvm::Function* TheFunction = TheModule->getFunction(curr_func_name);

            if (!TheFunction)
                TheFunction = static_cast<llvm::Function*>(ast_compile(t->first));

            if (!TheFunction)
                return nullptr;

            if (!TheFunction->empty())
                return (llvm::Function*)LogErrorV("Function cannot be redefined.") ;

            llvm::BasicBlock* OldBB = Builder.GetInsertBlock();

            // Create a new basic block to start insertion into.
            llvm::BasicBlock* BB = llvm::BasicBlock::Create(TheContext, "entry", TheFunction);
            Builder.SetInsertPoint(BB);

            // All of parameters and local variables of the function
            std::map<std::string, llvm::AllocaInst*> CurFunctionVars;
            // Parameters and local variables of the function that shadow some other variables
            std::map<std::string, llvm::AllocaInst*> CurShadowedVars;

            bool acceptByReference;

            // Record the function arguments in the NamedValues map.
            for (auto& Arg : TheFunction->args()) {

                std::string ArgName(Arg.getName());

                char var_id[ArgName.size() + 1];
                strcpy(var_id, ArgName.c_str()); // ArgName is const
                SymbolEntry* se = lookup(var_id);

                llvm::AllocaInst* Alloca = nullptr;

                acceptByReference = se->u.eParameter.mode == PASS_BY_REFERENCE ||
                                    se->u.eParameter.type->kind == Type_tag::TYPE_ARRAY ||
                                    se->u.eParameter.type->kind == Type_tag::TYPE_IARRAY;

                if (!acceptByReference) {
                    // Create an alloca for this variable.
                    Alloca = CreateEntryBlockAlloca(TheFunction, ArgName, Arg.getType());

                    // Store the initial value into the alloca.
                    Builder.CreateStore(&Arg, Alloca);
                }

                // If variable already exists, shadow it and keep the old value
                if (NamedValues.count(ArgName))
                    CurShadowedVars[ArgName] = NamedValues[ArgName];

                // Store the new variable globally
                if (!acceptByReference)
                    NamedValues[ArgName] = Alloca;
                else if (se->u.eParameter.type->kind == Type_tag::TYPE_IARRAY) {
//                    auto Tmp = Builder.CreateLoad(&Arg, "iarray");
                    auto PointeeType = to_llvm_type(se->u.eParameter.type->refType);
                    auto Tmp = new llvm::BitCastInst(&Arg, llvm::PointerType::get(llvm::ArrayType::get(PointeeType, 1),0), "cast", BB);

//                    llvm::Value* Pointer = llvm::GetElementPtrInst::Create(PointeeType, &Arg, llvm::ArrayRef<llvm::Value*>(std::vector<llvm::Value*>{c32(0)}), "makaris", Builder.GetInsertBlock());
                    NamedValues[ArgName] = reinterpret_cast<llvm::AllocaInst *>(Tmp);
                }
                else
                    NamedValues[ArgName] = reinterpret_cast<llvm::AllocaInst *>(&Arg);

                //  Store the new variable locally to the function
                CurFunctionVars[ArgName] = NamedValues[ArgName];
            }

            ShadowedVariables.push_back(CurShadowedVars);
            FunctionVariables.push_back(CurFunctionVars);

            // Local def lists
            llvm::Value* VS = ast_compile(t->second);

            Builder.SetInsertPoint(BB);

            // TheBody should normally be nullptr after ast_compile()
            llvm::Value* TheBody = ast_compile(t->third);

            if (!TheBody) {
                if (TheFunction->getReturnType() == llvm_void) {

                    // Finish off the proc.
                    Builder.CreateRetVoid();
                }
            }

            // Reset curr func name
            func_names.pop_back();
            curr_func_name = func_names.back();

            // Validate the generated code, checking for consistency.
            llvm::verifyFunction(*TheFunction);

            // Pop variables
            auto vars = FunctionVariables.back();
            for (auto& v : vars)
                NamedValues.erase(v.first);
            FunctionVariables.pop_back();

            // Pop shadow variables
            auto shadows = ShadowedVariables.back();
            for (auto& s : shadows)
                NamedValues[s.first] = s.second;
            ShadowedVariables.pop_back();

            closeScope();
            if(OldBB)
                Builder.SetInsertPoint(OldBB);
            return TheFunction;
        }
        case HEADER:
        {
            Type func_type = typeVoid;
            llvm::Type* llvm_func_type = llvm_void;

            if (t->type != nullptr) {
                func_type = t->type;    // Check func or proc
                llvm_func_type = to_llvm_type(t->type);
            }

            SymbolEntry* f = insertFunction(t->id, func_type);
            if (f == nullptr) {
                return nullptr;    // f == nullptr means, function was declared before
            }                      // The rest has already been done

            std::vector<llvm::Type*> Params;
            std::vector<std::string> Args;

            // We open the scope of the current function that was
            // just inserted. The name of the function itself, though, has
            // been inserted to the previous scope.
            openScope();

            ast par_def = t->first;         // First is fpar_def
            ast fpar_def_list = t->second;

            Type par_type = nullptr;
            llvm::Type* llvm_par_ty= llvm_void;

            while (par_def != nullptr) {

                ast_compile(par_def->second);           // Second is fpar_type
                par_type = par_def->second->type;
                llvm_par_ty = to_llvm_type(par_type);   // Get corresponding llvm type

                if (par_type->kind == Type_tag::TYPE_ARRAY)
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

                par_def = fpar_def_list->first;        // Now for the rest of fpar_defs.
                fpar_def_list = fpar_def_list->second;
            }

            llvm::FunctionType* FT =
                    llvm::FunctionType::get(llvm_func_type, Params, false);

            llvm::Function* F =
                    llvm::Function::Create(FT, llvm::Function::ExternalLinkage,
                                           t->id, TheModule.get());

            // Set names for all arguments.
            unsigned Idx = 0;
            for (auto& Arg : F->args())
                Arg.setName(Args[Idx++]);

            return F;
        }
        case SEQ:
        {
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
            t->type = var_def_type(t->type, t->first);
            return nullptr;
        }
        case REF_TYPE:
        {
            t->type = typePointer(t->type);
            return nullptr;
        }
        case IARRAY_TYPE:
        {
            Type my_type = var_def_type(t->type, t->first);
            t->type = typeIArray(my_type);
            return nullptr;
        }
        case CONST:
        {
            t->type = typeInteger;
            return c32(t->num);
        }
        case CHAR:
        {
            t->type = typeChar;
            return c8(t->num);
        }

        // TODO: check if works
        case IF:
        {
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
                    c32(0), "ifcond");

            llvm::Function* TheFunction = Builder.GetInsertBlock()->getParent();

            // Create blocks for the then and else cases.  Insert the 'then' block at the
            // end of the function.
            llvm::BasicBlock* ThenBB = llvm::BasicBlock::Create(TheContext, "then", TheFunction); // ??
            llvm::BasicBlock* ElifBB = llvm::BasicBlock::Create(TheContext, "elif");
            llvm::BasicBlock* MergeBB = llvm::BasicBlock::Create(TheContext, "ifcont");

            merge_blocks.push_back(MergeBB);

            Builder.CreateCondBr(CondV, ThenBB, ElifBB);

            // Emit then value.
            Builder.SetInsertPoint(ThenBB);

            // Generate code for "then" block
            llvm::Value* ExitStmt = ast_compile(t->second);

            if (!ExitStmt)
                Builder.CreateBr(MergeBB);

            // Emit elif block.
            TheFunction->getBasicBlockList().push_back(ElifBB); // ??
            Builder.SetInsertPoint(ElifBB);

            // Generate code for "elif list" blocks
            ast_compile(t->third);

            Builder.CreateBr(MergeBB);

            // Emit merge block.
            TheFunction->getBasicBlockList().push_back(MergeBB); // ??
            Builder.SetInsertPoint(MergeBB);

            merge_blocks.pop_back();
            return nullptr;
        }
        case ELIF:
        {
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
                    c32(0), "elifcond");

            llvm::Function* TheFunction = Builder.GetInsertBlock()->getParent();

            // Create blocks for the then and else cases.  Insert the 'then' block at the
            // end of the function.
            llvm::BasicBlock* ThenBB = llvm::BasicBlock::Create(TheContext, "elifthen", TheFunction); // ??
            llvm::BasicBlock* ElifBB = llvm::BasicBlock::Create(TheContext, "elif");
            llvm::BasicBlock* MergeBB = llvm::BasicBlock::Create(TheContext, "elifcont");
//            llvm::BasicBlock* MergeBB = Builder.GetInsertBlock();

            Builder.CreateCondBr(CondV, ThenBB, ElifBB);

            // Emit then value.
            Builder.SetInsertPoint(ThenBB);

            // Generate code for "elifthen" block
            llvm::Value* ExitStmt = ast_compile(t->second);

            if (!ExitStmt)
                Builder.CreateBr(merge_blocks.back());

            // Emit else block.
            TheFunction->getBasicBlockList().push_back(ElifBB); // ??
            Builder.SetInsertPoint(ElifBB);

            // Generate code for "elif list" blocks
            ast_compile(t->third);

            Builder.CreateBr(MergeBB);

            // Emit merge block.
            TheFunction->getBasicBlockList().push_back(MergeBB); // ??
            Builder.SetInsertPoint(MergeBB);

            return nullptr;
        }
        case IF_ELSE:
        {
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
                    c32(0), "ifcond");

            llvm::Function* TheFunction = Builder.GetInsertBlock()->getParent();

            // Create blocks for the then and else cases.  Insert the 'then' block at the
            // end of the function.
            llvm::BasicBlock* ThenBB = llvm::BasicBlock::Create(TheContext, "then", TheFunction); // ??
            llvm::BasicBlock* ElifBB = llvm::BasicBlock::Create(TheContext, "elif");
            llvm::BasicBlock* ElseBB = llvm::BasicBlock::Create(TheContext, "else");
            llvm::BasicBlock* MergeBB = llvm::BasicBlock::Create(TheContext, "ifcont");

            merge_blocks.push_back(MergeBB);

            Builder.CreateCondBr(CondV, ThenBB, ElifBB);

            // Emit then value.
            Builder.SetInsertPoint(ThenBB);

            // Generate code for "then" block
            llvm::Value* ExitStmt = ast_compile(t->second);

            if (!ExitStmt)
                // Create branch to "ifcont"
                Builder.CreateBr(MergeBB);

            // Emit elif block.
            TheFunction->getBasicBlockList().push_back(ElifBB); // ??
            Builder.SetInsertPoint(ElifBB);

            // Generate code for "elif list" blocks
            ast_compile(t->third);

            Builder.CreateBr(ElseBB);

            // Emit else block.
            TheFunction->getBasicBlockList().push_back(ElseBB); // ??
            Builder.SetInsertPoint(ElseBB);

            // Generate code for "else" block
            ExitStmt = ast_compile(t->last);

            if (!ExitStmt)
                // Create branch to "ifcont"
                Builder.CreateBr(MergeBB);

           // Emit merge block.
            TheFunction->getBasicBlockList().push_back(MergeBB); // ??
            Builder.SetInsertPoint(MergeBB);

            merge_blocks.pop_back();
            return nullptr;
        }
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

            // Make the new basic block for the loop header, inserting after current
            // block.
            llvm::Function* TheFunction = Builder.GetInsertBlock()->getParent();
            llvm::BasicBlock* LoopBB =
                    llvm::BasicBlock::Create(TheContext, "loop", TheFunction);
            llvm::BasicBlock* AfterBB =
                    llvm::BasicBlock::Create(TheContext, "afterloop");

            Builder.CreateBr(LoopBB);

            // Start insertion in LoopBB.
            Builder.SetInsertPoint(LoopBB);

            new_LR->loop_block = LoopBB;
            new_LR->after_block = AfterBB;
            current_LR = new_LR;

            // Emit the body of the loop.
            auto ExitStmt = ast_compile(t->first);

            if (!ExitStmt) {
                // Insert the unconditional branch into the end of LoopBB.
                Builder.CreateBr(LoopBB);
            }

            TheFunction->getBasicBlockList().push_back(AfterBB);
            // Any new code will be inserted in AfterBB.
            Builder.SetInsertPoint(AfterBB);

            current_LR = current_LR->previous;
            free(new_LR);

            return nullptr;
        }
        case FPAR_DEF:break;
        case BREAK:
        {
            loop_record lr;
            if (t->id != nullptr) {
                lr = look_up_loop(t->id);
                if (!lr) {
                    error("Loop identifier does not exist!\n");
                    exit(1);
                }
                return Builder.CreateBr(lr->after_block);
            }
            else if (current_LR == nullptr)
                error("No loop to break");
            else
                return Builder.CreateBr(current_LR->after_block);
        }
        case CONTINUE:
        {
            loop_record lr;
            if (t->id != nullptr) {
                lr = look_up_loop(t->id);
                if (!lr) {
                    error("Loop identifier does not exist!\n");
                    exit(1);
                }
                return Builder.CreateBr(lr->loop_block);
            }
            else if (current_LR == nullptr)
                error("No loop to continue");
            else
                return Builder.CreateBr(current_LR->loop_block);
        }
        case EXIT:
        {
            SymbolEntry* curr_func = lookup(curr_func_name);
            Type curr_func_type = curr_func->u.eFunction.resultType;
            Type return_type = typeVoid;
            check_result_type(curr_func_type, return_type, curr_func_name);

            return Builder.CreateRetVoid();
        }
        case RETURN:
        {
            llvm::Value* RetV = ast_compile(t->first);
            SymbolEntry* curr_func = lookup(curr_func_name);
            Type curr_func_type = curr_func->u.eFunction.resultType;
            Type return_type = t->first->type;
            check_result_type(curr_func_type, return_type, curr_func_name);

            // Cast byte to int if necessary
            if (equalType(curr_func_type, typeInteger) && equalType(return_type, typeChar))
                RetV = Builder.CreateIntCast(RetV, llvm_int, true);

            return Builder.CreateRet(RetV);
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
            llvm::Value* S = ast_compile(t->second);
            // UN_PLUS operand must be integer
            t->type = check_op_type(t->second->type, typeInteger, "unary +");
            return Builder.CreateAdd(c32(0), S, "uaddtmp");
        }
        case UN_MINUS:
        {
            llvm::Value* S = ast_compile(t->second);
            // UN_MINUS operand must be integer
            t->type = check_op_type(t->second->type, typeInteger, "unary -");
            return Builder.CreateSub(c32(0), S, "usubtmp");
        }
        case PLUS:
        {
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "+");
            return Builder.CreateAdd(F, S, "addtmp");
        }
        case MINUS:
        {
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "-");
            return Builder.CreateBinOp(llvm::Instruction::Sub, F, S, "subtmp");
        }
        case TIMES:
        {
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "*");
            return Builder.CreateMul(F, S, "multmp");
        }
        case DIV:
        {
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "/");
            return Builder.CreateSDiv(F, S, "divtmp");
        }
        case MOD:
        {
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            t->type = check_op_type(t->first->type, t->second->type, "%");
            return Builder.CreateSRem(F, S, "modtmp");
        }
        case BIT_NOT:
        {
            llvm::Value* F = ast_compile(t->first);
            check_op_type(t->first->type, typeChar, "!");
            t->type = t->first->type;
            return Builder.CreateNot(F, "bitnot");
        }
        case BIT_AND:
        {
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            check_op_type(t->first->type, typeChar, "&");
            t->type = check_op_type(t->first->type, t->second->type, "&");
            return Builder.CreateAnd(F, S, "bitand");
        }
        case BIT_OR:
        {
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);
            check_op_type(t->first->type, typeChar, "|");
            t->type = check_op_type(t->first->type, t->second->type, "|");
            return Builder.CreateOr(F, S, "bitor");
        }
        case BOOL_NOT:
        {
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
                    c32(0), "inttobit");

            t->type = typeChar;

            return Builder.CreateNot(CondV, "boolnot");
        }
        case BOOL_AND:
        {
            /*
             * We compute the first operand.
             * If it is zero, result is zero.
             * Else result is (1 and second operand) = second operand.
             */
            llvm::Value* F = ast_compile(t->first);

            if (!F)
                return nullptr;

            Type expr_type = t->first->type;
            if (!equalType(expr_type, typeInteger) && !equalType(expr_type, typeChar))
                error("Condition must be Integer or Byte!");

            // Cast byte to int if necessary
            if (equalType(expr_type, typeChar))
                F = Builder.CreateIntCast(F, llvm_int, true);

            // Convert condition to a bool by comparing non-equal to 0.0.
            F = Builder.CreateICmpEQ(
                    F,
                    c32(0), "finttobit");

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

            llvm::Value* S = ast_compile(t->second);

            if (!S)
                return nullptr;

            expr_type = t->second->type;
            if (!equalType(expr_type, typeInteger) && !equalType(expr_type, typeChar))
                error("Condition must be Integer or Byte!");

            // Cast byte to int if necessary
            if (equalType(expr_type, typeChar))
                S = Builder.CreateIntCast(S, llvm_int, true);

            // Convert condition to a bool by comparing non-equal to 0.0.
            S = Builder.CreateICmpNE(S, c32(0), "sinttobit");

            Builder.CreateBr(MergeBB);
            // codegen of 'Else' can change the current block, update ElseBB for the PHI.
            ElseBB = Builder.GetInsertBlock(); // ??

            // Emit merge block.
            TheFunction->getBasicBlockList().push_back(MergeBB);
            Builder.SetInsertPoint(MergeBB);
            llvm::PHINode* PN = Builder.CreatePHI(llvm_bit, 2, "andtmp");

            PN->addIncoming(F, ThenBB);
            PN->addIncoming(S, ElseBB);

            t->type = typeChar;

            return PN;
        }
        case BOOL_OR:
        {
            /*
             * We compute the first operand.
             * If it is one, result is one.
             * Else result is (0 or second operand) = second operand.
             */
            llvm::Value* F = ast_compile(t->first);

            if (!F)
                return nullptr;

            Type expr_type = t->first->type;
            if (!equalType(expr_type, typeInteger) && !equalType(expr_type, typeChar))
                error("Condition must be Integer or Byte!");

            // Cast byte to int if necessary
            if (equalType(expr_type, typeChar))
                F = Builder.CreateIntCast(F, llvm_int, true);

            // Convert condition to a bool by comparing non-equal to 0.0.
            F = Builder.CreateICmpNE(F, c32(0), "finttobit");

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
            ThenBB = Builder.GetInsertBlock(); // ??

            // Emit else block.
            TheFunction->getBasicBlockList().push_back(ElseBB);
            Builder.SetInsertPoint(ElseBB);

            llvm::Value* S = ast_compile(t->second);

            if (!S)
                return nullptr;

            expr_type = t->second->type;
            if (!equalType(expr_type, typeInteger) && !equalType(expr_type, typeChar))
                error("Condition must be Integer or Byte!");

            // Cast byte to int if necessary
            if (equalType(expr_type, typeChar))
                S = Builder.CreateIntCast(S, llvm_int, true);

            // Convert condition to a bool by comparing non-equal to 0.0.
            S = Builder.CreateICmpNE(S,c32(0), "sinttobit");

            Builder.CreateBr(MergeBB);
            // codegen of 'Else' can change the current block, update ElseBB for the PHI.
            ElseBB = Builder.GetInsertBlock(); // ??

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
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            check_op_type(t->first->type, t->second->type, "=");

            t->type = typeChar;

            return  Builder.CreateICmpEQ(F, S, "eq");
        }
        case NE:
        {
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            check_op_type(t->first->type, t->second->type, "<>");

            t->type = typeChar;

            return  Builder.CreateICmpNE(F, S, "ne");
        }
        case LT:
        {
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            check_op_type(t->first->type, t->second->type, "<");

            t->type = typeChar;

            if (t->first->type == typeChar)
                return  Builder.CreateICmpULT(F, S, "lt");
            else
                return  Builder.CreateICmpSLT(F, S, "lt");
        }
        case GT:
        {
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            check_op_type(t->first->type, t->second->type, ">");

            t->type = typeChar;

            if (t->first->type == typeChar)
                return  Builder.CreateICmpUGT(F, S, "gt");
            else
                return  Builder.CreateICmpSGT(F, S, "gt");
        }
        case LE:
        {
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            check_op_type(t->first->type, t->second->type, "<=");

            t->type = typeChar;

            if (t->first->type == typeChar)
                return  Builder.CreateICmpULE(F, S, "le");
            else
                return  Builder.CreateICmpSLE(F, S, "le");
        }
        case GE:
        {
            llvm::Value* F = ast_compile(t->first);
            llvm::Value* S = ast_compile(t->second);

            check_op_type(t->first->type, t->second->type, ">=");

            t->type = typeChar;

            if (t->first->type == typeChar)
                return  Builder.CreateICmpUGE(F, S, "ge");
            else
                return  Builder.CreateICmpSGE(F, S, "ge");
        }
        case INT_CONST_LIST:break;
        case ID_LIST:break;
        case LET:
        {
            llvm::Value* LVal = ast_compile(t->first);

            llvm::Value* Expr = ast_compile(t->second);
            if (!Expr) return nullptr;

            // TODO: maybe "and not array"
            if (!equalType(t->first->type, t->second->type))
                error("Type mismatch in assignment");
            t->nesting_diff = t->first->nesting_diff;
            t->offset = t->first->offset;

            Builder.CreateStore(Expr, LVal);

            return nullptr;
        }
        case VAR_DEF:
        {
            ast_compile(t->second);
            auto var_type = t->second->type;
            auto llvm_var_type = to_llvm_type(var_type);

            llvm::Function* TheFunction = TheModule->getFunction(curr_func_name);

            // Create an alloca for this variable.
            llvm::AllocaInst* Alloca = CreateEntryBlockAlloca(TheFunction, std::string(t->id), llvm_var_type);

            switch(var_type->kind) {
                case Type_tag::TYPE_INTEGER: {
                    auto InitVal = c32(0);
                    Builder.CreateStore(InitVal, Alloca);
                    break;
                }
                case Type_tag::TYPE_CHAR: {
                    auto InitVal = c8(0);
                    Builder.CreateStore(InitVal, Alloca);
                    break;
                }
                case Type_tag::TYPE_ARRAY: {
                    break;
                }
                default: {
                    return nullptr;
                }
            }

            // All of parameters and local variables of the function
            auto CurFunctionVars = FunctionVariables.back();
            // Parameters and local variables of the function that shadow some other variables
            auto CurShadowedVars = ShadowedVariables.back();

            insert(t->id, var_type);

            // If variable already exists, shadow it and keep the old value
            if (NamedValues.count(t->id))
                CurShadowedVars[t->id] = NamedValues[t->id];

            // Store the new variable globally
            NamedValues[t->id] = Alloca;
            //  Store the new variable locally to the function
            CurFunctionVars[t->id] = NamedValues[t->id];

            ast temp = t->first;
            while (temp != nullptr) {
                insert(temp->id, var_type);
                // If variable already exists, shadow it and keep the old value
                if (NamedValues.count(temp->id))
                    CurShadowedVars[temp->id] = NamedValues[temp->id];

                Alloca = CreateEntryBlockAlloca(TheFunction, std::string(temp->id), llvm_var_type);

                // Store the new variable globally
                NamedValues[temp->id] = Alloca;
                //  Store the new variable locally to the function
                CurFunctionVars[temp->id] = NamedValues[temp->id];

                temp = temp->first;
            }

            ShadowedVariables.push_back(CurShadowedVars);
            FunctionVariables.push_back(CurFunctionVars);

            return nullptr;
        }
        case PROC_CALL:
        {
            SymbolEntry* proc = lookup(t->id);
            if (proc->u.eFunction.resultType != typeVoid)
                fatal("Cannot call function as a procedure\n");

            // TODO: check if necessary
            ast_sem(t->first);
            ast_sem(t->second);
            check_parameters(proc, t->first, t->second, "proc");

            // Look up the name in the global module table.
            llvm::Function* CalleeF = TheModule->getFunction(t->id);
            if (!CalleeF)
                return LogErrorV("Unknown procedure referenced");

            std::vector<llvm::Value*> ArgsV;

            ast param = t->first;         // First is expr
            ast param_list = t->second;

            SymbolEntry* func_param = proc->u.eFunction.firstArgument;
            bool passByReference;

            while (param != nullptr) {

                passByReference = func_param->u.eParameter.mode == PASS_BY_REFERENCE ||
                                  func_param->u.eParameter.type->kind == Type_tag::TYPE_ARRAY;

                if (passByReference)
                    ArgsV.push_back(NamedValues[param->first->id]);
                else if (func_param->u.eParameter.type->kind == Type_tag::TYPE_IARRAY && param->first->k != STR) {

                    llvm::Value* Pointer;
                    std::vector<llvm::Value*> indexList{ c32(0), c32(0) };
                    llvm::Value* Id = NamedValues[param->first->id];
                    llvm::Type* PointeeType = Id->getType()->getPointerElementType();

                    Pointer = llvm::GetElementPtrInst::Create(PointeeType, Id, llvm::ArrayRef<llvm::Value*>(indexList), "lvalue_ptr", Builder.GetInsertBlock());
                    ArgsV.push_back(Pointer);
                }
                else
                    ArgsV.push_back(ast_compile(param));

                if (!param_list)
                    break;

                param = param_list->first;        // Now for the rest of paramams.
                param_list = param_list->second;

                func_param = func_param->u.eParameter.next;
            }

            Builder.CreateCall(CalleeF, ArgsV, "");

            return nullptr;
        }
        case FUNC_CALL:
        {
            SymbolEntry* func = lookup(t->id);
            if (func->u.eFunction.resultType == typeVoid)
                fatal("Function must have a return type\n");
            ast_sem(t->first);
            ast_sem(t->second);
            check_parameters(func, t->first, t->second, "func");
            t->type = func->u.eFunction.resultType;

            // Look up the name in the global module table.
            llvm::Function* CalleeF = TheModule->getFunction(t->id);
            if (!CalleeF)
                return LogErrorV("Unknown function referenced");

            std::vector<llvm::Value*> ArgsV;

            ast param = t->first;         // First is expr
            ast param_list = t->second;

            SymbolEntry* func_param = func->u.eFunction.firstArgument;
            bool passByReference;

            while (param != nullptr) {

                passByReference = func_param->u.eParameter.mode == PASS_BY_REFERENCE ||
                                  func_param->u.eParameter.type->kind == Type_tag::TYPE_ARRAY;

                if (passByReference)
                    ArgsV.push_back(NamedValues[param->first->id]);
                else if (func_param->u.eParameter.type->kind == Type_tag::TYPE_IARRAY && param->first->k != STR) {

                    llvm::Value* Pointer;
                    std::vector<llvm::Value*> indexList{ c32(0), c32(0) };
                    llvm::Value* Id = NamedValues[param->first->id];
                    llvm::Type* PointeeType = Id->getType()->getPointerElementType();

                    Pointer = llvm::GetElementPtrInst::Create(PointeeType, Id, llvm::ArrayRef<llvm::Value*>(indexList), "lvalue_ptr", Builder.GetInsertBlock());
                    ArgsV.push_back(Pointer);
                }
                else
                    ArgsV.push_back(ast_compile(param));

                if (!param_list)
                    break;

                param = param_list->first;        // Now for the rest of paramams.
                param_list = param_list->second;

                func_param = func_param->u.eParameter.next;
            }

            return Builder.CreateCall(CalleeF, ArgsV, "fcalltmp");
        }
        case ID:
        {
            SymbolEntry* e = lookup(t->id);

//            if (e == nullptr)
//                error("ID - Undeclared variable : %s", t->id);

            t->type = e->u.eVariable.type;
//            t->nesting_diff = currentScope->nestingLevel - e->nestingLevel;
//            t->offset = e->u.eVariable.offset;

            // Look this variable up in the function.
            llvm::Value* Id = NamedValues[std::string(t->id)];
            if (!Id)
                return LogErrorV("Unknown variable name");

            return Id;
        }
        case STR:
        {
            std::string s(t->id);
            std::vector<unsigned int> StringVector;
            for (char c : s)
                StringVector.push_back(c);
            StringVector.push_back(0);

            return Builder.CreateGlobalStringPtr(s, "str");
        }
        case L_VALUE:
        {
            ast p = l_value_type(t, 0);
            t->type = p->type;
            free(p);

            std::vector<llvm::Value*> indexList;
            ast ast_iter = t;
            while (ast_iter->first != nullptr) {
                indexList.push_back(ast_compile(ast_iter->second));
                ast_iter = ast_iter->first;
            }
            indexList.push_back(c32(0));
            std::reverse(indexList.begin(), indexList.end());

            llvm::Value* Id = ast_compile(ast_iter);
            llvm::Type* PointeeType = Id->getType()->getPointerElementType();

            llvm::Value* Pointer = llvm::GetElementPtrInst::Create(PointeeType, Id, llvm::ArrayRef<llvm::Value*>(indexList), "lvalue_ptr", Builder.GetInsertBlock());
            return Pointer;
        };
        case R_VALUE:
        {
            llvm::Value* RValuePointer = ast_compile(t->first);
            t->type = t->first->type;

            if (t->first->k == STR)     // String as rvalue does not need to create a load. Just return the pointer
                return RValuePointer;
            else
                return Builder.CreateLoad(RValuePointer, "rvalue");
        }
    }
}

void llvm_compile_and_dump(ast t)
{
//    ast_sem(t);

    TheModule = llvm::make_unique<llvm::Module>("dana program", TheContext);

    declare_dana_libs();

    ast_compile(t);

    // Verify and optimize the main function.
    bool bad = verifyModule(*TheModule, &llvm::errs());
    if (bad) {
        fprintf(stderr, "The faulty IR is:\n");
        fprintf(stderr, "------------------------------------------------\n\n");
        TheModule->print(llvm::outs(), nullptr);
        return;
    }

    TheModule->print(llvm::errs(), nullptr);
}

llvm::Type* to_llvm_type(Type type) {
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
//            return llvm::ArrayType::get(to_llvm_type(type->refType), 1);
        default:
            return nullptr;
    }
}

static llvm::Function* TheWriteInteger;
static llvm::Function* TheWriteString;

void declare_dana_libs()
{
    // declare void @writeInteger(i32)
    llvm::FunctionType *writeInteger_type =
            llvm::FunctionType::get(llvm::Type::getVoidTy(TheContext),
                              std::vector<llvm::Type*>{ llvm_int }, false);
    TheWriteInteger =
            llvm::Function::Create(writeInteger_type, llvm::Function::ExternalLinkage,
                             "writeInteger", TheModule.get());

    // declare void @writeString(i8*)
    llvm::FunctionType *writeString_type =
            llvm::FunctionType::get(llvm::Type::getVoidTy(TheContext),
                              std::vector<llvm::Type *>{ llvm::PointerType::get(llvm_byte, 0) }, false);
    TheWriteString =
            llvm::Function::Create(writeString_type, llvm::Function::ExternalLinkage,
                             "writeString", TheModule.get());
}

