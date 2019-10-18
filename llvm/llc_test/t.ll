; ModuleID = 'dana program'
source_filename = "dana program"

@str = private unnamed_addr constant [15 x i8] c"\5Cn!dlrow olleH\00"

declare void @writeInteger(i32)

declare void @writeString(i8*)

define void @main() {
entry:
	%r = alloca [32 x i8]
	call void @reverse(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str, i32 0, i32 0))
	%lvalue_ptr = getelementptr [32 x i8], [32 x i8]* %r, i32 0, i32 0
	call void @writeString(i8* %lvalue_ptr)
	ret void
}

declare void @writeInteger.1(i32)

declare void @writeByte(i8)

declare void @writeChar(i8)

declare void @writeString.2(i8*)

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

define void @reverse(i8* %s) {
entry:
	%l = alloca i32
	%i = alloca i32
	%cast = bitcast i8* %s to [1 x i8]*
	store i32 0, i32* %i
	%lvalue_ptr = getelementptr [1 x i8], [1 x i8]* %cast, i32 0, i32 0
	%fcalltmp = call i32 @strlen(i8* %lvalue_ptr)
	store i32 %fcalltmp, i32* %l
	store i32 0, i32* %i
	br label %loop

	loop:                                             ; preds = %ifcont, %entry
	%rvalue = load i32, i32* %i
	%rvalue1 = load i32, i32* %l
	%lt = icmp slt i32 %rvalue, %rvalue1
	%0 = sext i1 %lt to i32
	%ifcond = icmp ne i32 %0, 0
	br i1 %ifcond, label %then, label %elif

	then:                                             ; preds = %loop
	%rvalue2 = load i32, i32* %i
	%lvalue_ptr3 = getelementptr [32 x i8], [32 x i8]* %r, i32 0, i32 %rvalue2
	%rvalue4 = load i32, i32* %l
	%rvalue5 = load i32, i32* %i
	%subtmp = sub i32 %rvalue4, %rvalue5
	%subtmp6 = sub i32 %subtmp, 1
	%lvalue_ptr7 = getelementptr [1 x i8], [1 x i8]* %cast, i32 0, i32 %subtmp6
	%rvalue8 = load i8, i8* %lvalue_ptr7
	store i8 %rvalue8, i8* %lvalue_ptr3
	%rvalue9 = load i32, i32* %i
	%addtmp = add i32 %rvalue9, 1
	store i32 %addtmp, i32* %i
	br label %ifcont

	elif:                                             ; preds = %loop
	br label %else

	else:                                             ; preds = %elif
		br label %afterloop

		ifcont:                                           ; preds = %then
		br label %loop

		afterloop:                                        ; preds = %else
		%rvalue10 = load i32, i32* %i
		%lvalue_ptr11 = getelementptr [32 x i8], [32 x i8]* %r, i32 0, i32 %rvalue10
		store i8 0, i8* %lvalue_ptr11
		ret void
}

Process finished with exit code 0

