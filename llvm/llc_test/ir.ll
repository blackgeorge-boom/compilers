; ModuleID = 'dana program'
source_filename = "dana program"

%main_type = type { [80 x i8] }
%printBoxed_type = type { %main_type*, [1 x i8]*, i32, i32 }

@str = private unnamed_addr constant [2 x i8] c"\0A\00"
@str.11 = private unnamed_addr constant [5 x i8] c"****\00"
@str.12 = private unnamed_addr constant [3 x i8] c"*\0A\00"
@str.13 = private unnamed_addr constant [3 x i8] c"* \00"
@str.14 = private unnamed_addr constant [2 x i8] c" \00"
@str.15 = private unnamed_addr constant [3 x i8] c"*\0A\00"
@str.16 = private unnamed_addr constant [5 x i8] c"****\00"
@str.17 = private unnamed_addr constant [4 x i8] c"*\0A\0A\00"
@str.18 = private unnamed_addr constant [22 x i8] c"Please, give a word: \00"
@str.19 = private unnamed_addr constant [6 x i8] c"peace\00"

define void @main() {
entry:
  %main_frame = alloca %main_type
  br label %loop

loop:                                             ; preds = %ifcont, %entry
  %str_ptr = getelementptr [22 x i8], [22 x i8]* @str.18, i32 0, i32 0
  call void @writeString(i8* %str_ptr)
  %0 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %lvalue_ptr = getelementptr [80 x i8], [80 x i8]* %0, i32 0, i32 0
  call void @readString(i32 80, i8* %lvalue_ptr)
  %1 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %lvalue_ptr1 = getelementptr [80 x i8], [80 x i8]* %1, i32 0, i32 0
  %str_ptr2 = getelementptr [6 x i8], [6 x i8]* @str.19, i32 0, i32 0
  %fcalltmp = call i32 @strcmp(i8* %lvalue_ptr1, i8* %str_ptr2)
  %eq = icmp eq i32 %fcalltmp, 0
  %2 = sext i1 %eq to i32
  %ifcond = icmp ne i32 %2, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  br label %afterloop

elif:                                             ; preds = %loop
  br label %ifcont

ifcont:                                           ; preds = %elif
  %3 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %lvalue_ptr3 = getelementptr [80 x i8], [80 x i8]* %3, i32 0, i32 0
  call void @printBoxed(%main_type* %main_frame, i8* %lvalue_ptr3)
  br label %loop

afterloop:                                        ; preds = %then
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

declare i32 @strlen.9(%main_type*, i8*)

declare i32 @strcmp.10(%main_type*, i8*, i8*)

define void @printBoxed(%main_type* %main_frame, i8* %word) {
entry:
  %printBoxed_frame = alloca %printBoxed_type
  %0 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %word_pos = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 1
  %cast = bitcast i8* %word to [1 x i8]*
  store [1 x i8]* %cast, [1 x i8]** %word_pos
  %1 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 2
  %2 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 1
  %temp = load [1 x i8]*, [1 x i8]** %2
  %lvalue_ptr = getelementptr [1 x i8], [1 x i8]* %temp, i32 0, i32 0
  %fcalltmp = call i32 @strlen(i8* %lvalue_ptr)
  store i32 %fcalltmp, i32* %1
  %str_ptr = getelementptr [2 x i8], [2 x i8]* @str, i32 0, i32 0
  call void @writeString(i8* %str_ptr)
  %3 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  store i32 0, i32* %3
  br label %loop

loop:                                             ; preds = %ifcont, %entry
  %str_ptr1 = getelementptr [5 x i8], [5 x i8]* @str.11, i32 0, i32 0
  call void @writeString(i8* %str_ptr1)
  %4 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %5 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %rvalue = load i32, i32* %5
  %addtmp = add i32 %rvalue, 1
  store i32 %addtmp, i32* %4
  %6 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %rvalue2 = load i32, i32* %6
  %7 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 2
  %rvalue3 = load i32, i32* %7
  %ge = icmp sge i32 %rvalue2, %rvalue3
  %8 = sext i1 %ge to i32
  %ifcond = icmp ne i32 %8, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  br label %afterloop

elif:                                             ; preds = %loop
  br label %ifcont

ifcont:                                           ; preds = %elif
  br label %loop

afterloop:                                        ; preds = %then
  %str_ptr4 = getelementptr [3 x i8], [3 x i8]* @str.12, i32 0, i32 0
  call void @writeString(i8* %str_ptr4)
  %9 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  store i32 0, i32* %9
  br label %loop5

loop5:                                            ; preds = %ifcont55, %afterloop
  %str_ptr6 = getelementptr [3 x i8], [3 x i8]* @str.13, i32 0, i32 0
  call void @writeString(i8* %str_ptr6)
  %10 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %rvalue7 = load i32, i32* %10
  %11 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 1
  %temp8 = load [1 x i8]*, [1 x i8]** %11
  %lvalue_ptr9 = getelementptr [1 x i8], [1 x i8]* %temp8, i32 0, i32 %rvalue7
  %rvalue10 = load i8, i8* %lvalue_ptr9
  %ge11 = icmp uge i8 %rvalue10, 65
  %12 = sext i1 %ge11 to i32
  %finttobit = icmp eq i32 %12, 0
  br i1 %finttobit, label %andshortcircuit, label %andsecond

andshortcircuit:                                  ; preds = %loop5
  br label %andcont

andsecond:                                        ; preds = %loop5
  %13 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %rvalue12 = load i32, i32* %13
  %14 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 1
  %temp13 = load [1 x i8]*, [1 x i8]** %14
  %lvalue_ptr14 = getelementptr [1 x i8], [1 x i8]* %temp13, i32 0, i32 %rvalue12
  %rvalue15 = load i8, i8* %lvalue_ptr14
  %le = icmp ule i8 %rvalue15, 90
  %15 = sext i1 %le to i32
  %sinttobit = icmp ne i32 %15, 0
  br label %andcont

andcont:                                          ; preds = %andsecond, %andshortcircuit
  %andtmp = phi i1 [ %finttobit, %andshortcircuit ], [ %sinttobit, %andsecond ]
  %16 = sext i1 %andtmp to i32
  %ifcond16 = icmp ne i32 %16, 0
  br i1 %ifcond16, label %then17, label %elif22

then17:                                           ; preds = %andcont
  %17 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %rvalue18 = load i32, i32* %17
  %18 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 1
  %temp19 = load [1 x i8]*, [1 x i8]** %18
  %lvalue_ptr20 = getelementptr [1 x i8], [1 x i8]* %temp19, i32 0, i32 %rvalue18
  %rvalue21 = load i8, i8* %lvalue_ptr20
  call void @writeChar(i8 %rvalue21)
  br label %ifcont45

elif22:                                           ; preds = %andcont
  %19 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %rvalue23 = load i32, i32* %19
  %20 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 1
  %temp24 = load [1 x i8]*, [1 x i8]** %20
  %lvalue_ptr25 = getelementptr [1 x i8], [1 x i8]* %temp24, i32 0, i32 %rvalue23
  %rvalue26 = load i8, i8* %lvalue_ptr25
  %ge27 = icmp uge i8 %rvalue26, 97
  %21 = sext i1 %ge27 to i32
  %finttobit28 = icmp eq i32 %21, 0
  br i1 %finttobit28, label %andshortcircuit29, label %andsecond30

andshortcircuit29:                                ; preds = %elif22
  br label %andcont37

andsecond30:                                      ; preds = %elif22
  %22 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %rvalue31 = load i32, i32* %22
  %23 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 1
  %temp32 = load [1 x i8]*, [1 x i8]** %23
  %lvalue_ptr33 = getelementptr [1 x i8], [1 x i8]* %temp32, i32 0, i32 %rvalue31
  %rvalue34 = load i8, i8* %lvalue_ptr33
  %le35 = icmp ule i8 %rvalue34, 122
  %24 = sext i1 %le35 to i32
  %sinttobit36 = icmp ne i32 %24, 0
  br label %andcont37

andcont37:                                        ; preds = %andsecond30, %andshortcircuit29
  %andtmp38 = phi i1 [ %finttobit28, %andshortcircuit29 ], [ %sinttobit36, %andsecond30 ]
  %25 = sext i1 %andtmp38 to i32
  %elifcond = icmp ne i32 %25, 0
  br i1 %elifcond, label %elifthen, label %elif44

elifthen:                                         ; preds = %andcont37
  %26 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %rvalue39 = load i32, i32* %26
  %27 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 1
  %temp40 = load [1 x i8]*, [1 x i8]** %27
  %lvalue_ptr41 = getelementptr [1 x i8], [1 x i8]* %temp40, i32 0, i32 %rvalue39
  %rvalue42 = load i8, i8* %lvalue_ptr41
  %addtmp43 = add i8 %rvalue42, 65
  %subtmp = sub i8 %addtmp43, 97
  call void @writeChar(i8 %subtmp)
  br label %ifcont45

elif44:                                           ; preds = %andcont37
  br label %elifcont

elifcont:                                         ; preds = %elif44
  br label %ifcont45

ifcont45:                                         ; preds = %elifcont, %elifthen, %then17
  %str_ptr46 = getelementptr [2 x i8], [2 x i8]* @str.14, i32 0, i32 0
  call void @writeString(i8* %str_ptr46)
  %28 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %29 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %rvalue47 = load i32, i32* %29
  %addtmp48 = add i32 %rvalue47, 1
  store i32 %addtmp48, i32* %28
  %30 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %rvalue49 = load i32, i32* %30
  %31 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 2
  %rvalue50 = load i32, i32* %31
  %ge51 = icmp sge i32 %rvalue49, %rvalue50
  %32 = sext i1 %ge51 to i32
  %ifcond52 = icmp ne i32 %32, 0
  br i1 %ifcond52, label %then53, label %elif54

then53:                                           ; preds = %ifcont45
  br label %afterloop56

elif54:                                           ; preds = %ifcont45
  br label %ifcont55

ifcont55:                                         ; preds = %elif54
  br label %loop5

afterloop56:                                      ; preds = %then53
  %str_ptr57 = getelementptr [3 x i8], [3 x i8]* @str.15, i32 0, i32 0
  call void @writeString(i8* %str_ptr57)
  %33 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  store i32 0, i32* %33
  br label %loop58

loop58:                                           ; preds = %ifcont68, %afterloop56
  %str_ptr59 = getelementptr [5 x i8], [5 x i8]* @str.16, i32 0, i32 0
  call void @writeString(i8* %str_ptr59)
  %34 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %35 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %rvalue60 = load i32, i32* %35
  %addtmp61 = add i32 %rvalue60, 1
  store i32 %addtmp61, i32* %34
  %36 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 3
  %rvalue62 = load i32, i32* %36
  %37 = getelementptr inbounds %printBoxed_type, %printBoxed_type* %printBoxed_frame, i32 0, i32 2
  %rvalue63 = load i32, i32* %37
  %ge64 = icmp sge i32 %rvalue62, %rvalue63
  %38 = sext i1 %ge64 to i32
  %ifcond65 = icmp ne i32 %38, 0
  br i1 %ifcond65, label %then66, label %elif67

then66:                                           ; preds = %loop58
  br label %afterloop69

elif67:                                           ; preds = %loop58
  br label %ifcont68

ifcont68:                                         ; preds = %elif67
  br label %loop58

afterloop69:                                      ; preds = %then66
  %str_ptr70 = getelementptr [4 x i8], [4 x i8]* @str.17, i32 0, i32 0
  call void @writeString(i8* %str_ptr70)
  ret void
}
