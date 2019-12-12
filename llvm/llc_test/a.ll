; ModuleID = 'dana program'
source_filename = "dana program"

%main_type = type {}
%fact_type = type { %main_type*, i32 }

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
  %fcalltmp = call i32 @fact(%main_type* %main_frame, i32 100)
  call void @writeInteger(i32 %fcalltmp)
  ret void
}

declare void @writeInteger.1(%main_type*, i32)

declare void @writeChar.2(%main_type*, i8)

declare void @writeString.3(%main_type*, i8*)

declare i32 @readInteger.4(%main_type*)

define i32 @fact(%main_type* %main_frame, i32 %n) {
entry:
  %fact_frame = alloca %fact_type
  %0 = getelementptr inbounds %fact_type, %fact_type* %fact_frame, i32 0, i32 0
  store %main_type* %main_frame, %main_type** %0
  %n_pos = getelementptr inbounds %fact_type, %fact_type* %fact_frame, i32 0, i32 1
  store i32 %n, i32* %n_pos
  %1 = getelementptr inbounds %fact_type, %fact_type* %fact_frame, i32 0, i32 1
  %rvalue = load i32, i32* %1
  %eq = icmp eq i32 %rvalue, 1
  %2 = sext i1 %eq to i32
  %ifcond = icmp ne i32 %2, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %entry
  ret i32 1

elif:                                             ; preds = %entry
  br label %else

else:                                             ; preds = %elif
  %3 = getelementptr inbounds %fact_type, %fact_type* %fact_frame, i32 0, i32 1
  %rvalue1 = load i32, i32* %3
  %4 = getelementptr inbounds %fact_type, %fact_type* %fact_frame, i32 0, i32 0
  %5 = load %main_type*, %main_type** %4
  %6 = getelementptr inbounds %fact_type, %fact_type* %fact_frame, i32 0, i32 1
  %rvalue2 = load i32, i32* %6
  %subtmp = sub i32 %rvalue2, 1
  %fcalltmp = call i32 @fact(%main_type* %5, i32 %subtmp)
  %multmp = mul i32 %rvalue1, %fcalltmp
  ret i32 %multmp

ifcont:                                           ; No predecessors!
  unreachable
}
