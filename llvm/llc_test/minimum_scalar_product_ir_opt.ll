; ModuleID = 'minimum_scalar_product_ir.ll'
source_filename = "dana program"

%main_type = type {}
%work_type = type { %main_type*, [1 x i32]*, [1 x i32]*, i32, i32, i32 }
%ArraySort_type = type { %work_type*, [1 x i32]*, i32, i8, i32 }
%swap_type = type { %ArraySort_type*, i32*, i32*, i32 }
%main2_type = type { %main_type*, i32, i32, i32, i32, i32, [8 x i32], [8 x i32] }

@str = private unnamed_addr constant [7 x i8] c"Case #\00"
@str.1 = private unnamed_addr constant [3 x i8] c": \00"
@str.2 = private unnamed_addr constant [2 x i8] c"\0A\00"

define void @main() {
entry:
  %main_frame = alloca %main_type
  call void @main2(%main_type* %main_frame)
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

define i32 @work(%main_type* %main_frame, i32* %v1, i32* %v2, i32 %n) {
entry:
  %work_frame = alloca %work_type
  %0 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %v1_pos = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 1
  %cast = bitcast i32* %v1 to [1 x i32]*
  store [1 x i32]* %cast, [1 x i32]** %v1_pos
  %v2_pos = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 2
  %cast1 = bitcast i32* %v2 to [1 x i32]*
  store [1 x i32]* %cast1, [1 x i32]** %v2_pos
  %n_pos = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 3
  store i32 %n, i32* %n_pos
  %1 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 1
  %temp = load [1 x i32]*, [1 x i32]** %1
  %lvalue_ptr = getelementptr [1 x i32], [1 x i32]* %temp, i32 0, i32 0
  %2 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 3
  %rvalue = load i32, i32* %2
  call void @ArraySort(%work_type* %work_frame, i32* %lvalue_ptr, i32 %rvalue)
  %3 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 2
  %temp2 = load [1 x i32]*, [1 x i32]** %3
  %lvalue_ptr3 = getelementptr [1 x i32], [1 x i32]* %temp2, i32 0, i32 0
  %4 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 3
  %rvalue4 = load i32, i32* %4
  call void @ArraySort(%work_type* %work_frame, i32* %lvalue_ptr3, i32 %rvalue4)
  %5 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 4
  store i32 0, i32* %5
  %6 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 5
  store i32 0, i32* %6
  br label %loop

loop:                                             ; preds = %ifcont, %entry
  %7 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 5
  %rvalue5 = load i32, i32* %7
  %8 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 3
  %rvalue6 = load i32, i32* %8
  %eq = icmp eq i32 %rvalue5, %rvalue6
  %9 = sext i1 %eq to i32
  %ifcond = icmp ne i32 %9, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  br label %afterloop

elif:                                             ; preds = %loop
  br label %ifcont

ifcont:                                           ; preds = %elif
  %10 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 4
  %11 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 4
  %rvalue7 = load i32, i32* %11
  %12 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 5
  %rvalue8 = load i32, i32* %12
  %13 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 1
  %temp9 = load [1 x i32]*, [1 x i32]** %13
  %lvalue_ptr10 = getelementptr [1 x i32], [1 x i32]* %temp9, i32 0, i32 %rvalue8
  %rvalue11 = load i32, i32* %lvalue_ptr10
  %14 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 3
  %rvalue12 = load i32, i32* %14
  %15 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 5
  %rvalue13 = load i32, i32* %15
  %subtmp = sub i32 %rvalue12, %rvalue13
  %subtmp14 = sub i32 %subtmp, 1
  %16 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 2
  %temp15 = load [1 x i32]*, [1 x i32]** %16
  %lvalue_ptr16 = getelementptr [1 x i32], [1 x i32]* %temp15, i32 0, i32 %subtmp14
  %rvalue17 = load i32, i32* %lvalue_ptr16
  %multmp = mul i32 %rvalue11, %rvalue17
  %addtmp = add i32 %rvalue7, %multmp
  store i32 %addtmp, i32* %10
  %17 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 5
  %18 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 5
  %rvalue18 = load i32, i32* %18
  %addtmp19 = add i32 %rvalue18, 1
  store i32 %addtmp19, i32* %17
  br label %loop

afterloop:                                        ; preds = %then
  %19 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 4
  %rvalue20 = load i32, i32* %19
  ret i32 %rvalue20
}

define void @ArraySort(%work_type* %work_frame, i32* %x, i32 %n) {
entry:
  %ArraySort_frame = alloca %ArraySort_type
  %0 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 0
  store %work_type* %work_frame, %work_type** %0
  %x_pos = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 1
  %cast = bitcast i32* %x to [1 x i32]*
  store [1 x i32]* %cast, [1 x i32]** %x_pos
  %n_pos = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 2
  store i32 %n, i32* %n_pos
  br label %loop

loop:                                             ; preds = %ifcont26, %entry
  %1 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 3
  store i8 0, i8* %1
  %2 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 4
  store i32 0, i32* %2
  br label %loop1

loop1:                                            ; preds = %ifcont21, %loop
  %3 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 4
  %rvalue = load i32, i32* %3
  %4 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 2
  %rvalue2 = load i32, i32* %4
  %subtmp = sub i32 %rvalue2, 1
  %lt = icmp slt i32 %rvalue, %subtmp
  %5 = sext i1 %lt to i32
  %ifcond = icmp ne i32 %5, 0
  br i1 %ifcond, label %then, label %elif20

then:                                             ; preds = %loop1
  %6 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 4
  %rvalue3 = load i32, i32* %6
  %7 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 1
  %temp = load [1 x i32]*, [1 x i32]** %7
  %lvalue_ptr = getelementptr [1 x i32], [1 x i32]* %temp, i32 0, i32 %rvalue3
  %rvalue4 = load i32, i32* %lvalue_ptr
  %8 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 4
  %rvalue5 = load i32, i32* %8
  %addtmp = add i32 %rvalue5, 1
  %9 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 1
  %temp6 = load [1 x i32]*, [1 x i32]** %9
  %lvalue_ptr7 = getelementptr [1 x i32], [1 x i32]* %temp6, i32 0, i32 %addtmp
  %rvalue8 = load i32, i32* %lvalue_ptr7
  %gt = icmp sgt i32 %rvalue4, %rvalue8
  %10 = sext i1 %gt to i32
  %ifcond9 = icmp ne i32 %10, 0
  br i1 %ifcond9, label %then10, label %elif

then10:                                           ; preds = %then
  %11 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 4
  %rvalue11 = load i32, i32* %11
  %12 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 1
  %temp12 = load [1 x i32]*, [1 x i32]** %12
  %lvalue_ptr13 = getelementptr [1 x i32], [1 x i32]* %temp12, i32 0, i32 %rvalue11
  %13 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 4
  %rvalue14 = load i32, i32* %13
  %addtmp15 = add i32 %rvalue14, 1
  %14 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 1
  %temp16 = load [1 x i32]*, [1 x i32]** %14
  %lvalue_ptr17 = getelementptr [1 x i32], [1 x i32]* %temp16, i32 0, i32 %addtmp15
  call void @swap(%ArraySort_type* %ArraySort_frame, i32* %lvalue_ptr13, i32* %lvalue_ptr17)
  %15 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 3
  store i8 1, i8* %15
  br label %ifcont

elif:                                             ; preds = %then
  br label %ifcont

ifcont:                                           ; preds = %elif, %then10
  %16 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 4
  %17 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 4
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
  %18 = getelementptr inbounds %ArraySort_type, %ArraySort_type* %ArraySort_frame, i32 0, i32 3
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

define void @swap(%ArraySort_type* %ArraySort_frame, i32* %x, i32* %y) {
entry:
  %swap_frame = alloca %swap_type
  %0 = getelementptr inbounds %swap_type, %swap_type* %swap_frame, i32 0, i32 0
  store %ArraySort_type* %ArraySort_frame, %ArraySort_type** %0
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

define void @main2(%main_type* %main_frame) {
entry:
  %main2_frame = alloca %main2_type
  %0 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %1 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 1
  %fcalltmp = call i32 @readInteger()
  store i32 %fcalltmp, i32* %1
  %2 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  store i32 0, i32* %2
  br label %loop

loop:                                             ; preds = %afterloop27, %entry
  %3 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  %rvalue = load i32, i32* %3
  %4 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 1
  %rvalue1 = load i32, i32* %4
  %eq = icmp eq i32 %rvalue, %rvalue1
  %5 = sext i1 %eq to i32
  %ifcond = icmp ne i32 %5, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  br label %afterloop39

elif:                                             ; preds = %loop
  br label %ifcont

ifcont:                                           ; preds = %elif
  %6 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 3
  %fcalltmp2 = call i32 @readInteger()
  store i32 %fcalltmp2, i32* %6
  %7 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  store i32 0, i32* %7
  br label %loop3

loop3:                                            ; preds = %ifcont10, %ifcont
  %8 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %rvalue4 = load i32, i32* %8
  %9 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 3
  %rvalue5 = load i32, i32* %9
  %eq6 = icmp eq i32 %rvalue4, %rvalue5
  %10 = sext i1 %eq6 to i32
  %ifcond7 = icmp ne i32 %10, 0
  br i1 %ifcond7, label %then8, label %elif9

then8:                                            ; preds = %loop3
  br label %afterloop

elif9:                                            ; preds = %loop3
  br label %ifcont10

ifcont10:                                         ; preds = %elif9
  %11 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %rvalue11 = load i32, i32* %11
  %12 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 6
  %lvalue_ptr = getelementptr [8 x i32], [8 x i32]* %12, i32 0, i32 %rvalue11
  %fcalltmp12 = call i32 @readInteger()
  store i32 %fcalltmp12, i32* %lvalue_ptr
  %13 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %14 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %rvalue13 = load i32, i32* %14
  %addtmp = add i32 %rvalue13, 1
  store i32 %addtmp, i32* %13
  br label %loop3

afterloop:                                        ; preds = %then8
  %15 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  store i32 0, i32* %15
  br label %loop14

loop14:                                           ; preds = %ifcont21, %afterloop
  %16 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %rvalue15 = load i32, i32* %16
  %17 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 3
  %rvalue16 = load i32, i32* %17
  %eq17 = icmp eq i32 %rvalue15, %rvalue16
  %18 = sext i1 %eq17 to i32
  %ifcond18 = icmp ne i32 %18, 0
  br i1 %ifcond18, label %then19, label %elif20

then19:                                           ; preds = %loop14
  br label %afterloop27

elif20:                                           ; preds = %loop14
  br label %ifcont21

ifcont21:                                         ; preds = %elif20
  %19 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %rvalue22 = load i32, i32* %19
  %20 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 7
  %lvalue_ptr23 = getelementptr [8 x i32], [8 x i32]* %20, i32 0, i32 %rvalue22
  %fcalltmp24 = call i32 @readInteger()
  store i32 %fcalltmp24, i32* %lvalue_ptr23
  %21 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %22 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %rvalue25 = load i32, i32* %22
  %addtmp26 = add i32 %rvalue25, 1
  store i32 %addtmp26, i32* %21
  br label %loop14

afterloop27:                                      ; preds = %then19
  %23 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 5
  %24 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 0
  %25 = load %main_type*, %main_type** %24
  %26 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 6
  %lvalue_ptr28 = getelementptr [8 x i32], [8 x i32]* %26, i32 0, i32 0
  %27 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 7
  %lvalue_ptr29 = getelementptr [8 x i32], [8 x i32]* %27, i32 0, i32 0
  %28 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 3
  %rvalue30 = load i32, i32* %28
  %fcalltmp31 = call i32 @work(%main_type* %25, i32* %lvalue_ptr28, i32* %lvalue_ptr29, i32 %rvalue30)
  store i32 %fcalltmp31, i32* %23
  %str_ptr = getelementptr [7 x i8], [7 x i8]* @str, i32 0, i32 0
  call void @writeString(i8* %str_ptr)
  %29 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  %rvalue32 = load i32, i32* %29
  %addtmp33 = add i32 %rvalue32, 1
  call void @writeInteger(i32 %addtmp33)
  %str_ptr34 = getelementptr [3 x i8], [3 x i8]* @str.1, i32 0, i32 0
  call void @writeString(i8* %str_ptr34)
  %30 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 5
  %rvalue35 = load i32, i32* %30
  call void @writeInteger(i32 %rvalue35)
  %str_ptr36 = getelementptr [2 x i8], [2 x i8]* @str.2, i32 0, i32 0
  call void @writeString(i8* %str_ptr36)
  %31 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  %32 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  %rvalue37 = load i32, i32* %32
  %addtmp38 = add i32 %rvalue37, 1
  store i32 %addtmp38, i32* %31
  br label %loop

afterloop39:                                      ; preds = %then
  ret void
}
