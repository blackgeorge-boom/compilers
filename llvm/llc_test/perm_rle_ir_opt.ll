; ModuleID = 'perm_rle_ir.ll'
source_filename = "dana program"

%main_type = type { i32, [16 x i32], [16 x i8], [1001 x i8] }
%work_type = type { %main_type*, i32, i32 }
%compress_type = type { %work_type*, [1 x i32]*, [1 x i8]*, [1001 x i8], i32, i32, i32, i32, i8 }
%go_type = type { %work_type*, i32, i32 }
%MathMin_type = type { %go_type*, i32, i32 }
%main2_type = type { %main_type*, i32, i32, i32, i32 }

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

define i32 @work(%main_type* %main_frame, i32 %k) {
entry:
  %work_frame = alloca %work_type
  %0 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %k_pos = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 1
  store i32 %k, i32* %k_pos
  %1 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 0
  %2 = load %main_type*, %main_type** %1
  %3 = getelementptr inbounds %main_type, %main_type* %2, i32 0, i32 0
  store i32 1073741823, i32* %3
  %4 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 2
  %5 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 0
  %6 = load %main_type*, %main_type** %5
  %7 = getelementptr inbounds %main_type, %main_type* %6, i32 0, i32 3
  %lvalue_ptr = getelementptr [1001 x i8], [1001 x i8]* %7, i32 0, i32 0
  %fcalltmp = call i32 @strlen(i8* %lvalue_ptr)
  store i32 %fcalltmp, i32* %4
  call void @go(%work_type* %work_frame, i32 0)
  %8 = getelementptr inbounds %work_type, %work_type* %work_frame, i32 0, i32 0
  %9 = load %main_type*, %main_type** %8
  %10 = getelementptr inbounds %main_type, %main_type* %9, i32 0, i32 0
  %rvalue = load i32, i32* %10
  ret i32 %rvalue
}

define i32 @compress(%work_type* %work_frame, i32* %permutation, i8* %S) {
entry:
  %compress_frame = alloca %compress_type
  %0 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 0
  store %work_type* %work_frame, %work_type** %0
  %permutation_pos = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 1
  %cast = bitcast i32* %permutation to [1 x i32]*
  store [1 x i32]* %cast, [1 x i32]** %permutation_pos
  %S_pos = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 2
  %cast1 = bitcast i8* %S to [1 x i8]*
  store [1 x i8]* %cast1, [1 x i8]** %S_pos
  %1 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 8
  %fcalltmp = call i8 @shrink(i32 -1)
  store i8 %fcalltmp, i8* %1
  %2 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 4
  store i32 0, i32* %2
  %3 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 5
  store i32 0, i32* %3
  %4 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 6
  store i32 0, i32* %4
  %5 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 7
  store i32 0, i32* %5
  br label %loop

loop:                                             ; preds = %ifcont35, %entry
  %6 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 7
  %rvalue = load i32, i32* %6
  %7 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 0
  %8 = load %work_type*, %work_type** %7
  %9 = getelementptr inbounds %work_type, %work_type* %8, i32 0, i32 2
  %rvalue2 = load i32, i32* %9
  %eq = icmp eq i32 %rvalue, %rvalue2
  %10 = sext i1 %eq to i32
  %ifcond = icmp ne i32 %10, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  br label %afterloop

elif:                                             ; preds = %loop
  br label %ifcont

ifcont:                                           ; preds = %elif
  %11 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 7
  %rvalue3 = load i32, i32* %11
  %12 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 3
  %lvalue_ptr = getelementptr [1001 x i8], [1001 x i8]* %12, i32 0, i32 %rvalue3
  %13 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 6
  %rvalue4 = load i32, i32* %13
  %14 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 5
  %rvalue5 = load i32, i32* %14
  %15 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 1
  %temp = load [1 x i32]*, [1 x i32]** %15
  %lvalue_ptr6 = getelementptr [1 x i32], [1 x i32]* %temp, i32 0, i32 %rvalue5
  %rvalue7 = load i32, i32* %lvalue_ptr6
  %addtmp = add i32 %rvalue4, %rvalue7
  %16 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 2
  %temp8 = load [1 x i8]*, [1 x i8]** %16
  %lvalue_ptr9 = getelementptr [1 x i8], [1 x i8]* %temp8, i32 0, i32 %addtmp
  %rvalue10 = load i8, i8* %lvalue_ptr9
  store i8 %rvalue10, i8* %lvalue_ptr
  %17 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 5
  %18 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 5
  %rvalue11 = load i32, i32* %18
  %addtmp12 = add i32 %rvalue11, 1
  store i32 %addtmp12, i32* %17
  %19 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 5
  %rvalue13 = load i32, i32* %19
  %20 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 0
  %21 = load %work_type*, %work_type** %20
  %22 = getelementptr inbounds %work_type, %work_type* %21, i32 0, i32 1
  %rvalue14 = load i32, i32* %22
  %eq15 = icmp eq i32 %rvalue13, %rvalue14
  %23 = sext i1 %eq15 to i32
  %ifcond16 = icmp ne i32 %23, 0
  br i1 %ifcond16, label %then17, label %elif21

then17:                                           ; preds = %ifcont
  %24 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 5
  store i32 0, i32* %24
  %25 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 6
  %26 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 6
  %rvalue18 = load i32, i32* %26
  %27 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 0
  %28 = load %work_type*, %work_type** %27
  %29 = getelementptr inbounds %work_type, %work_type* %28, i32 0, i32 1
  %rvalue19 = load i32, i32* %29
  %addtmp20 = add i32 %rvalue18, %rvalue19
  store i32 %addtmp20, i32* %25
  br label %ifcont22

elif21:                                           ; preds = %ifcont
  br label %ifcont22

ifcont22:                                         ; preds = %elif21, %then17
  %30 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 7
  %rvalue23 = load i32, i32* %30
  %31 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 3
  %lvalue_ptr24 = getelementptr [1001 x i8], [1001 x i8]* %31, i32 0, i32 %rvalue23
  %rvalue25 = load i8, i8* %lvalue_ptr24
  %32 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 8
  %rvalue26 = load i8, i8* %32
  %ne = icmp ne i8 %rvalue25, %rvalue26
  %33 = sext i1 %ne to i32
  %ifcond27 = icmp ne i32 %33, 0
  br i1 %ifcond27, label %then28, label %elif34

then28:                                           ; preds = %ifcont22
  %34 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 4
  %35 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 4
  %rvalue29 = load i32, i32* %35
  %addtmp30 = add i32 %rvalue29, 1
  store i32 %addtmp30, i32* %34
  %36 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 8
  %37 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 7
  %rvalue31 = load i32, i32* %37
  %38 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 3
  %lvalue_ptr32 = getelementptr [1001 x i8], [1001 x i8]* %38, i32 0, i32 %rvalue31
  %rvalue33 = load i8, i8* %lvalue_ptr32
  store i8 %rvalue33, i8* %36
  br label %ifcont35

elif34:                                           ; preds = %ifcont22
  br label %ifcont35

ifcont35:                                         ; preds = %elif34, %then28
  %39 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 7
  %40 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 7
  %rvalue36 = load i32, i32* %40
  %addtmp37 = add i32 %rvalue36, 1
  store i32 %addtmp37, i32* %39
  br label %loop

afterloop:                                        ; preds = %then
  %41 = getelementptr inbounds %compress_type, %compress_type* %compress_frame, i32 0, i32 4
  %rvalue38 = load i32, i32* %41
  ret i32 %rvalue38
}

define void @go(%work_type* %work_frame, i32 %p) {
entry:
  %go_frame = alloca %go_type
  %0 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  store %work_type* %work_frame, %work_type** %0
  %p_pos = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 1
  store i32 %p, i32* %p_pos
  %1 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 1
  %rvalue = load i32, i32* %1
  %2 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  %3 = load %work_type*, %work_type** %2
  %4 = getelementptr inbounds %work_type, %work_type* %3, i32 0, i32 1
  %rvalue1 = load i32, i32* %4
  %eq = icmp eq i32 %rvalue, %rvalue1
  %5 = sext i1 %eq to i32
  %ifcond = icmp ne i32 %5, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %entry
  %6 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  %7 = load %work_type*, %work_type** %6
  %8 = getelementptr inbounds %work_type, %work_type* %7, i32 0, i32 0
  %9 = load %main_type*, %main_type** %8
  %10 = getelementptr inbounds %main_type, %main_type* %9, i32 0, i32 0
  %11 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  %12 = load %work_type*, %work_type** %11
  %13 = getelementptr inbounds %work_type, %work_type* %12, i32 0, i32 0
  %14 = load %main_type*, %main_type** %13
  %15 = getelementptr inbounds %main_type, %main_type* %14, i32 0, i32 0
  %rvalue2 = load i32, i32* %15
  %16 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  %17 = load %work_type*, %work_type** %16
  %18 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  %19 = load %work_type*, %work_type** %18
  %20 = getelementptr inbounds %work_type, %work_type* %19, i32 0, i32 0
  %21 = load %main_type*, %main_type** %20
  %22 = getelementptr inbounds %main_type, %main_type* %21, i32 0, i32 1
  %lvalue_ptr = getelementptr [16 x i32], [16 x i32]* %22, i32 0, i32 0
  %23 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  %24 = load %work_type*, %work_type** %23
  %25 = getelementptr inbounds %work_type, %work_type* %24, i32 0, i32 0
  %26 = load %main_type*, %main_type** %25
  %27 = getelementptr inbounds %main_type, %main_type* %26, i32 0, i32 3
  %lvalue_ptr3 = getelementptr [1001 x i8], [1001 x i8]* %27, i32 0, i32 0
  %fcalltmp = call i32 @compress(%work_type* %17, i32* %lvalue_ptr, i8* %lvalue_ptr3)
  %fcalltmp4 = call i32 @MathMin(%go_type* %go_frame, i32 %rvalue2, i32 %fcalltmp)
  store i32 %fcalltmp4, i32* %10
  ret void

elif:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %elif
  %28 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 2
  store i32 0, i32* %28
  br label %loop

loop:                                             ; preds = %ifcont19, %then16, %ifcont
  %29 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 2
  %rvalue5 = load i32, i32* %29
  %30 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  %31 = load %work_type*, %work_type** %30
  %32 = getelementptr inbounds %work_type, %work_type* %31, i32 0, i32 1
  %rvalue6 = load i32, i32* %32
  %eq7 = icmp eq i32 %rvalue5, %rvalue6
  %33 = sext i1 %eq7 to i32
  %ifcond8 = icmp ne i32 %33, 0
  br i1 %ifcond8, label %then9, label %elif10

then9:                                            ; preds = %loop
  br label %afterloop

elif10:                                           ; preds = %loop
  br label %ifcont11

ifcont11:                                         ; preds = %elif10
  %34 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 2
  %rvalue12 = load i32, i32* %34
  %35 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  %36 = load %work_type*, %work_type** %35
  %37 = getelementptr inbounds %work_type, %work_type* %36, i32 0, i32 0
  %38 = load %main_type*, %main_type** %37
  %39 = getelementptr inbounds %main_type, %main_type* %38, i32 0, i32 2
  %lvalue_ptr13 = getelementptr [16 x i8], [16 x i8]* %39, i32 0, i32 %rvalue12
  %rvalue14 = load i8, i8* %lvalue_ptr13
  %40 = sext i8 %rvalue14 to i32
  %ifcond15 = icmp ne i32 %40, 0
  br i1 %ifcond15, label %then16, label %elif18

then16:                                           ; preds = %ifcont11
  %41 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 2
  %42 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 2
  %rvalue17 = load i32, i32* %42
  %addtmp = add i32 %rvalue17, 1
  store i32 %addtmp, i32* %41
  br label %loop

elif18:                                           ; preds = %ifcont11
  br label %ifcont19

ifcont19:                                         ; preds = %elif18
  %43 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 2
  %rvalue20 = load i32, i32* %43
  %44 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  %45 = load %work_type*, %work_type** %44
  %46 = getelementptr inbounds %work_type, %work_type* %45, i32 0, i32 0
  %47 = load %main_type*, %main_type** %46
  %48 = getelementptr inbounds %main_type, %main_type* %47, i32 0, i32 2
  %lvalue_ptr21 = getelementptr [16 x i8], [16 x i8]* %48, i32 0, i32 %rvalue20
  store i8 1, i8* %lvalue_ptr21
  %49 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 1
  %rvalue22 = load i32, i32* %49
  %50 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  %51 = load %work_type*, %work_type** %50
  %52 = getelementptr inbounds %work_type, %work_type* %51, i32 0, i32 0
  %53 = load %main_type*, %main_type** %52
  %54 = getelementptr inbounds %main_type, %main_type* %53, i32 0, i32 1
  %lvalue_ptr23 = getelementptr [16 x i32], [16 x i32]* %54, i32 0, i32 %rvalue22
  %55 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 2
  %rvalue24 = load i32, i32* %55
  store i32 %rvalue24, i32* %lvalue_ptr23
  %56 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  %57 = load %work_type*, %work_type** %56
  %58 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 1
  %rvalue25 = load i32, i32* %58
  %addtmp26 = add i32 %rvalue25, 1
  call void @go(%work_type* %57, i32 %addtmp26)
  %59 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 2
  %rvalue27 = load i32, i32* %59
  %60 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 0
  %61 = load %work_type*, %work_type** %60
  %62 = getelementptr inbounds %work_type, %work_type* %61, i32 0, i32 0
  %63 = load %main_type*, %main_type** %62
  %64 = getelementptr inbounds %main_type, %main_type* %63, i32 0, i32 2
  %lvalue_ptr28 = getelementptr [16 x i8], [16 x i8]* %64, i32 0, i32 %rvalue27
  store i8 0, i8* %lvalue_ptr28
  %65 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 2
  %66 = getelementptr inbounds %go_type, %go_type* %go_frame, i32 0, i32 2
  %rvalue29 = load i32, i32* %66
  %addtmp30 = add i32 %rvalue29, 1
  store i32 %addtmp30, i32* %65
  br label %loop

afterloop:                                        ; preds = %then9
  ret void
}

define i32 @MathMin(%go_type* %go_frame, i32 %x, i32 %y) {
entry:
  %MathMin_frame = alloca %MathMin_type
  %0 = getelementptr inbounds %MathMin_type, %MathMin_type* %MathMin_frame, i32 0, i32 0
  store %go_type* %go_frame, %go_type** %0
  %x_pos = getelementptr inbounds %MathMin_type, %MathMin_type* %MathMin_frame, i32 0, i32 1
  store i32 %x, i32* %x_pos
  %y_pos = getelementptr inbounds %MathMin_type, %MathMin_type* %MathMin_frame, i32 0, i32 2
  store i32 %y, i32* %y_pos
  %1 = getelementptr inbounds %MathMin_type, %MathMin_type* %MathMin_frame, i32 0, i32 1
  %rvalue = load i32, i32* %1
  %2 = getelementptr inbounds %MathMin_type, %MathMin_type* %MathMin_frame, i32 0, i32 2
  %rvalue1 = load i32, i32* %2
  %lt = icmp slt i32 %rvalue, %rvalue1
  %3 = sext i1 %lt to i32
  %ifcond = icmp ne i32 %3, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %entry
  %4 = getelementptr inbounds %MathMin_type, %MathMin_type* %MathMin_frame, i32 0, i32 1
  %rvalue2 = load i32, i32* %4
  ret i32 %rvalue2

elif:                                             ; preds = %entry
  br label %else

else:                                             ; preds = %elif
  %5 = getelementptr inbounds %MathMin_type, %MathMin_type* %MathMin_frame, i32 0, i32 2
  %rvalue3 = load i32, i32* %5
  ret i32 %rvalue3

ifcont:                                           ; No predecessors!
  unreachable
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

loop:                                             ; preds = %ifcont, %entry
  %3 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  %rvalue = load i32, i32* %3
  %4 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 1
  %rvalue1 = load i32, i32* %4
  %eq = icmp eq i32 %rvalue, %rvalue1
  %5 = sext i1 %eq to i32
  %ifcond = icmp ne i32 %5, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  br label %afterloop

elif:                                             ; preds = %loop
  br label %ifcont

ifcont:                                           ; preds = %elif
  %6 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 3
  %fcalltmp2 = call i32 @readInteger()
  store i32 %fcalltmp2, i32* %6
  %7 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 0
  %8 = load %main_type*, %main_type** %7
  %9 = getelementptr inbounds %main_type, %main_type* %8, i32 0, i32 3
  %lvalue_ptr = getelementptr [1001 x i8], [1001 x i8]* %9, i32 0, i32 0
  call void @readString(i32 1001, i8* %lvalue_ptr)
  %10 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %11 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 0
  %12 = load %main_type*, %main_type** %11
  %13 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 3
  %rvalue3 = load i32, i32* %13
  %fcalltmp4 = call i32 @work(%main_type* %12, i32 %rvalue3)
  store i32 %fcalltmp4, i32* %10
  %str_ptr = getelementptr [7 x i8], [7 x i8]* @str, i32 0, i32 0
  call void @writeString(i8* %str_ptr)
  %14 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  %rvalue5 = load i32, i32* %14
  %addtmp = add i32 %rvalue5, 1
  call void @writeInteger(i32 %addtmp)
  %str_ptr6 = getelementptr [3 x i8], [3 x i8]* @str.1, i32 0, i32 0
  call void @writeString(i8* %str_ptr6)
  %15 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 4
  %rvalue7 = load i32, i32* %15
  call void @writeInteger(i32 %rvalue7)
  %str_ptr8 = getelementptr [2 x i8], [2 x i8]* @str.2, i32 0, i32 0
  call void @writeString(i8* %str_ptr8)
  %16 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  %17 = getelementptr inbounds %main2_type, %main2_type* %main2_frame, i32 0, i32 2
  %rvalue9 = load i32, i32* %17
  %addtmp10 = add i32 %rvalue9, 1
  store i32 %addtmp10, i32* %16
  br label %loop

afterloop:                                        ; preds = %then
  ret void
}
