; ModuleID = 'dana program'
source_filename = "dana program"

%main_type = type { i32 }
%foo_type = type { %main_type*, i32 }
%bar_type = type { %main_type*, i32 }

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
  call void @foo(%main_type* %main_frame, i32 3)
  call void @bar(%main_type* %main_frame, i32 5)
  %0 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %rvalue = load i32, i32* %0
  call void @writeInteger(i32 %rvalue)
  ret void
}

declare void @writeInteger.1(%main_type*, i32)

define void @foo(%main_type* %main_frame, i32 %x) {
entry:
  %foo_frame = alloca %foo_type
  %0 = getelementptr inbounds %foo_type, %foo_type* %foo_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %x_pos = getelementptr inbounds %foo_type, %foo_type* %foo_frame, i32 0, i32 1
  store i32 %x, i32* %x_pos
  %1 = getelementptr inbounds %foo_type, %foo_type* %foo_frame, i32 0, i32 1
  %rvalue = load i32, i32* %1
  call void @writeInteger(i32 %rvalue)
  %2 = getelementptr inbounds %foo_type, %foo_type* %foo_frame, i32 0, i32 0
  %3 = load %main_type*, %main_type** %2
  call void @bar(%main_type* %3, i32 1)
  ret void
}

define void @bar(%main_type* %main_frame, i32 %y) {
entry:
  %bar_frame = alloca %bar_type
  %0 = getelementptr inbounds %bar_type, %bar_type* %bar_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %y_pos = getelementptr inbounds %bar_type, %bar_type* %bar_frame, i32 0, i32 1
  store i32 %y, i32* %y_pos
  %1 = getelementptr inbounds %bar_type, %bar_type* %bar_frame, i32 0, i32 0
  %2 = load %main_type*, %main_type** %1
  %3 = getelementptr inbounds %main_type, %main_type* %2, i32 0, i32 0
  store i32 9, i32* %3
  %4 = getelementptr inbounds %bar_type, %bar_type* %bar_frame, i32 0, i32 0
  %5 = load %main_type*, %main_type** %4
  %6 = getelementptr inbounds %bar_type, %bar_type* %bar_frame, i32 0, i32 1
  %rvalue = load i32, i32* %6
  call void @foo(%main_type* %5, i32 %rvalue)
  ret void
}

declare void @foo.2(%main_type*, i32)
