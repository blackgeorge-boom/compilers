; ModuleID = 'dana program'
source_filename = "dana program"

@str = private unnamed_addr constant [43 x i8] c"Give the coordinates of the first point:\5Cn\00"
@str.3 = private unnamed_addr constant [6 x i8] c"x1 = \00"
@str.4 = private unnamed_addr constant [6 x i8] c"y1 = \00"
@str.5 = private unnamed_addr constant [44 x i8] c"Give the coordinates of the second point:\5Cn\00"
@str.6 = private unnamed_addr constant [6 x i8] c"x2 = \00"
@str.7 = private unnamed_addr constant [6 x i8] c"y2 = \00"
@str.8 = private unnamed_addr constant [31 x i8] c"The length of this segment is \00"
@str.9 = private unnamed_addr constant [3 x i8] c"\5Cn\00"

declare void @writeInteger(i32)

declare void @writeString(i8*)

define void @main() {
entry:
  %l = alloca i32
  %y2 = alloca i32
  %x2 = alloca i32
  %y1 = alloca i32
  %x1 = alloca i32
  store i32 0, i32* %x1
  br label %loop

loop:                                             ; preds = %ifcont, %entry
  call void @writeString(i8* getelementptr inbounds ([43 x i8], [43 x i8]* @str, i32 0, i32 0))
  call void @writeString(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.3, i32 0, i32 0))
  %fcalltmp = call i32 @readInteger()
  store i32 %fcalltmp, i32* %x1
  call void @writeString(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.4, i32 0, i32 0))
  %fcalltmp1 = call i32 @readInteger()
  store i32 %fcalltmp1, i32* %y1
  call void @writeString(i8* getelementptr inbounds ([44 x i8], [44 x i8]* @str.5, i32 0, i32 0))
  call void @writeString(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.6, i32 0, i32 0))
  %fcalltmp2 = call i32 @readInteger()
  store i32 %fcalltmp2, i32* %x2
  call void @writeString(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.7, i32 0, i32 0))
  %fcalltmp3 = call i32 @readInteger()
  store i32 %fcalltmp3, i32* %y2
  %rvalue = load i32, i32* %x1
  %rvalue4 = load i32, i32* %y1
  %rvalue5 = load i32, i32* %x2
  %rvalue6 = load i32, i32* %y2
  %fcalltmp7 = call i32 @length(i32 %rvalue, i32 %rvalue4, i32 %rvalue5, i32 %rvalue6)
  store i32 %fcalltmp7, i32* %l
  call void @writeString(i8* getelementptr inbounds ([31 x i8], [31 x i8]* @str.8, i32 0, i32 0))
  %rvalue8 = load i32, i32* %l
  call void @writeInteger(i32 %rvalue8)
  call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str.9, i32 0, i32 0))
  %rvalue9 = load i32, i32* %l
  %le = icmp sle i32 %rvalue9, 0
  %0 = sext i1 %le to i32
  %ifcond = icmp ne i32 %0, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  br label %afterloop

elif:                                             ; preds = %loop
  br label %ifcont

ifcont:                                           ; preds = %elif
  br label %loop

afterloop:                                        ; preds = %then
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

define i32 @length(i32 %x1, i32 %y1, i32 %x2, i32 %y2) {
entry:
  %dy = alloca i32
  %dx = alloca i32
  %y24 = alloca i32
  %x23 = alloca i32
  %y12 = alloca i32
  %x11 = alloca i32
  store i32 %x1, i32* %x11
  store i32 %y1, i32* %y12
  store i32 %x2, i32* %x23
  store i32 %y2, i32* %y24
  store i32 0, i32* %dx
  %rvalue = load i32, i32* %x11
  %rvalue5 = load i32, i32* %x23
  %subtmp = sub i32 %rvalue, %rvalue5
  store i32 %subtmp, i32* %dx
  %rvalue6 = load i32, i32* %y12
  %rvalue7 = load i32, i32* %y24
  %subtmp8 = sub i32 %rvalue6, %rvalue7
  store i32 %subtmp8, i32* %dy
  %rvalue9 = load i32, i32* %dx
  %rvalue10 = load i32, i32* %dy
  %addtmp = add i32 %rvalue9, %rvalue10
  ret i32 %addtmp
}
