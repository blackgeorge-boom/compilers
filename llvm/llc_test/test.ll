; ModuleID = 'dana program'

%main_type = type { i32, i32, i32 }

define void @main() {
entry:
  %main_frame = alloca %main_type
  %0 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  store i32 0, i32* %0
  %1 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %2 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 1
  %rvalue1 = load i32, i32* %2
  %3 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %4 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 2
  %rvalue3 = load i32, i32* %4
  %5 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %6 = getelementptr inbounds %main_type, %main_type* %main_frame, i32 0, i32 0
  %.promoted = load i32, i32* %1, align 1
  br label %loop

loop:                                             ; preds = %ifcont8, %entry
  %rvalue10 = phi i32 [ %addtmp, %ifcont8 ], [ %.promoted, %entry ]
  %ge = icmp sge i32 %rvalue10, %rvalue1
  %7 = sext i1 %ge to i32
  %ifcond = icmp ne i32 %7, 0
  br i1 %ifcond, label %then, label %elif

then:                                             ; preds = %loop
  %rvalue10.lcssa = phi i32 [ %rvalue10, %loop ]
  store i32 %rvalue10.lcssa, i32* %1, align 1
  br label %afterloop

elif:                                             ; preds = %loop
  br label %ifcont

ifcont:                                           ; preds = %elif
  %ge4 = icmp sge i32 %rvalue10, %rvalue3
  %8 = sext i1 %ge4 to i32
  %ifcond5 = icmp ne i32 %8, 0
  br i1 %ifcond5, label %then6, label %elif7

then6:                                            ; preds = %ifcont
  %rvalue10.lcssa11 = phi i32 [ %rvalue10, %ifcont ]
  store i32 %rvalue10.lcssa11, i32* %1, align 1
  br label %afterloop

elif7:                                            ; preds = %ifcont
  br label %ifcont8

ifcont8:                                          ; preds = %elif7
  %addtmp = add i32 %rvalue10, 1
  br label %loop

afterloop:                                        ; preds = %then6, %then
  ret void
}

declare void @writeInteger.1(%main_type*, i32)

declare void @writeChar.2(%main_type*, i8)

declare void @writeString.3(%main_type*, i8*)

declare i32 @readInteger.4(%main_type*)