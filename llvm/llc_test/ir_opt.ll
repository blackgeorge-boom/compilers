; ModuleID = 'ir.ll'
source_filename = "dana program"

%main_type = type { [80 x i8] }

@str = private unnamed_addr constant [2 x i8] c"\0A\00"
@str.13 = private unnamed_addr constant [3 x i8] c"* \00"
@str.14 = private unnamed_addr constant [2 x i8] c" \00"
@str.15 = private unnamed_addr constant [3 x i8] c"*\0A\00"
@str.16 = private unnamed_addr constant [5 x i8] c"****\00"
@str.17 = private unnamed_addr constant [4 x i8] c"*\0A\0A\00"
@str.18 = private unnamed_addr constant [22 x i8] c"Please, give a word: \00"
@str.19 = private unnamed_addr constant [6 x i8] c"peace\00"

define void @main() local_unnamed_addr {
entry:
  %main_frame = alloca %main_type, align 8
  call void @writeString(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.18, i64 0, i64 0))
  %lvalue_ptr = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 0, i64 0
  call void @readString(i32 80, i8* nonnull %lvalue_ptr)
  %fcalltmp1 = call i32 @strcmp(i8* nonnull %lvalue_ptr, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.19, i64 0, i64 0))
  %eq2 = icmp eq i32 %fcalltmp1, 0
  br i1 %eq2, label %afterloop, label %ifcont.preheader

ifcont.preheader:                                 ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %ifcont.preheader, %ifcont
  call void @printBoxed(%main_type* undef, i8* nonnull %lvalue_ptr)
  call void @writeString(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.18, i64 0, i64 0))
  call void @readString(i32 80, i8* nonnull %lvalue_ptr)
  %fcalltmp = call i32 @strcmp(i8* nonnull %lvalue_ptr, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.19, i64 0, i64 0))
  %eq = icmp eq i32 %fcalltmp, 0
  br i1 %eq, label %afterloop, label %ifcont

afterloop:                                        ; preds = %ifcont, %entry
  ret void
}

declare void @writeChar(i8) local_unnamed_addr

declare void @writeString(i8*) local_unnamed_addr

declare void @readString(i32, i8*) local_unnamed_addr

; Function Attrs: argmemonly nounwind readonly
declare i32 @strlen(i8* nocapture) local_unnamed_addr #0

; Function Attrs: nounwind readonly
declare i32 @strcmp(i8* nocapture, i8* nocapture) local_unnamed_addr #1

define void @printBoxed(%main_type* nocapture readnone %main_frame, i8* nocapture readonly %word) local_unnamed_addr {
entry:
  %fcalltmp = tail call i32 @strlen(i8* %word)
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str, i64 0, i64 0))
  br label %loop

loop:                                             ; preds = %loop, %entry
  %printBoxed_frame.sroa.12.0 = phi i32 [ 0, %entry ], [ %addtmp, %loop ]
  tail call void @writeString(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.16, i64 0, i64 0))
  %addtmp = add nuw nsw i32 %printBoxed_frame.sroa.12.0, 1
  %ge = icmp slt i32 %addtmp, %fcalltmp
  br i1 %ge, label %loop, label %afterloop

afterloop:                                        ; preds = %loop
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str.15, i64 0, i64 0))
  br label %loop5

loop5:                                            ; preds = %ifcont45, %afterloop
  %printBoxed_frame.sroa.12.1 = phi i32 [ 0, %afterloop ], [ %addtmp48, %ifcont45 ]
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str.13, i64 0, i64 0))
  %0 = sext i32 %printBoxed_frame.sroa.12.1 to i64
  %lvalue_ptr9 = getelementptr i8, i8* %word, i64 %0
  %rvalue10 = load i8, i8* %lvalue_ptr9, align 1
  %le = icmp ult i8 %rvalue10, 91
  br i1 %le, label %then17, label %elif22

then17:                                           ; preds = %loop5
  tail call void @writeChar(i8 %rvalue10)
  br label %ifcont45

elif22:                                           ; preds = %loop5
  %le35 = icmp ult i8 %rvalue10, 123
  br i1 %le35, label %elifthen, label %ifcont45

elifthen:                                         ; preds = %elif22
  %subtmp = add i8 %rvalue10, -32
  tail call void @writeChar(i8 %subtmp)
  br label %ifcont45

ifcont45:                                         ; preds = %elif22, %elifthen, %then17
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.14, i64 0, i64 0))
  %addtmp48 = add nuw nsw i32 %printBoxed_frame.sroa.12.1, 1
  %ge51 = icmp slt i32 %addtmp48, %fcalltmp
  br i1 %ge51, label %loop5, label %afterloop56

afterloop56:                                      ; preds = %ifcont45
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str.15, i64 0, i64 0))
  br label %loop58

loop58:                                           ; preds = %loop58, %afterloop56
  %printBoxed_frame.sroa.12.2 = phi i32 [ 0, %afterloop56 ], [ %addtmp61, %loop58 ]
  tail call void @writeString(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.16, i64 0, i64 0))
  %addtmp61 = add nuw nsw i32 %printBoxed_frame.sroa.12.2, 1
  %ge64 = icmp slt i32 %addtmp61, %fcalltmp
  br i1 %ge64, label %loop58, label %afterloop69

afterloop69:                                      ; preds = %loop58
  tail call void @writeString(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.17, i64 0, i64 0))
  ret void
}

attributes #0 = { argmemonly nounwind readonly }
attributes #1 = { nounwind readonly }
