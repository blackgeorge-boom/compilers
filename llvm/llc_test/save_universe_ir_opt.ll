; ModuleID = 'save_universe_ir.ll'
source_filename = "dana program"

%main_type = type {}
%work_type = type { %main_type*, [1 x [101 x i8]]*, i32, [1 x [101 x i8]]*, i32, i32, i32, i32, i32, i32, i32 }
%ArrayIndexOf_type = type { %work_type*, [1 x [101 x i8]]*, i32, [101 x i8]*, i32, i32, i32 }
%main2_type = type { %main_type*, i32, i32, i32, i32, i32, i32, [100 x [101 x i8]], [1000 x [101 x i8]] }

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

define i32 @work(%main_type* %main_frame, [101 x i8]* %engines, i32 %e_length, [101 x i8]* %queries, i32 %q_length) {
entry:
  %work_frame = alloca %work_type
  %0 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %engines_pos = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 1
  %cast = bitcast [101 x i8]* %engines to [1 x [101 x i8]]*
  store [1 x [101 x i8]]* %cast, [1 x [101 x i8]]** %engines_pos
  %e_length_pos = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 2
  store i32 %e_length, i32* %e_length_pos
  %queries_pos = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 3
  %cast1 = bitcast [101 x i8]* %queries to [1 x [101 x i8]]*
  store [1 x [101 x i8]]* %cast1, [1 x [101 x i8]]** %queries_pos
  %q_length_pos = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 4
  store i32 %q_length, i32* %q_length_pos
  %1 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 6
  store i32 -1, i32* %1
  %2 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 8
  store i32 0, i32* %2
  %3 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 9
  store i32 0, i32* %3
  br label %loop

loop:                                             ; preds = %afterloop, %entry
  %4 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 6
  %rvalue = load i32, i32* %4
  %5 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 4
  %rvalue2 = load i32, i32* %5
  %gt = icmp sgt i32 %rvalue, %rvalue2
  %6 = sext i1 %gt to i32
  %ifcond = icmp ne i32 %6, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  br label %afterloop36

elif:                                             ; preds = %loop
  br label %ifcont

ifcont:                                           ; preds = %elif
  %7 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 7
  store i32 -1, i32* %7
  %8 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 10
  store i32 0, i32* %8
  br label %loop3

loop3:                                            ; preds = %ifcont30, %ifcont
  %9 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 10
  %rvalue4 = load i32, i32* %9
  %10 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 2
  %rvalue5 = load i32, i32* %10
  %eq = icmp eq i32 %rvalue4, %rvalue5
  %11 = sext i1 %eq to i32
  %ifcond6 = icmp ne i32 %11, 0
  br i1 %ifcond6, label %then7, label %elif8

then7:                                            ; preds = %loop3
  br label %afterloop

elif8:                                            ; preds = %loop3
  br label %ifcont9

ifcont9:                                          ; preds = %elif8
  %12 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 5
  %13 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 3
  %temp = load [1 x [101 x i8]]*, [1 x [101 x i8]]** %13
  %lvalue_ptr = getelementptr [1 x [101 x i8]], [1 x [101 x i8]]* %temp, i32 0, i32 0
  %14 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 4
  %rvalue10 = load i32, i32* %14
  %15 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 10
  %rvalue11 = load i32, i32* %15
  %16 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 1
  %temp12 = load [1 x [101 x i8]]*, [1 x [101 x i8]]** %16
  %lvalue_ptr13 = getelementptr [1 x [101 x i8]], [1 x [101 x i8]]* %temp12, i32 0, i32 %rvalue11
  %17 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 8
  %rvalue14 = load i32, i32* %17
  %fcalltmp = call i32 @ArrayIndexOf(%work_type* %work_frame, [101 x i8]* %lvalue_ptr, i32 %rvalue10, [101 x i8]* %lvalue_ptr13, i32 %rvalue14)
  store i32 %fcalltmp, i32* %12
  %18 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 5
  %rvalue15 = load i32, i32* %18
  %eq16 = icmp eq i32 %rvalue15, -1
  %19 = sext i1 %eq16 to i32
  %ifcond17 = icmp ne i32 %19, 0
  br i1 %ifcond17, label %then18, label %elif20

then18:                                           ; preds = %ifcont9
  %20 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 5
  %21 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 4
  %rvalue19 = load i32, i32* %21
  %addtmp = add i32 %rvalue19, 1
  store i32 %addtmp, i32* %20
  br label %ifcont21

elif20:                                           ; preds = %ifcont9
  br label %ifcont21

ifcont21:                                         ; preds = %elif20, %then18
  %22 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 5
  %rvalue22 = load i32, i32* %22
  %23 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 6
  %rvalue23 = load i32, i32* %23
  %gt24 = icmp sgt i32 %rvalue22, %rvalue23
  %24 = sext i1 %gt24 to i32
  %ifcond25 = icmp ne i32 %24, 0
  br i1 %ifcond25, label %then26, label %elif29

then26:                                           ; preds = %ifcont21
  %25 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 6
  %26 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 5
  %rvalue27 = load i32, i32* %26
  store i32 %rvalue27, i32* %25
  %27 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 7
  %28 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 10
  %rvalue28 = load i32, i32* %28
  store i32 %rvalue28, i32* %27
  br label %ifcont30

elif29:                                           ; preds = %ifcont21
  br label %ifcont30

ifcont30:                                         ; preds = %elif29, %then26
  %29 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 10
  %30 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 10
  %rvalue31 = load i32, i32* %30
  %addtmp32 = add i32 %rvalue31, 1
  store i32 %addtmp32, i32* %29
  br label %loop3

afterloop:                                        ; preds = %then7
  %31 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 8
  %32 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 6
  %rvalue33 = load i32, i32* %32
  store i32 %rvalue33, i32* %31
  %33 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 9
  %34 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 9
  %rvalue34 = load i32, i32* %34
  %addtmp35 = add i32 %rvalue34, 1
  store i32 %addtmp35, i32* %33
  br label %loop

afterloop36:                                      ; preds = %then
  %35 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 9
  %rvalue37 = load i32, i32* %35
  %subtmp = sub i32 %rvalue37, 1
  ret i32 %subtmp
}

define i32 @ArrayIndexOf(%work_type* %work_frame, [101 x i8]* %arr, i32 %len, [101 x i8]* %val, i32 %start) {
entry:
  %ArrayIndexOf_frame = alloca %ArrayIndexOf_type
  %0 = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 0
  store %work_type* %work_frame, %work_type** %0
  %arr_pos = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 1
  %cast = bitcast [101 x i8]* %arr to [1 x [101 x i8]]*
  store [1 x [101 x i8]]* %cast, [1 x [101 x i8]]** %arr_pos
  %len_pos = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 2
  store i32 %len, i32* %len_pos
  %val_pos = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 3
  store [101 x i8]* %val, [101 x i8]** %val_pos
  %start_pos = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 4
  store i32 %start, i32* %start_pos
  %1 = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 5
  %2 = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 4
  %rvalue = load i32, i32* %2
  store i32 %rvalue, i32* %1
  br label %loop

loop:                                             ; preds = %ifcont12, %entry
  %3 = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 5
  %rvalue1 = load i32, i32* %3
  %4 = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 2
  %rvalue2 = load i32, i32* %4
  %eq = icmp eq i32 %rvalue1, %rvalue2
  %5 = sext i1 %eq to i32
  %ifcond = icmp ne i32 %5, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  ret i32 -1

elif:                                             ; preds = %loop
  br label %ifcont

ifcont:                                           ; preds = %elif
  %6 = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 5
  %rvalue3 = load i32, i32* %6
  %7 = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 1
  %temp = load [1 x [101 x i8]]*, [1 x [101 x i8]]** %7
  %lvalue_ptr = getelementptr [1 x [101 x i8]], [1 x [101 x i8]]* %temp, i32 0, i32 %rvalue3
  %lvalue_ptr4 = getelementptr [101 x i8], [101 x i8]* %lvalue_ptr, i32 0, i32 0
  %8 = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 3
  %temp5 = load [101 x i8]*, [101 x i8]** %8
  %lvalue_ptr6 = getelementptr [101 x i8], [101 x i8]* %temp5, i32 0, i32 0
  %fcalltmp = call i32 @strcmp(i8* %lvalue_ptr4, i8* %lvalue_ptr6)
  %eq7 = icmp eq i32 %fcalltmp, 0
  %9 = sext i1 %eq7 to i32
  %ifcond8 = icmp ne i32 %9, 0
  br i1 %ifcond8, label %then9, label %elif11

then9:                                            ; preds = %ifcont
  %10 = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 5
  %rvalue10 = load i32, i32* %10
  ret i32 %rvalue10

elif11:                                           ; preds = %ifcont
  br label %ifcont12

ifcont12:                                         ; preds = %elif11
  %11 = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 5
  %12 = getelementptr inbounds %ArrayIndexOf_type, %ArrayIndexOf_type* %ArrayIndexOf_frame, i32 0, i32 5
  %rvalue13 = load i32, i32* %12
  %addtmp = add i32 %rvalue13, 1
  store i32 %addtmp, i32* %11
  br label %loop

afterloop:                                        ; No predecessors!
  ret i32 0
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

loop:                                             ; preds = %afterloop28, %entry
  %3 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  %rvalue = load i32, i32* %3
  %4 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 1
  %rvalue1 = load i32, i32* %4
  %eq = icmp eq i32 %rvalue, %rvalue1
  %5 = sext i1 %eq to i32
  %ifcond = icmp ne i32 %5, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  br label %afterloop41

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
  %12 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 7
  %lvalue_ptr = getelementptr [100 x [101 x i8]], [100 x [101 x i8]]* %12, i32 0, i32 %rvalue11
  %lvalue_ptr12 = getelementptr [101 x i8], [101 x i8]* %lvalue_ptr, i32 0, i32 0
  call void @readString(i32 101, i8* %lvalue_ptr12)
  %13 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %14 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %rvalue13 = load i32, i32* %14
  %addtmp = add i32 %rvalue13, 1
  store i32 %addtmp, i32* %13
  br label %loop3

afterloop:                                        ; preds = %then8
  %15 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 5
  %fcalltmp14 = call i32 @readInteger()
  store i32 %fcalltmp14, i32* %15
  %16 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  store i32 0, i32* %16
  br label %loop15

loop15:                                           ; preds = %ifcont22, %afterloop
  %17 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %rvalue16 = load i32, i32* %17
  %18 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 5
  %rvalue17 = load i32, i32* %18
  %eq18 = icmp eq i32 %rvalue16, %rvalue17
  %19 = sext i1 %eq18 to i32
  %ifcond19 = icmp ne i32 %19, 0
  br i1 %ifcond19, label %then20, label %elif21

then20:                                           ; preds = %loop15
  br label %afterloop28

elif21:                                           ; preds = %loop15
  br label %ifcont22

ifcont22:                                         ; preds = %elif21
  %20 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %rvalue23 = load i32, i32* %20
  %21 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 8
  %lvalue_ptr24 = getelementptr [1000 x [101 x i8]], [1000 x [101 x i8]]* %21, i32 0, i32 %rvalue23
  %lvalue_ptr25 = getelementptr [101 x i8], [101 x i8]* %lvalue_ptr24, i32 0, i32 0
  call void @readString(i32 101, i8* %lvalue_ptr25)
  %22 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %23 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %rvalue26 = load i32, i32* %23
  %addtmp27 = add i32 %rvalue26, 1
  store i32 %addtmp27, i32* %22
  br label %loop15

afterloop28:                                      ; preds = %then20
  %24 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 6
  %25 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 0
  %26 = load %main_type*, %main_type** %25
  %27 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 7
  %lvalue_ptr29 = getelementptr [100 x [101 x i8]], [100 x [101 x i8]]* %27, i32 0, i32 0
  %28 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 3
  %rvalue30 = load i32, i32* %28
  %29 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 8
  %lvalue_ptr31 = getelementptr [1000 x [101 x i8]], [1000 x [101 x i8]]* %29, i32 0, i32 0
  %30 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 5
  %rvalue32 = load i32, i32* %30
  %fcalltmp33 = call i32 @work(%main_type* %26, [101 x i8]* %lvalue_ptr29, i32 %rvalue30, [101 x i8]* %lvalue_ptr31, i32 %rvalue32)
  store i32 %fcalltmp33, i32* %24
  %str_ptr = getelementptr [7 x i8], [7 x i8]* @str, i32 0, i32 0
  call void @writeString(i8* %str_ptr)
  %31 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  %rvalue34 = load i32, i32* %31
  %addtmp35 = add i32 %rvalue34, 1
  call void @writeInteger(i32 %addtmp35)
  %str_ptr36 = getelementptr [3 x i8], [3 x i8]* @str.1, i32 0, i32 0
  call void @writeString(i8* %str_ptr36)
  %32 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 6
  %rvalue37 = load i32, i32* %32
  call void @writeInteger(i32 %rvalue37)
  %str_ptr38 = getelementptr [2 x i8], [2 x i8]* @str.2, i32 0, i32 0
  call void @writeString(i8* %str_ptr38)
  %33 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  %34 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  %rvalue39 = load i32, i32* %34
  %addtmp40 = add i32 %rvalue39, 1
  store i32 %addtmp40, i32* %33
  br label %loop

afterloop41:                                      ; preds = %then
  ret void
}
