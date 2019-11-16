; ModuleID = 'dana program'
source_filename = "dana program"

%main_type = type { i32 }

@str = private unnamed_addr constant [6 x i8] c"x > 5\00"
@str.5 = private unnamed_addr constant [6 x i8] c"x < 5\00"
@str.6 = private unnamed_addr constant [6 x i8] c"x = 5\00"

declare void @writeInteger(i32)

declare void @writeChar(i8)

declare void @writeByte(i8)

declare void @writeString(i8*)

declare void @readString(i32, i8*)

declare i32 @readInteger()

declare i8 @readChar()

declare i32 @strlen(i8*)

declare i32 @strcmp(i8*, i8*)

define void @main() {
entry:
  %main_frame = alloca %main_type
  %0 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %fcalltmp = call i32 @readInteger()
  store i32 %fcalltmp, i32* %0
  %1 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %rvalue = load i32, i32* %1
  %gt = icmp sgt i32 %rvalue, 5
  %2 = sext i1 %gt to i32
  %ifcond = icmp ne i32 %2, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %entry
  %str_ptr = getelementptr [6 x i8], [6 x i8]* @str, i32 0, i32 0
  call void @writeString(i8* %str_ptr)
  br label %ifcont

elif:                                             ; preds = %entry
  %3 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %rvalue1 = load i32, i32* %3
  %lt = icmp slt i32 %rvalue1, 5
  %4 = sext i1 %lt to i32
  %elifcond = icmp ne i32 %4, 0
  br i1 %elifcond, label %elifthen, label %elif3

elifthen:                                         ; preds = %elif
  %str_ptr2 = getelementptr [6 x i8], [6 x i8]* @str.5, i32 0, i32 0
  call void @writeString(i8* %str_ptr2)
  br label %ifcont

elif3:                                            ; preds = %elif
  br label %elifcont

elifcont:                                         ; preds = %elif3
  br label %else

else:                                             ; preds = %elifcont
  %str_ptr4 = getelementptr [6 x i8], [6 x i8]* @str.6, i32 0, i32 0
  call void @writeString(i8* %str_ptr4)
  br label %ifcont

ifcont:                                           ; preds = %else, %elifthen, %then
  ret void
}

declare void @writeInteger.1(%main_type*, i32)

declare void @writeChar.2(%main_type*, i8)

declare void @writeString.3(%main_type*, i8*)

declare i32 @readInteger.4(%main_type*)
