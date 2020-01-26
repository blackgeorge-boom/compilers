; ModuleID = 'bubble_ir.ll'
source_filename = "dana program"

%main_type = type { i32, i32, [16 x i32] }
%bsort_type = type { %main_type*, i32, [1 x i32]*, i8, i32 }
%swap_type = type { %bsort_type*, i32*, i32*, i32 }
%writeArray_type = type { %main_type*, [1 x i8]*, i32, [1 x i32]*, i32 }

@str = private unnamed_addr constant [3 x i8] c", \00"
@str.15 = private unnamed_addr constant [2 x i8] c"\0A\00"
@str.16 = private unnamed_addr constant [16 x i8] c"Initial array: \00"
@str.17 = private unnamed_addr constant [15 x i8] c"Sorted array: \00"

define void @main() {
entry:
  %main_frame = alloca %main_type
  %0 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  store i32 65, i32* %0
  %1 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  store i32 0, i32* %1
  br label %loop

loop:                                             ; preds = %ifcont, %entry
  %2 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue = load i32, i32* %2
  %lt = icmp slt i32 %rvalue, 16
  %3 = sext i1 %lt to i32
  %ifcond = icmp ne i32 %3, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  %4 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %5 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %rvalue1 = load i32, i32* %5
  %multmp = mul i32 %rvalue1, 137
  %addtmp = add i32 %multmp, 220
  %6 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue2 = load i32, i32* %6
  %addtmp3 = add i32 %addtmp, %rvalue2
  %modtmp = srem i32 %addtmp3, 101
  store i32 %modtmp, i32* %4
  %7 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue4 = load i32, i32* %7
  %8 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %lvalue_ptr = getelementptr [16 x i32], [16 x i32]* %8, i32 0, i32 %rvalue4
  %9 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %rvalue5 = load i32, i32* %9
  store i32 %rvalue5, i32* %lvalue_ptr
  %10 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %11 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue6 = load i32, i32* %11
  %addtmp7 = add i32 %rvalue6, 1
  store i32 %addtmp7, i32* %10
  br label %ifcont

elif:                                             ; preds = %loop
  br label %else

else:                                             ; preds = %elif
  br label %afterloop

ifcont:                                           ; preds = %then
  br label %loop

afterloop:                                        ; preds = %else
  %str_ptr = getelementptr [16 x i8], [16 x i8]* @str.16, i32 0, i32 0
  %12 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %lvalue_ptr8 = getelementptr [16 x i32], [16 x i32]* %12, i32 0, i32 0
  call void @writeArray(%main_type* %main_frame, i8* %str_ptr, i32 16, i32* %lvalue_ptr8)
  %13 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %lvalue_ptr9 = getelementptr [16 x i32], [16 x i32]* %13, i32 0, i32 0
  call void @bsort(%main_type* %main_frame, i32 16, i32* %lvalue_ptr9)
  %str_ptr10 = getelementptr [15 x i8], [15 x i8]* @str.17, i32 0, i32 0
  %14 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %lvalue_ptr11 = getelementptr [16 x i32], [16 x i32]* %14, i32 0, i32 0
  call void @writeArray(%main_type* %main_frame, i8* %str_ptr10, i32 16, i32* %lvalue_ptr11)
  ret void
}

declare void @writeInteger(i32)

declare void @writeByte(i8)

declare void @writeChar(i8)

declare void @writeString(i8*)

declare i32 @readInteger()

declare i8 @readByte()

declare i8 @readChar()

declare void @readString(i32, i8*)

declare i32 @extend(i8)

declare i8 @shrink(i32)

declare i32 @strlen(i8*)

declare i32 @strcmp(i8*, i8*)

declare void @strcpy(i8*, i8*)

declare void @strcat(i8*, i8*)

declare void @writeInteger.1(%main_type*, i32)

declare void @writeByte.2(%main_type*, i8)

declare void @writeChar.3(%main_type*, i8)

declare void @writeString.4(%main_type*, i8*)

declare i32 @readInteger.5(%main_type*)

declare i8 @readByte.6(%main_type*)

declare i8 @readChar.7(%main_type*)

declare void @readString.8(%main_type*, i32, i8*)

declare i32 @extend.9(%main_type*, i8)

declare i8 @shrink.10(%main_type*, i32)

declare i32 @strlen.11(%main_type*, i8*)

declare i32 @strcmp.12(%main_type*, i8*, i8*)

declare void @strcpy.13(%main_type*, i8*, i8*)

declare void @strcat.14(%main_type*, i8*, i8*)

define void @bsort(%main_type* %main_frame, i32 %n, i32* %x) {
entry:
  %bsort_frame = alloca %bsort_type
  %0 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %n_pos = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 1
  store i32 %n, i32* %n_pos
  %x_pos = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 2
  %cast = bitcast i32* %x to [1 x i32]*
  store [1 x i32]* %cast, [1 x i32]** %x_pos
  br label %loop

loop:                                             ; preds = %ifcont26, %entry
  %1 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 3
  store i8 0, i8* %1
  %2 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 4
  store i32 0, i32* %2
  br label %loop1

loop1:                                            ; preds = %ifcont21, %loop
  %3 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 4
  %rvalue = load i32, i32* %3
  %4 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 1
  %rvalue2 = load i32, i32* %4
  %subtmp = sub i32 %rvalue2, 1
  %lt = icmp slt i32 %rvalue, %subtmp
  %5 = sext i1 %lt to i32
  %ifcond = icmp ne i32 %5, 0
  br i1 %ifcond, label %then, label %elif20

then:                                             ; preds = %loop1
  %6 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 4
  %rvalue3 = load i32, i32* %6
  %7 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 2
  %temp = load [1 x i32]*, [1 x i32]** %7
  %lvalue_ptr = getelementptr [1 x i32], [1 x i32]* %temp, i32 0, i32 %rvalue3
  %rvalue4 = load i32, i32* %lvalue_ptr
  %8 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 4
  %rvalue5 = load i32, i32* %8
  %addtmp = add i32 %rvalue5, 1
  %9 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 2
  %temp6 = load [1 x i32]*, [1 x i32]** %9
  %lvalue_ptr7 = getelementptr [1 x i32], [1 x i32]* %temp6, i32 0, i32 %addtmp
  %rvalue8 = load i32, i32* %lvalue_ptr7
  %gt = icmp sgt i32 %rvalue4, %rvalue8
  %10 = sext i1 %gt to i32
  %ifcond9 = icmp ne i32 %10, 0
  br i1 %ifcond9, label %then10, label %elif

then10:                                           ; preds = %then
  %11 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 4
  %rvalue11 = load i32, i32* %11
  %12 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 2
  %temp12 = load [1 x i32]*, [1 x i32]** %12
  %lvalue_ptr13 = getelementptr [1 x i32], [1 x i32]* %temp12, i32 0, i32 %rvalue11
  %13 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 4
  %rvalue14 = load i32, i32* %13
  %addtmp15 = add i32 %rvalue14, 1
  %14 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 2
  %temp16 = load [1 x i32]*, [1 x i32]** %14
  %lvalue_ptr17 = getelementptr [1 x i32], [1 x i32]* %temp16, i32 0, i32 %addtmp15
  call void @swap(%bsort_type* %bsort_frame, i32* %lvalue_ptr13, i32* %lvalue_ptr17)
  %15 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 3
  store i8 1, i8* %15
  br label %ifcont

elif:                                             ; preds = %then
  br label %ifcont

ifcont:                                           ; preds = %elif, %then10
  %16 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 4
  %17 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 4
  %rvalue18 = load i32, i32* %17
  %addtmp19 = add i32 %rvalue18, 1
  store i32 %addtmp19, i32* %16
  br label %ifcont21

elif20:                                           ; preds = %loop1
  br label %else

else:                                             ; preds = %elif20
  br label %afterloop

ifcont21:                                         ; preds = %ifcont
  br label %loop1

afterloop:                                        ; preds = %else
  %18 = getelementptr inbounds %bsort_type, %bsort_type* %bsort_frame, i32 0, i32 3
  %rvalue22 = load i8, i8* %18
  %19 = sext i8 %rvalue22 to i32
  %inttobit = icmp ne i32 %19, 0
  %boolnot = xor i1 %inttobit, true
  %20 = sext i1 %boolnot to i32
  %ifcond23 = icmp ne i32 %20, 0
  br i1 %ifcond23, label %then24, label %elif25

then24:                                           ; preds = %afterloop
  br label %afterloop27

elif25:                                           ; preds = %afterloop
  br label %ifcont26

ifcont26:                                         ; preds = %elif25
  br label %loop

afterloop27:                                      ; preds = %then24
  ret void
}

define void @swap(%bsort_type* %bsort_frame, i32* %x, i32* %y) {
entry:
  %swap_frame = alloca %swap_type
  %0 = getelementptr inbounds %swap_type, %swap_type* %swap_frame, i32 0, i32 0
  store %bsort_type* %bsort_frame, %bsort_type** %0
  %x_pos = getelementptr inbounds %swap_type, %swap_type* %swap_frame, i32 0, i32 1
  store i32* %x, i32** %x_pos
  %y_pos = getelementptr inbounds %swap_type, %swap_type* %swap_frame, i32 0, i32 2
  store i32* %y, i32** %y_pos
  %1 = getelementptr inbounds %swap_type, %swap_type* %swap_frame, i32 0, i32 3
  %2 = getelementptr inbounds %swap_type, %swap_type* %swap_frame, i32 0, i32 1
  %temp = load i32*, i32** %2
  %rvalue = load i32, i32* %temp
  store i32 %rvalue, i32* %1
  %3 = getelementptr inbounds %swap_type, %swap_type* %swap_frame, i32 0, i32 1
  %temp1 = load i32*, i32** %3
  %4 = getelementptr inbounds %swap_type, %swap_type* %swap_frame, i32 0, i32 2
  %temp2 = load i32*, i32** %4
  %rvalue3 = load i32, i32* %temp2
  store i32 %rvalue3, i32* %temp1
  %5 = getelementptr inbounds %swap_type, %swap_type* %swap_frame, i32 0, i32 2
  %temp4 = load i32*, i32** %5
  %6 = getelementptr inbounds %swap_type, %swap_type* %swap_frame, i32 0, i32 3
  %rvalue5 = load i32, i32* %6
  store i32 %rvalue5, i32* %temp4
  ret void
}

define void @writeArray(%main_type* %main_frame, i8* %msg, i32 %n, i32* %x) {
entry:
  %writeArray_frame = alloca %writeArray_type
  %0 = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %msg_pos = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 1
  %cast = bitcast i8* %msg to [1 x i8]*
  store [1 x i8]* %cast, [1 x i8]** %msg_pos
  %n_pos = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 2
  store i32 %n, i32* %n_pos
  %x_pos = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 3
  %cast1 = bitcast i32* %x to [1 x i32]*
  store [1 x i32]* %cast1, [1 x i32]** %x_pos
  %1 = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 1
  %temp = load [1 x i8]*, [1 x i8]** %1
  %lvalue_ptr = getelementptr [1 x i8], [1 x i8]* %temp, i32 0, i32 0
  call void @writeString(i8* %lvalue_ptr)
  %2 = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 4
  store i32 0, i32* %2
  br label %loop

loop:                                             ; preds = %ifcont12, %entry
  %3 = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 4
  %rvalue = load i32, i32* %3
  %4 = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 2
  %rvalue2 = load i32, i32* %4
  %lt = icmp slt i32 %rvalue, %rvalue2
  %5 = sext i1 %lt to i32
  %ifcond = icmp ne i32 %5, 0
  br i1 %ifcond, label %then, label %elif11

then:                                             ; preds = %loop
  %6 = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 4
  %rvalue3 = load i32, i32* %6
  %gt = icmp sgt i32 %rvalue3, 0
  %7 = sext i1 %gt to i32
  %ifcond4 = icmp ne i32 %7, 0
  br i1 %ifcond4, label %then5, label %elif

then5:                                            ; preds = %then
  %str_ptr = getelementptr [3 x i8], [3 x i8]* @str, i32 0, i32 0
  call void @writeString(i8* %str_ptr)
  br label %ifcont

elif:                                             ; preds = %then
  br label %ifcont

ifcont:                                           ; preds = %elif, %then5
  %8 = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 4
  %rvalue6 = load i32, i32* %8
  %9 = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 3
  %temp7 = load [1 x i32]*, [1 x i32]** %9
  %lvalue_ptr8 = getelementptr [1 x i32], [1 x i32]* %temp7, i32 0, i32 %rvalue6
  %rvalue9 = load i32, i32* %lvalue_ptr8
  call void @writeInteger(i32 %rvalue9)
  %10 = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 4
  %11 = getelementptr inbounds %writeArray_type, %writeArray_type* %writeArray_frame, i32 0, i32 4
  %rvalue10 = load i32, i32* %11
  %addtmp = add i32 %rvalue10, 1
  store i32 %addtmp, i32* %10
  br label %ifcont12

elif11:                                           ; preds = %loop
  br label %else

else:                                             ; preds = %elif11
  br label %afterloop

ifcont12:                                         ; preds = %ifcont
  br label %loop

afterloop:                                        ; preds = %else
  %str_ptr13 = getelementptr [2 x i8], [2 x i8]* @str.15, i32 0, i32 0
  call void @writeString(i8* %str_ptr13)
  ret void
}
