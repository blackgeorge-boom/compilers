; ModuleID = 'dana program'
source_filename = "dana program"

%main_type = type {}

@str = private unnamed_addr constant [14 x i8] c"Hello world!\0A\00"

define void @main() {
entry:
  %main_frame = alloca %main_type
  %str_ptr = getelementptr [14 x i8], [14 x i8]* @str, i32 0, i32 0
  call void @writeString(i8* %str_ptr)
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
