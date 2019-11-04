LogError: Unknown procedure referenced
; ModuleID = 'dana program'
source_filename = "dana program"

%main_type = type { i32 }

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
  ret void
}
