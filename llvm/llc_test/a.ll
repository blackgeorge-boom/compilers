; ModuleID = 'dana program'
source_filename = "dana program"

declare void @writeInteger(i32)

declare void @writeString(i8*)

define void @main() {
entry:
  %y = alloca i32
  %a = alloca [10 x i32]
  store i32 0, i32* %y
  %lvalue_ptr = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 0
  store i32 666, i32* %lvalue_ptr
  %lvalue_ptr1 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 1
  store i32 4, i32* %lvalue_ptr1
  %rvalue = load [10 x i32], [10 x i32]* %a
  call void @hello([10 x i32] %rvalue)
  %lvalue_ptr2 = getelementptr [10 x i32], [10 x i32]* %a, i32 0, i32 1
  %rvalue3 = load i32, i32* %lvalue_ptr2
  call void @writeInteger(i32 %rvalue3)
  ret void
}

declare void @writeInteger.1(i32)

define void @hello([10 x i32] %x) {
entry:
  %x1 = alloca [10 x i32]
  store [10 x i32] %x, [10 x i32]* %x1
  %lvalue_ptr = getelementptr [10 x i32], [10 x i32]* %x1, i32 0, i32 1
  store i32 1, i32* %lvalue_ptr
  %lvalue_ptr2 = getelementptr [10 x i32], [10 x i32]* %x1, i32 0, i32 0
  %rvalue = load i32, i32* %lvalue_ptr2
  call void @writeInteger(i32 %rvalue)
  ret void
}
