; ModuleID = 'dana program'
source_filename = "dana program"

%main_type = type { [10 x i32], i32 }
%loc_type = type { %main_type*, [1 x i32]*, i32* }

@str = private unnamed_addr constant [16 x i8] c"yoooooooooooooo\00"

declare void @writeInteger(i32)

declare void @writeString(i8*)

define void @main() {
entry:
  %main_frame = alloca %main_type
  %0 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %lvalue_ptr = getelementptr [10 x i32], [10 x i32]* %0, i32 0, i32 1
  store i32 0, i32* %lvalue_ptr
  %1 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  store i32 1, i32* %1
  %2 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %lvalue_ptr1 = getelementptr [10 x i32], [10 x i32]* %2, i32 0, i32 1
  %rvalue = load i32, i32* %lvalue_ptr1
  call void @writeInteger(i32 %rvalue)
  %3 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue2 = load i32, i32* %3
  call void @writeInteger(i32 %rvalue2)
  %4 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %lvalue_ptr3 = getelementptr [10 x i32], [10 x i32]* %4, i32 0, i32 0
  %5 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  call void @loc(%main_type* %main_frame, i32* %lvalue_ptr3, i32* %5)
  %6 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %lvalue_ptr4 = getelementptr [10 x i32], [10 x i32]* %6, i32 0, i32 1
  %rvalue5 = load i32, i32* %lvalue_ptr4
  call void @writeInteger(i32 %rvalue5)
  %7 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue6 = load i32, i32* %7
  call void @writeInteger(i32 %rvalue6)
  call void @writeString(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str, i32 0, i32 0))
  ret void
}

declare void @writeInteger.1(%main_type*, i32)

declare void @writeString.2(%main_type*, i8*)

define void @loc(%main_type* %main_frame, i32* %a, i32* %b) {
entry:
  %loc_frame = alloca %loc_type
  %0 = getelementptr inbounds %loc_type, %loc_type* %loc_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %a_pos = getelementptr inbounds %loc_type, %loc_type* %loc_frame, i32 0, i32 1
  %cast = bitcast i32* %a to [1 x i32]*
  store [1 x i32]* %cast, [1 x i32]** %a_pos
  %b_pos = getelementptr inbounds %loc_type, %loc_type* %loc_frame, i32 0, i32 2
  store i32* %b, i32** %b_pos
  %1 = getelementptr inbounds %loc_type, %loc_type* %loc_frame, i32 0, i32 2
  %temp = load i32*, i32** %1
  store i32 3, i32* %temp
  %2 = getelementptr inbounds %loc_type, %loc_type* %loc_frame, i32 0, i32 1
  %temp1 = load [1 x i32]*, [1 x i32]** %2
  %lvalue_ptr = getelementptr [1 x i32], [1 x i32]* %temp1, i32 0, i32 1
  store i32 5, i32* %lvalue_ptr
  ret void
}
