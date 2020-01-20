; ModuleID = 'ir.ll'
source_filename = "dana program"

%main_type = type { [10 x i32], i32, i32 }

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
  call void @writeInteger(i32 3)
  ret void
}

declare void @writeInteger.1(%main_type*, i32)

declare void @writeChar.2(%main_type*, i8)

declare void @writeString.3(%main_type*, i8*)

declare i32 @readInteger.4(%main_type*)
