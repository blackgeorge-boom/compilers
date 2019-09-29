; ModuleID = 'dana program'
source_filename = "dana program"

@str = private unnamed_addr constant [6 x i8] c"abc\5Cn\00"

declare void @writeInteger(i32)

declare void @writeString(i8*)

define void @main() {
entry:
  call void @hello(i32 2)
  call void @hello(i32 -1)
  call void @hello(i32 1)
  ret void
}

declare void @writeInteger.1(i32)

declare void @writeChar(i8)

declare void @writeString.2([8 x i8])

define void @hello(i32 %x) {
entry:
  %x1 = alloca i32
  store i32 %x, i32* %x1
  %rvalue = load i32, i32* %x1
  call void @writeInteger(i32 %rvalue)
  %rvalue2 = load i32, i32* %x1
  %eq = icmp eq i32 %rvalue2, -1
  %0 = sext i1 %eq to i32
  %ifcond = icmp ne i32 %0, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %entry
  %lvalue_ptr = getelementptr [6 x i8], [6 x i8]* @str, i32 0, i32 3
  %rvalue3 = load i8, i8* %lvalue_ptr
  call void @writeChar(i8 %rvalue3)
  br label %ifcont

elif:                                             ; preds = %entry
  br label %else

else:                                             ; preds = %elif
  call void @writeChar(i8 99)
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  ret void
}
