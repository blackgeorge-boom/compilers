; ModuleID = 'dana program'
source_filename = "dana program"

%main_type = type { i32 }
%aux_type = type { %main_type* }
%hanoi_type = type { %main_type*, i32, [1 x i8]*, [1 x i8]*, [1 x i8]* }
%move_type = type { %hanoi_type*, [1 x i8]*, [1 x i8]* }

@str = private unnamed_addr constant [12 x i8] c"Just saying\00"
@str.1 = private unnamed_addr constant [13 x i8] c"Moving from \00"
@str.2 = private unnamed_addr constant [5 x i8] c" to \00"
@str.3 = private unnamed_addr constant [3 x i8] c".\0A\00"
@str.4 = private unnamed_addr constant [8 x i8] c"Rings: \00"
@str.5 = private unnamed_addr constant [5 x i8] c"left\00"
@str.6 = private unnamed_addr constant [6 x i8] c"right\00"
@str.7 = private unnamed_addr constant [7 x i8] c"middle\00"

define void @main() {
entry:
  %main_frame = alloca %main_type
  %str_ptr = getelementptr [8 x i8], [8 x i8]* @str.4, i32 0, i32 0
  call void @writeString(i8* %str_ptr)
  %0 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %fcalltmp = call i32 @readInteger()
  store i32 %fcalltmp, i32* %0
  %1 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %rvalue = load i32, i32* %1
  %str_ptr1 = getelementptr [5 x i8], [5 x i8]* @str.5, i32 0, i32 0
  %str_ptr2 = getelementptr [6 x i8], [6 x i8]* @str.6, i32 0, i32 0
  %str_ptr3 = getelementptr [7 x i8], [7 x i8]* @str.7, i32 0, i32 0
  call void @hanoi(%main_type* %main_frame, i32 %rvalue, i8* %str_ptr1, i8* %str_ptr2, i8* %str_ptr3)
  call void @aux(%main_type* %main_frame)
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

define void @aux(%main_type* %main_frame) {
entry:
  %aux_frame = alloca %aux_type
  %0 = getelementptr inbounds %aux_type, %aux_type* %aux_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %str_ptr = getelementptr [12 x i8], [12 x i8]* @str, i32 0, i32 0
  call void @writeString(i8* %str_ptr)
  ret void
}

define void @hanoi(%main_type* %main_frame, i32 %rings, i8* %source, i8* %target, i8* %auxiliary) {
entry:
  %hanoi_frame = alloca %hanoi_type
  %0 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %rings_pos = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 1
  store i32 %rings, i32* %rings_pos
  %source_pos = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 2
  %cast = bitcast i8* %source to [1 x i8]*
  store [1 x i8]* %cast, [1 x i8]** %source_pos
  %target_pos = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 3
  %cast1 = bitcast i8* %target to [1 x i8]*
  store [1 x i8]* %cast1, [1 x i8]** %target_pos
  %auxiliary_pos = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 4
  %cast2 = bitcast i8* %auxiliary to [1 x i8]*
  store [1 x i8]* %cast2, [1 x i8]** %auxiliary_pos
  %1 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 1
  %rvalue = load i32, i32* %1
  %ge = icmp sge i32 %rvalue, 1
  %2 = sext i1 %ge to i32
  %ifcond = icmp ne i32 %2, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %entry
  %3 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 0
  %4 = load %main_type*, %main_type** %3
  %5 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 1
  %rvalue3 = load i32, i32* %5
  %subtmp = sub i32 %rvalue3, 1
  %6 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 2
  %temp = load [1 x i8]*, [1 x i8]** %6
  %lvalue_ptr = getelementptr [1 x i8], [1 x i8]* %temp, i32 0, i32 0
  %7 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 4
  %temp4 = load [1 x i8]*, [1 x i8]** %7
  %lvalue_ptr5 = getelementptr [1 x i8], [1 x i8]* %temp4, i32 0, i32 0
  %8 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 3
  %temp6 = load [1 x i8]*, [1 x i8]** %8
  %lvalue_ptr7 = getelementptr [1 x i8], [1 x i8]* %temp6, i32 0, i32 0
  call void @hanoi(%main_type* %4, i32 %subtmp, i8* %lvalue_ptr, i8* %lvalue_ptr5, i8* %lvalue_ptr7)
  %9 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 2
  %temp8 = load [1 x i8]*, [1 x i8]** %9
  %lvalue_ptr9 = getelementptr [1 x i8], [1 x i8]* %temp8, i32 0, i32 0
  %10 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 3
  %temp10 = load [1 x i8]*, [1 x i8]** %10
  %lvalue_ptr11 = getelementptr [1 x i8], [1 x i8]* %temp10, i32 0, i32 0
  call void @move(%hanoi_type* %hanoi_frame, i8* %lvalue_ptr9, i8* %lvalue_ptr11)
  %11 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 0
  %12 = load %main_type*, %main_type** %11
  %13 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 1
  %rvalue12 = load i32, i32* %13
  %subtmp13 = sub i32 %rvalue12, 1
  %14 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 4
  %temp14 = load [1 x i8]*, [1 x i8]** %14
  %lvalue_ptr15 = getelementptr [1 x i8], [1 x i8]* %temp14, i32 0, i32 0
  %15 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 3
  %temp16 = load [1 x i8]*, [1 x i8]** %15
  %lvalue_ptr17 = getelementptr [1 x i8], [1 x i8]* %temp16, i32 0, i32 0
  %16 = getelementptr inbounds %hanoi_type, %hanoi_type* %hanoi_frame, i32 0, i32 2
  %temp18 = load [1 x i8]*, [1 x i8]** %16
  %lvalue_ptr19 = getelementptr [1 x i8], [1 x i8]* %temp18, i32 0, i32 0
  call void @hanoi(%main_type* %12, i32 %subtmp13, i8* %lvalue_ptr15, i8* %lvalue_ptr17, i8* %lvalue_ptr19)
  br label %ifcont

elif:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %elif, %then
  ret void
}

define void @move(%hanoi_type* %hanoi_frame, i8* %source, i8* %target) {
entry:
  %move_frame = alloca %move_type
  %0 = getelementptr inbounds %move_type, %move_type* %move_frame, i32 0, i32 0
  store %hanoi_type* %hanoi_frame, %hanoi_type** %0
  %source_pos = getelementptr inbounds %move_type, %move_type* %move_frame, i32 0, i32 1
  %cast = bitcast i8* %source to [1 x i8]*
  store [1 x i8]* %cast, [1 x i8]** %source_pos
  %target_pos = getelementptr inbounds %move_type, %move_type* %move_frame, i32 0, i32 2
  %cast1 = bitcast i8* %target to [1 x i8]*
  store [1 x i8]* %cast1, [1 x i8]** %target_pos
  %str_ptr = getelementptr [13 x i8], [13 x i8]* @str.1, i32 0, i32 0
  call void @writeString(i8* %str_ptr)
  %1 = getelementptr inbounds %move_type, %move_type* %move_frame, i32 0, i32 1
  %temp = load [1 x i8]*, [1 x i8]** %1
  %lvalue_ptr = getelementptr [1 x i8], [1 x i8]* %temp, i32 0, i32 0
  call void @writeString(i8* %lvalue_ptr)
  %str_ptr2 = getelementptr [5 x i8], [5 x i8]* @str.2, i32 0, i32 0
  call void @writeString(i8* %str_ptr2)
  %2 = getelementptr inbounds %move_type, %move_type* %move_frame, i32 0, i32 2
  %temp3 = load [1 x i8]*, [1 x i8]** %2
  %lvalue_ptr4 = getelementptr [1 x i8], [1 x i8]* %temp3, i32 0, i32 0
  call void @writeString(i8* %lvalue_ptr4)
  %str_ptr5 = getelementptr [3 x i8], [3 x i8]* @str.3, i32 0, i32 0
  call void @writeString(i8* %str_ptr5)
  ret void
}
