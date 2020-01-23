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
enum {
    FUNC_DECLARATION,
    FUNC_DEFINITION
} func_mode;
std::vector<char*> func_names;
char* curr_func_name;
std::vector<llvm::BasicBlock*> merge_blocks;

static ast ast_make(kind k, char* s, int n,
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
static std::unique_ptr<llvm::legacy::FunctionPassManager> TheFPM;
static std::vector<llvm::StructType*> StackFrameTypes;
static std::vector<llvm::AllocaInst*> StackFrames;

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

            llvm::Value* V = ast_compile(t->first);
            closeScope();
            return V;
        }
        case FUNC_DECL:
        {
            func_mode = FUNC_DECLARATION;

            llvm::Function* V = static_cast<llvm::Function*>(ast_compile(t->first));
            closeScope();

            return nullptr;
        }
        case FUNC_DEF:
        {
            func_mode = FUNC_DEFINITION;

            curr_func_name = t->first->id;
            func_names.push_back(curr_func_name);

            llvm::Function* TheFunction = TheModule->getFunction(curr_func_name);

            if (!TheFunction)
                TheFunction = static_cast<llvm::Function*>(ast_compile(t->first));
            else
                ast_compile(t->first);

            if (!TheFunction)
                return nullptr;

            if (!TheFunction->empty())
                return (llvm::Function*)LogErrorV("Function cannot be redefined.") ;

            if (StackFrames.empty())
                currentScope->negOffset = 0;

            llvm::BasicBlock* OldBB = Builder.GetInsertBlock();

            // Create a new basic block to start insertion into.
            llvm::BasicBlock* BB = llvm::BasicBlock::Create(TheContext, "entry", TheFunction);
            Builder.SetInsertPoint(BB);

            std::vector<llvm::Type*> members;

            for (auto& Arg : TheFunction->args()) {

                if (static_cast<llvm::PointerType*>(Arg.getType()) == StackFrameTypes.back()->getPointerTo(0)) {
                    members.push_back(Arg.getType());
                    continue;
                }

                std::string ArgName(Arg.getName());
                char var_id[ArgName.size() + 1];
                strcpy(var_id, ArgName.c_str()); // ArgName is const
                SymbolEntry* se = lookup(var_id);

                if (se->u.eParameter.type->kind == Type_tag::TYPE_IARRAY) {
                    auto PointeeType = to_llvm_type(se->u.eParameter.type->refType);
//                    auto Tmp = new llvm::BitCastInst(&Arg, llvm::PointerType::get(llvm::ArrayType::get(PointeeType, 1),0), "cast", BB);
                    members.push_back(llvm::PointerType::get(llvm::ArrayType::get(PointeeType, 1), 0));
                    continue;
                }

                members.push_back(Arg.getType());
            }

            std::vector<llvm::Type*> local_vars = var_members(t->second);
            members.insert(members.end(), local_vars.begin(), local_vars.end());

            // Create type for the current stack frame
            llvm::StructType* CurStackFrameType =
                    llvm::StructType::create(TheContext,
                                              llvm::ArrayRef<llvm::Type*>(members),
                                              std::string(curr_func_name) + "_type");
            StackFrameTypes.push_back(CurStackFrameType);

            llvm::AllocaInst* CurStackFrame =
                    CreateEntryBlockAlloca(TheFunction,
                                           std::string(curr_func_name) + "_frame",
                                           CurStackFrameType);
            StackFrames.push_back(CurStackFrame);

            llvm::Value* StructPtr;
            for (auto& Arg : TheFunction->args()) {

                auto n = StackFrames.size();

                if (n > 1 && static_cast<llvm::PointerType*>(Arg.getType()) == StackFrameTypes[n - 2]->getPointerTo(0)) {
                    StructPtr = Builder.CreateStructGEP(CurStackFrameType, CurStackFrame, 0, "");
                    Builder.CreateStore(&Arg, StructPtr);
                    continue;
                }

                std::string ArgName(Arg.getName());
                char id[ArgName.size() + 1];
                strcpy(id, ArgName.c_str());
                SymbolEntry* se = lookup(id);

                int offset = se->u.eVariable.offset;
                StructPtr = Builder.CreateStructGEP(CurStackFrameType, CurStackFrame, offset, ArgName + "_pos");

                if (se->u.eParameter.type->kind == Type_tag::TYPE_IARRAY) {
                    auto PointeeType = to_llvm_type(se->u.eParameter.type->refType);
                    auto Tmp = new llvm::BitCastInst(&Arg, llvm::PointerType::get(llvm::ArrayType::get(PointeeType, 1),0), "cast", BB);
                    Builder.CreateStore(Tmp, StructPtr);
                }
                else
                    Builder.CreateStore(&Arg, StructPtr);
            }

            if (strcmp(t->first->id, "main") == 0)
                declare_dana_libs();

            // Local def lists
            ast_compile(t->second);

            Builder.SetInsertPoint(BB);

            // TheBody should normally be nullptr after ast_compile()
            auto TheBody = static_cast<llvm::ConstantInt*>(ast_compile(t->third));

            if (TheBody == nullptr) {
                if (TheFunction->getReturnType() == llvm_void) {
                    // Finish off the proc.
                    Builder.CreateRetVoid();
                }
            }

            // Reset curr func name
            func_names.pop_back();
            curr_func_name = func_names.back();

            // Validate the generated code, checking for consistency.
//            llvm::verifyFunction(*TheFunction); # TODO: Same as verify module?

//            TheFPM->run(*TheFunction);

            StackFrames.pop_back();
            StackFrameTypes.pop_back();

            closeScope();
            if (OldBB)
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

            SymbolEntry* f = newFunction(t->id);
            if (func_mode == FUNC_DECLARATION)
                forwardFunction(f);

            std::vector<llvm::Type*> Params;
            std::vector<std::string> Args;

            if (!StackFrameTypes.empty()) {
                Params.push_back(StackFrameTypes.back()->getPointerTo());
                Args.push_back(StackFrames.back()->getName());
            }

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

            endFunctionHeader(f, func_type);

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
            auto ElifExitStmt = static_cast<llvm::ConstantInt *>(ast_compile(t->second));

            if (!ElifExitStmt)
                Builder.CreateBr(merge_blocks.back());

            // Emit else block.
            TheFunction->getBasicBlockList().push_back(ElifBB); // ??
            Builder.SetInsertPoint(ElifBB);

            // Generate code for "elif list" blocks
            auto ElifListExitStmt = static_cast<llvm::ConstantInt *>(ast_compile(t->third));

            Builder.CreateBr(MergeBB);

            // Emit merge block.
            TheFunction->getBasicBlockList().push_back(MergeBB); // ??
            Builder.SetInsertPoint(MergeBB);

            if (t->third == nullptr)
                return ElifExitStmt;
            else if (ElifExitStmt != nullptr && ElifListExitStmt != nullptr &&
                     ElifExitStmt->getSExtValue() == 0 && ElifListExitStmt->getSExtValue() == 0)
                return c32(0);
            else return nullptr;

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
            auto ThenExitStmt = static_cast<llvm::ConstantInt*>(ast_compile(t->second));

            if (!ThenExitStmt)
                // Create branch to "ifcont"
                Builder.CreateBr(MergeBB);

            // Emit elif block.
            TheFunction->getBasicBlockList().push_back(ElifBB); // ??
            Builder.SetInsertPoint(ElifBB);

            // Generate code for "elif list" blocks
            auto ElifExitStmt = static_cast<llvm::ConstantInt*>(ast_compile(t->third));

            if (t->third == nullptr) ElifExitStmt = c32(0);

            Builder.CreateBr(ElseBB);

            // Emit else block.
            TheFunction->getBasicBlockList().push_back(ElseBB); // ??
            Builder.SetInsertPoint(ElseBB);

            // Generate code for "else" block
            auto ElseExitStmt = static_cast<llvm::ConstantInt*>(ast_compile(t->last));

            if (!ElseExitStmt)
                // Create branch to "ifcont"
                Builder.CreateBr(MergeBB);

           // Emit merge block.
            TheFunction->getBasicBlockList().push_back(MergeBB); // ??
            Builder.SetInsertPoint(MergeBB);

            merge_blocks.pop_back();

            if (ThenExitStmt != nullptr && ElifExitStmt != nullptr && ElseExitStmt != nullptr &&
                ThenExitStmt->getSExtValue() == ElifExitStmt->getSExtValue() == ElseExitStmt->getSExtValue() == 0) {
                Builder.CreateUnreachable();
                return c32(0);
            }

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
            auto ExitStmt = static_cast<llvm::ConstantInt*>(ast_compile(t->first));

            if (!ExitStmt) {
                // Insert the unconditional branch into the end of LoopBB.
                Builder.CreateBr(LoopBB);
            }

            TheFunction->getBasicBlockList().push_back(AfterBB);
            // Any new code will be inserted in AfterBB.
            Builder.SetInsertPoint(AfterBB);

            current_LR = current_LR->previous;
            free(new_LR);

            if (ExitStmt != nullptr && ExitStmt->getSExtValue() == 0) {
                Builder.CreateUnreachable();
                return c32(0);
            }

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
                Builder.CreateBr(lr->after_block);
                return c32(1);
            }
            else if (current_LR == nullptr)
                error("No loop to break");
            else {
                Builder.CreateBr(current_LR->after_block);
                return c32(1);
            }
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
                Builder.CreateBr(lr->loop_block);
                return c32(1);
            }
            else if (current_LR == nullptr)
                error("No loop to continue");
            else {
                Builder.CreateBr(current_LR->loop_block);
                return c32(1);
            }
        }
        case EXIT:
        {
            SymbolEntry* curr_func = lookup(curr_func_name);
            Type curr_func_type = curr_func->u.eFunction.resultType;
            Type return_type = typeVoid;
            check_result_type(curr_func_type, return_type, curr_func_name);

            Builder.CreateRetVoid();

            return c32(0);
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

            Builder.CreateRet(RetV);

            return c32(0);
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
            // Type is computed at var_members
            auto var_type = t->second->type;
            insertVariable(t->id, var_type);

            ast temp = t->first;
            while (temp != nullptr) {
                insertVariable(temp->id, var_type);
                temp = temp->first;
            }
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
            auto n = StackFrames.size();

            // TODO: for all lib functions
            if (strcmp(t->id, "main")!= 0 && strcmp(t->id, "writeInteger") != 0 && strcmp(t->id, "writeString") != 0 && strcmp(t->id, "readString") != 0 && strcmp(t->id, "readChar") != 0 && strcmp(t->id, "writeByte") != 0 && strcmp(t->id, "writeChar") != 0 && strcmp(t->id, "readInteger") != 0 && strcmp(t->id, "strlen") != 0 && strcmp(t->id, "strcmp") != 0) {
                SymbolEntry* se = lookup(t->id);
                if (currentScope->nestingLevel > se->nestingLevel && n > 1) {
                    llvm::Value* CurStackFramePtr = Builder.CreateStructGEP(StackFrameTypes.back(), StackFrames.back(), 0);
                    ArgsV.push_back(Builder.CreateLoad(CurStackFramePtr, ""));
                }
                else
                    ArgsV.push_back(StackFrames.back());

            }

            ast param = t->first;         // First is expr
            ast param_list = t->second;

            SymbolEntry* func_param = proc->u.eFunction.firstArgument;
            bool passByReference;

            while (param != nullptr) {

                passByReference = func_param->u.eParameter.mode == PASS_BY_REFERENCE ||
                                  func_param->u.eParameter.type->kind == Type_tag::TYPE_ARRAY;

                if (passByReference)
                    ArgsV.push_back(ast_compile(param->first));
                else if (func_param->u.eParameter.type->kind == Type_tag::TYPE_IARRAY && param->first->k != STR) {

                    llvm::Value* Pointer;
                    std::vector<llvm::Value*> indexList{ c32(0), c32(0) };
                    llvm::Value* Id = ast_compile(param->first);
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
            auto n = StackFrames.size();

            // TODO: for all lib functions
            if (strcmp(curr_func_name, t->id) == 0 && n > 1) {
                llvm::Value* CurStackFramePtr = Builder.CreateStructGEP(StackFrameTypes.back(), StackFrames.back(), 0);
                ArgsV.push_back(Builder.CreateLoad(CurStackFramePtr, ""));
            }
            else if (strcmp(t->id, "writeInteger") != 0 && strcmp(t->id, "writeString") != 0 && strcmp(t->id, "readString") != 0 && strcmp(t->id, "writeByte") != 0 && strcmp(t->id, "readChar") != 0 && strcmp(t->id, "writeChar") != 0 && strcmp(t->id, "readInteger") != 0 && strcmp(t->id, "strlen") != 0 && strcmp(t->id, "strcmp") != 0)
                ArgsV.push_back(StackFrames.back());

            ast param = t->first;         // First is expr
            ast param_list = t->second;

            SymbolEntry* func_param = func->u.eFunction.firstArgument;
            bool passByReference;

            while (param != nullptr) {

                passByReference = func_param->u.eParameter.mode == PASS_BY_REFERENCE ||
                                  func_param->u.eParameter.type->kind == Type_tag::TYPE_ARRAY;

                if (passByReference)
                    ArgsV.push_back(ast_compile(param->first));
                else if (func_param->u.eParameter.type->kind == Type_tag::TYPE_IARRAY && param->first->k != STR) {

                    llvm::Value* Pointer;
                    std::vector<llvm::Value*> indexList{ c32(0), c32(0) };
                    llvm::Value* Id = ast_compile(param->first);
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
            SymbolEntry* se = lookup(t->id);

            t->type = se->u.eVariable.type;
            // TODO: see if unnecessary
            t->nesting_diff = int(currentScope->nestingLevel) - se->nestingLevel;
            t->offset = se->u.eVariable.offset;

            llvm::Value* CurStackFrame = StackFrames.back();
            llvm::Type* CurStackFrameType = StackFrameTypes.back();

            for (auto i = t->nesting_diff; i > 0; --i) {
                llvm::Value* CurStackFramePtr = Builder.CreateStructGEP(CurStackFrameType, CurStackFrame, 0);
                CurStackFrame = Builder.CreateLoad(CurStackFramePtr, "");
                CurStackFrameType = CurStackFrame->getType()->getPointerElementType();
            }

            llvm::Value* Id = Builder.CreateStructGEP(CurStackFrameType, CurStackFrame, t->offset);

            if (llvm::dyn_cast<llvm::PointerType>(Id->getType()->getPointerElementType()))
                Id = Builder.CreateLoad(Id, "temp");

            return Id;
        }
        case STR:
        {
            std::string s(t->id);
            std::vector<unsigned int> StringVector;
            for (char c : s)
                StringVector.push_back(c);
            StringVector.push_back(0);

            return Builder.CreateGlobalString(s, "str");
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

//            if (ast_iter->k == STR) {
//
//                return Id;
//            }
            llvm::Type* PointeeType = Id->getType()->getPointerElementType();
            llvm::Value* Pointer = llvm::GetElementPtrInst::Create(PointeeType, Id, llvm::ArrayRef<llvm::Value*>(indexList), "lvalue_ptr", Builder.GetInsertBlock());

            return Pointer;
        };
        case R_VALUE:
        {
            llvm::Value* LValue = ast_compile(t->first);
            t->type = t->first->type;

            if (t->first->k == STR)     // String as rvalue does not need to create a load. Just return the pointer
                return llvm::GetElementPtrInst::Create(LValue->getType()->getPointerElementType(), LValue, llvm::ArrayRef<llvm::Value*>(std::vector<llvm::Value*>{c32(0), c32(0)}), "str_ptr", Builder.GetInsertBlock());
            else
                return Builder.CreateLoad(LValue, "rvalue");
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
    TheFPM->add(llvm::createMergedLoadStoreMotionPass()); // TODO: check
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
//    TheFPM->add(llvm::createIndVarSimplifyPass()); // TODO: check

//    TheFPM->add(llvm::createCorrelatedValuePropagationPass());
//    TheFPM->add(llvm::createVerifierPass());
//    TheFPM->add(llvm::createTailCallEliminationPass());
//    TheFPM->add(llvm::createLoopIdiomPass());

//    declare_dana_libs();

    ast_compile(t);

    // Verify and optimize the main function.
    bool bad = verifyModule(*TheModule, &llvm::errs());
    if (bad) {
        fprintf(stderr, "The faulty IR is:\n");
        fprintf(stderr, "------------------------------------------------\n\n");
        TheModule->print(llvm::outs(), nullptr);
        return;
    }

//    TheFPM->run(TheModule);

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
static llvm::Function* TheWriteChar;
static llvm::Function* TheWriteByte;
static llvm::Function* TheWriteString;
static llvm::Function* TheReadString;
static llvm::Function* TheReadInteger;
static llvm::Function* TheReadChar;
static llvm::Function* TheStrlen;
static llvm::Function* TheStrcmp;

void declare_dana_libs()
{
    SymbolEntry* f;
    std::string func_name = "writeInteger";
    char* cstr = &func_name[0];

    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(cstr, typeInteger, f);
    endFunctionHeader(f, typeVoid);
    closeScope();

    // declare void @writeInteger(i32)
    llvm::FunctionType *writeInteger_type =
            llvm::FunctionType::get(llvm_void,
                              std::vector<llvm::Type*>{ llvm_int }, false);
    TheWriteInteger =
            llvm::Function::Create(writeInteger_type, llvm::Function::ExternalLinkage,
                             "writeInteger", TheModule.get());

    func_name = "writeChar";
    cstr = &func_name[0];

    f = newFunction(cstr);
    forwardFunction(f);
    openScope();
    insertParameter(cstr, typeChar, f);
    endFunctionHeader(f, typeVoid);
    closeScope();

    // declare void @writeChar(i8)
    llvm::FunctionType *writeChar_type =
            llvm::FunctionType::get(llvm::Type::getVoidTy(TheContext),
                                    std::vector<llvm::Type*>{ llvm_byte }, false);
    TheWriteChar =
            llvm::Function::Create(writeChar_type, llvm::Function::ExternalLinkage,
                                   "writeChar", TheModule.get());


    // declare void @writeByte(i8)
    llvm::FunctionType *writeByte_type =
            llvm::FunctionType::get(llvm::Type::getVoidTy(TheContext),
                                    std::vector<llvm::Type*>{ llvm_byte }, false);
    TheWriteByte =
            llvm::Function::Create(writeByte_type, llvm::Function::ExternalLinkage,
                                   "writeByte", TheModule.get());

    // declare void @writeString(i8*)
    llvm::FunctionType *writeString_type =
            llvm::FunctionType::get(llvm::Type::getVoidTy(TheContext),
                              std::vector<llvm::Type *>{ llvm::PointerType::get(llvm_byte, 0) }, false);
    TheWriteString =
            llvm::Function::Create(writeString_type, llvm::Function::ExternalLinkage,
                             "writeString", TheModule.get());

    // declare void @readString(i8*)
    llvm::FunctionType *readString_type =
            llvm::FunctionType::get(llvm::Type::getVoidTy(TheContext),
                                    std::vector<llvm::Type *>{ llvm_int, llvm::PointerType::get(llvm_byte, 0) }, false);
    TheReadString =
            llvm::Function::Create(readString_type, llvm::Function::ExternalLinkage,
                                   "readString", TheModule.get());

    // declare void @readInteger(i8*)
    llvm::FunctionType *readInteger_type =
            llvm::FunctionType::get(llvm_int,
                                    std::vector<llvm::Type *>{}, false);
    TheReadInteger =
            llvm::Function::Create(readInteger_type, llvm::Function::ExternalLinkage,
                                   "readInteger", TheModule.get());

    // declare void @readChar(i8*)
    llvm::FunctionType *readChar_type =
            llvm::FunctionType::get(llvm_byte,
                                    std::vector<llvm::Type *>{}, false);
    TheReadChar =
            llvm::Function::Create(readChar_type, llvm::Function::ExternalLinkage,
                                   "readChar", TheModule.get());

    // declare void @strlen(i8*)
    llvm::FunctionType *strlen_type =
            llvm::FunctionType::get(llvm_int,
                                    std::vector<llvm::Type *>{ llvm::PointerType::get(llvm_byte, 0) }, false);
    TheStrlen =
            llvm::Function::Create(strlen_type, llvm::Function::ExternalLinkage,
                                   "strlen", TheModule.get());
    //TODO : fix comment
    // declare void @strlen(i8*)
    llvm::FunctionType *strcmp_type =
            llvm::FunctionType::get(llvm_int,
                                    std::vector<llvm::Type *>{ llvm::PointerType::get(llvm_byte, 0), llvm::PointerType::get(llvm_byte, 0) }, false);
    TheStrcmp =
            llvm::Function::Create(strcmp_type, llvm::Function::ExternalLinkage,
                                   "strcmp", TheModule.get());

}

