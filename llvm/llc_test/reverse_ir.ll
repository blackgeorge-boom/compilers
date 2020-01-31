; ModuleID = 'dana program'
source_filename = "dana program"

%main_type = type { [32 x i8] }
%reverse_type = type { %main_type*, [1 x i8]*, i32, i32 }

@str = private unnamed_addr constant [14 x i8] c"\0A!dlrow olleH\00"

define void @main() {
entry:
  %main_frame = alloca %main_type
  %str_ptr = getelementptr [14 x i8], [14 x i8]* @str, i32 0, i32 0
  call void @reverse(%main_type* %main_frame, i8* %str_ptr)
  %0 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %lvalue_ptr = getelementptr [32 x i8], [32 x i8]* %0, i32 0, i32 0
  call void @writeString(i8* %lvalue_ptr)
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

define void @reverse(%main_type* %main_frame, i8* %s) {
entry:
  %reverse_frame = alloca %reverse_type
  %0 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %s_pos = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 1
  %cast = bitcast i8* %s to [1 x i8]*
  store [1 x i8]* %cast, [1 x i8]** %s_pos
  %1 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 3
  %2 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 1
  %temp = load [1 x i8]*, [1 x i8]** %2
  %lvalue_ptr = getelementptr [1 x i8], [1 x i8]* %temp, i32 0, i32 0
  %fcalltmp = call i32 @strlen(i8* %lvalue_ptr)
  store i32 %fcalltmp, i32* %1
  %3 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 2
  store i32 0, i32* %3
  br label %loop

loop:                                             ; preds = %ifcont, %entry
  %4 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 2
  %rvalue = load i32, i32* %4
  %5 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 3
  %rvalue1 = load i32, i32* %5
  %lt = icmp slt i32 %rvalue, %rvalue1
  %6 = sext i1 %lt to i32
  %ifcond = icmp ne i32 %6, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  %7 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 2
  %rvalue2 = load i32, i32* %7
  %8 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 0
  %9 = load %main_type*, %main_type** %8
  %10 = getelementptr inbounds %main_type, %main_type* %9, i32 0, i32 0
  %lvalue_ptr3 = getelementptr [32 x i8], [32 x i8]* %10, i32 0, i32 %rvalue2
  %11 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 3
  %rvalue4 = load i32, i32* %11
  %12 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 2
  %rvalue5 = load i32, i32* %12
  %subtmp = sub i32 %rvalue4, %rvalue5
  %subtmp6 = sub i32 %subtmp, 1
  %13 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 1
  %temp7 = load [1 x i8]*, [1 x i8]** %13
  %lvalue_ptr8 = getelementptr [1 x i8], [1 x i8]* %temp7, i32 0, i32 %subtmp6
  %rvalue9 = load i8, i8* %lvalue_ptr8
  store i8 %rvalue9, i8* %lvalue_ptr3
  %14 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 2
  %15 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 2
  %rvalue10 = load i32, i32* %15
  %addtmp = add i32 %rvalue10, 1
  store i32 %addtmp, i32* %14
  br label %ifcont

elif:                                             ; preds = %loop
  br label %else

else:                                             ; preds = %elif
  br label %afterloop

ifcont:                                           ; preds = %then
  br label %loop

afterloop:                                        ; preds = %else
  %16 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 2
  %rvalue11 = load i32, i32* %16
  %17 = getelementptr inbounds %reverse_type, %reverse_type* %reverse_frame, i32 0, i32 0
  %18 = load %main_type*, %main_type** %17
  %19 = getelementptr inbounds %main_type, %main_type* %18, i32 0, i32 0
  %lvalue_ptr12 = getelementptr [32 x i8], [32 x i8]* %19, i32 0, i32 %rvalue11
  store i8 0, i8* %lvalue_ptr12
  ret void
}
