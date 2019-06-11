//
// Created by blackgeorge on 4/17/19.
//

#ifndef LLVM_EXAMPLE_LOGGER_H
#define LLVM_EXAMPLE_LOGGER_H

#include "ast.h"

/// LogError* - These are little helper functions for error handling.
//std::unique_ptr<ExprAST> LogError(const char *Str);
//std::unique_ptr<PrototypeAST> LogErrorP(const char *Str);
llvm::Value* LogErrorV(const char *Str);

#endif //LLVM_EXAMPLE_LOGGER_H
