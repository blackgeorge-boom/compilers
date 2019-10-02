; ModuleID = 'dana program'
source_filename = "dana program"

declare void @writeInteger(i32)

declare void @writeString(i8*)

define void @main() {
entry:
  %y = alloca [10 x i32]
  %lvalue_ptr = getelementptr [10 x i32], [10 x i32]* %y, i32 0, i32 0
  store i32 2, i32* %lvalue_ptr
  %lvalue_ptr1 = getelementptr [10 x i32], [10 x i32]* %y, i32 0, i32 0
  %rvalue = load i32, i32* %lvalue_ptr1
  call void @writeInteger(i32 %rvalue)
  call void @hello([10 x i32]* %y)
  %lvalue_ptr2 = getelementptr [10 x i32], [10 x i32]* %y, i32 0, i32 0
  %rvalue3 = load i32, i32* %lvalue_ptr2
  call void @writeInteger(i32 %rvalue3)
  ret void
}

declare void @writeInteger.1(i32)

define void @hello([10 x i32]* %x) {
entry:
  %lvalue_ptr = getelementptr [10 x i32], [10 x i32]* %x, i32 0, i32 0
  store i32 1, i32* %lvalue_ptr
  ret void
}
