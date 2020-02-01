; ModuleID = 'dana program'
source_filename = "dana program"

%main_type = type { i32, i32, i8 }
%foo_type = type { %main_type* }
%bar_type = type { %main_type* }

define void @main() {
entry:
  %main_frame = alloca %main_type
  %0 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  store i32 0, i32* %0
  call void @writeByte(i8 99)
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

define i32 @foo(%main_type* %main_frame) {
entry:
  %foo_frame = alloca %foo_type
  %0 = getelementptr inbounds %foo_type, %foo_type* %foo_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  ret i32 1
}

define i32 @bar(%main_type* %main_frame) {
entry:
  %bar_frame = alloca %bar_type
  %0 = getelementptr inbounds %bar_type, %bar_type* %bar_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %1 = getelementptr inbounds %bar_type, %bar_type* %bar_frame, i32 0, i32 0
  %2 = load %main_type*, %main_type** %1
  %fcalltmp = call i32 @foo(%main_type* %2)
  ret i32 %fcalltmp
}
