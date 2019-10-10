; ModuleID = 'dana program'
source_filename = "dana program"

@str = private unnamed_addr constant [8 x i8] c"makaris\00"

declare void @writeInteger(i32)

declare void @writeString(i8*)

define void @main() {
entry:
  %y = alloca [10 x [20 x i32]]
  %lvalue_ptr = getelementptr [10 x [20 x i32]], [10 x [20 x i32]]* %y, i32 0, i32 1, i32 10
  store i32 2, i32* %lvalue_ptr
  %lvalue_ptr1 = getelementptr [10 x [20 x i32]], [10 x [20 x i32]]* %y, i32 0, i32 1, i32 10
  %rvalue = load i32, i32* %lvalue_ptr1
  call void @writeInteger(i32 %rvalue)
  %lvalue_ptr2 = getelementptr [10 x [20 x i32]], [10 x [20 x i32]]* %y, i32 0, i32 0
  call void @hello([20 x i32]* %lvalue_ptr2)
  %lvalue_ptr3 = getelementptr [8 x i8], [8 x i8]* @str, i32 0, i32 2
  %rvalue4 = load i8, i8* %lvalue_ptr3
  call void @writeChar(i8 %rvalue4)
  ret void
}

declare void @writeInteger.1(i32)

declare void @writeChar(i8)

declare void @writeString.2(i8*)

define void @hello([20 x i32]* %x) {
entry:
  %cast = bitcast [20 x i32]* %x to [1 x [20 x i32]]*
  %lvalue_ptr = getelementptr [1 x [20 x i32]], [1 x [20 x i32]]* %cast, i32 0, i32 1, i32 10
  store i32 1, i32* %lvalue_ptr
  ret void
}
