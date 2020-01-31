; ModuleID = 'prwtoi_ir.ll'
source_filename = "dana program"

%main_type = type { i32, i32, i32 }
%prime_type = type { %main_type*, i32, i32 }

@str = private unnamed_addr constant [8 x i8] c"Limit: \00"
@str.1 = private unnamed_addr constant [9 x i8] c"Primes:\0A\00"
@str.2 = private unnamed_addr constant [2 x i8] c"\0A\00"
@str.3 = private unnamed_addr constant [2 x i8] c"\0A\00"
@str.4 = private unnamed_addr constant [2 x i8] c"\0A\00"
@str.5 = private unnamed_addr constant [2 x i8] c"\0A\00"
@str.6 = private unnamed_addr constant [9 x i8] c"\0ATotal: \00"
@str.7 = private unnamed_addr constant [2 x i8] c"\0A\00"

define void @main() {
entry:
  %main_frame = alloca %main_type
  %str_ptr = getelementptr [8 x i8], [8 x i8]* @str, i32 0, i32 0
  call void @writeString(i8* %str_ptr)
  %0 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %fcalltmp = call i32 @readInteger()
  store i32 %fcalltmp, i32* %0
  %str_ptr1 = getelementptr [9 x i8], [9 x i8]* @str.1, i32 0, i32 0
  call void @writeString(i8* %str_ptr1)
  %1 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  store i32 0, i32* %1
  %2 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %rvalue = load i32, i32* %2
  %ge = icmp sge i32 %rvalue, 2
  %3 = sext i1 %ge to i32
  %ifcond = icmp ne i32 %3, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %entry
  %4 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %5 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %rvalue2 = load i32, i32* %5
  %addtmp = add i32 %rvalue2, 1
  store i32 %addtmp, i32* %4
  call void @writeInteger(i32 2)
  %str_ptr3 = getelementptr [2 x i8], [2 x i8]* @str.2, i32 0, i32 0
  call void @writeString(i8* %str_ptr3)
  br label %ifcont

elif:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %elif, %then
  %6 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %rvalue4 = load i32, i32* %6
  %ge5 = icmp sge i32 %rvalue4, 3
  %7 = sext i1 %ge5 to i32
  %ifcond6 = icmp ne i32 %7, 0
  br i1 %ifcond6, label %then7, label %elif11

then7:                                            ; preds = %ifcont
  %8 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %9 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %rvalue8 = load i32, i32* %9
  %addtmp9 = add i32 %rvalue8, 1
  store i32 %addtmp9, i32* %8
  call void @writeInteger(i32 3)
  %str_ptr10 = getelementptr [2 x i8], [2 x i8]* @str.3, i32 0, i32 0
  call void @writeString(i8* %str_ptr10)
  br label %ifcont12

elif11:                                           ; preds = %ifcont
  br label %ifcont12

ifcont12:                                         ; preds = %elif11, %then7
  %10 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  store i32 5, i32* %10
  br label %loop

loop:                                             ; preds = %ifcont44, %ifcont12
  %11 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue13 = load i32, i32* %11
  %12 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %rvalue14 = load i32, i32* %12
  %gt = icmp sgt i32 %rvalue13, %rvalue14
  %13 = sext i1 %gt to i32
  %ifcond15 = icmp ne i32 %13, 0
  br i1 %ifcond15, label %then16, label %elif17

then16:                                           ; preds = %loop
  br label %afterloop

elif17:                                           ; preds = %loop
  %14 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue18 = load i32, i32* %14
  %fcalltmp19 = call i8 @prime(%main_type* %main_frame, i32 %rvalue18)
  %15 = sext i8 %fcalltmp19 to i32
  %elifcond = icmp ne i32 %15, 0
  br i1 %elifcond, label %elifthen, label %elif24

elifthen:                                         ; preds = %elif17
  %16 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %17 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %rvalue20 = load i32, i32* %17
  %addtmp21 = add i32 %rvalue20, 1
  store i32 %addtmp21, i32* %16
  %18 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue22 = load i32, i32* %18
  call void @writeInteger(i32 %rvalue22)
  %str_ptr23 = getelementptr [2 x i8], [2 x i8]* @str.4, i32 0, i32 0
  call void @writeString(i8* %str_ptr23)
  br label %ifcont25

elif24:                                           ; preds = %elif17
  br label %elifcont

elifcont:                                         ; preds = %elif24
  br label %ifcont25

ifcont25:                                         ; preds = %elifcont, %elifthen
  %19 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %20 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue26 = load i32, i32* %20
  %addtmp27 = add i32 %rvalue26, 2
  store i32 %addtmp27, i32* %19
  %21 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue28 = load i32, i32* %21
  %22 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %rvalue29 = load i32, i32* %22
  %gt30 = icmp sgt i32 %rvalue28, %rvalue29
  %23 = sext i1 %gt30 to i32
  %ifcond31 = icmp ne i32 %23, 0
  br i1 %ifcond31, label %then32, label %elif33

then32:                                           ; preds = %ifcont25
  br label %afterloop

elif33:                                           ; preds = %ifcont25
  %24 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue34 = load i32, i32* %24
  %fcalltmp35 = call i8 @prime(%main_type* %main_frame, i32 %rvalue34)
  %25 = sext i8 %fcalltmp35 to i32
  %elifcond36 = icmp ne i32 %25, 0
  br i1 %elifcond36, label %elifthen37, label %elif42

elifthen37:                                       ; preds = %elif33
  %26 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %27 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %rvalue38 = load i32, i32* %27
  %addtmp39 = add i32 %rvalue38, 1
  store i32 %addtmp39, i32* %26
  %28 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue40 = load i32, i32* %28
  call void @writeInteger(i32 %rvalue40)
  %str_ptr41 = getelementptr [2 x i8], [2 x i8]* @str.5, i32 0, i32 0
  call void @writeString(i8* %str_ptr41)
  br label %ifcont44

elif42:                                           ; preds = %elif33
  br label %elifcont43

elifcont43:                                       ; preds = %elif42
  br label %ifcont44

ifcont44:                                         ; preds = %elifcont43, %elifthen37
  %29 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %30 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue45 = load i32, i32* %30
  %addtmp46 = add i32 %rvalue45, 4
  store i32 %addtmp46, i32* %29
  br label %loop

afterloop:                                        ; preds = %then32, %then16
  %str_ptr47 = getelementptr [9 x i8], [9 x i8]* @str.6, i32 0, i32 0
  call void @writeString(i8* %str_ptr47)
  %31 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %rvalue48 = load i32, i32* %31
  call void @writeInteger(i32 %rvalue48)
  %str_ptr49 = getelementptr [2 x i8], [2 x i8]* @str.7, i32 0, i32 0
  call void @writeString(i8* %str_ptr49)
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

define i8 @prime(%main_type* %main_frame, i32 %n) {
entry:
  %prime_frame = alloca %prime_type
  %0 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %n_pos = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 1
  store i32 %n, i32* %n_pos
  %1 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 1
  %rvalue = load i32, i32* %1
  %lt = icmp slt i32 %rvalue, 0
  %2 = sext i1 %lt to i32
  %ifcond = icmp ne i32 %2, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %entry
  %3 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 0
  %4 = load %main_type*, %main_type** %3
  %5 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 1
  %rvalue1 = load i32, i32* %5
  %usubtmp = sub i32 0, %rvalue1
  %fcalltmp = call i8 @prime(%main_type* %4, i32 %usubtmp)
  ret i8 %fcalltmp

elif:                                             ; preds = %entry
  %6 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 1
  %rvalue2 = load i32, i32* %6
  %lt3 = icmp slt i32 %rvalue2, 2
  %7 = sext i1 %lt3 to i32
  %elifcond = icmp ne i32 %7, 0
  br i1 %elifcond, label %elifthen, label %elif4

elifthen:                                         ; preds = %elif
  ret i8 0

elif4:                                            ; preds = %elif
  %8 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 1
  %rvalue5 = load i32, i32* %8
  %eq = icmp eq i32 %rvalue5, 2
  %9 = sext i1 %eq to i32
  %elifcond6 = icmp ne i32 %9, 0
  br i1 %elifcond6, label %elifthen7, label %elif8

elifthen7:                                        ; preds = %elif4
  ret i8 1

elif8:                                            ; preds = %elif4
  %10 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 1
  %rvalue9 = load i32, i32* %10
  %modtmp = srem i32 %rvalue9, 2
  %eq10 = icmp eq i32 %modtmp, 0
  %11 = sext i1 %eq10 to i32
  %elifcond11 = icmp ne i32 %11, 0
  br i1 %elifcond11, label %elifthen12, label %elif13

elifthen12:                                       ; preds = %elif8
  ret i8 0

elif13:                                           ; preds = %elif8
  br label %elifcont

elifcont:                                         ; preds = %elif13
  br label %elifcont14

elifcont14:                                       ; preds = %elifcont
  br label %elifcont15

elifcont15:                                       ; preds = %elifcont14
  br label %else

else:                                             ; preds = %elifcont15
  %12 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 2
  store i32 3, i32* %12
  br label %loop

loop:                                             ; preds = %ifcont, %else
  %13 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 2
  %rvalue16 = load i32, i32* %13
  %14 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 1
  %rvalue17 = load i32, i32* %14
  %divtmp = sdiv i32 %rvalue17, 2
  %gt = icmp sgt i32 %rvalue16, %divtmp
  %15 = sext i1 %gt to i32
  %ifcond18 = icmp ne i32 %15, 0
  br i1 %ifcond18, label %then19, label %elif20

then19:                                           ; preds = %loop
  br label %afterloop

elif20:                                           ; preds = %loop
  %16 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 1
  %rvalue21 = load i32, i32* %16
  %17 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 2
  %rvalue22 = load i32, i32* %17
  %modtmp23 = srem i32 %rvalue21, %rvalue22
  %eq24 = icmp eq i32 %modtmp23, 0
  %18 = sext i1 %eq24 to i32
  %elifcond25 = icmp ne i32 %18, 0
  br i1 %elifcond25, label %elifthen26, label %elif27

elifthen26:                                       ; preds = %elif20
  ret i8 0

elif27:                                           ; preds = %elif20
  br label %elifcont28

elifcont28:                                       ; preds = %elif27
  br label %ifcont

ifcont:                                           ; preds = %elifcont28
  %19 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 2
  %20 = getelementptr inbounds %prime_type, %prime_type* %prime_frame, i32 0, i32 2
  %rvalue29 = load i32, i32* %20
  %addtmp = add i32 %rvalue29, 2
  store i32 %addtmp, i32* %19
  br label %loop

afterloop:                                        ; preds = %then19
  ret i8 1

ifcont30:                                         ; No predecessors!
  unreachable
}
