; ModuleID = 'dana program'
source_filename = "dana program"

%main_type = type { i32 }
%loc_type = type { %main_type*, i32, i32* }

declare void @writeInteger(i32)

declare void @writeString(i8*)

define void @main() {
entry:
  %x = alloca i32
  %main_frame = alloca %main_type
  store i32 0, i32* %x
  %rvalue = load i32, i32* %x
  call void @writeInteger(i32 %rvalue)
  call void @loc(%main_type* %main_frame, i32 3, i32* %x)
  %rvalue1 = load i32, i32* %x
  call void @writeInteger(i32 %rvalue1)
  ret void
}

declare void @writeInteger.1(%main_type*, i32)

define void @loc(%main_type* %main_frame, i32 %n, i32* %m) {
entry:
  %loc_frame = alloca %loc_type
  %n1 = alloca i32
  store i32 %n, i32* %n1
  store i32 1, i32* %m
  ret void
}
