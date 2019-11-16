; ModuleID = 'a.ll'
source_filename = "dana program"

%main_type = type { i32, i32, i32 }

@str = private unnamed_addr constant [8 x i8] c"Limit: \00"
@str.5 = private unnamed_addr constant [9 x i8] c"Primes:\0A\00"
@str.6 = private unnamed_addr constant [2 x i8] c"\0A\00"
@str.7 = private unnamed_addr constant [2 x i8] c"\0A\00"
@str.8 = private unnamed_addr constant [2 x i8] c"\0A\00"
@str.9 = private unnamed_addr constant [2 x i8] c"\0A\00"
@str.10 = private unnamed_addr constant [9 x i8] c"\0ATotal: \00"
@str.11 = private unnamed_addr constant [2 x i8] c"\0A\00"

declare void @writeInteger(i32) local_unnamed_addr

declare void @writeString(i8*) local_unnamed_addr

declare i32 @readInteger() local_unnamed_addr

define void @main() local_unnamed_addr {
entry:
  %main_frame = alloca %main_type, align 8
  tail call void @writeString(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str, i64 0, i64 0))
  %0 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 0
  %fcalltmp = tail call i32 @readInteger()
  store i32 %fcalltmp, i32* %0, align 8
  tail call void @writeString(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @str.5, i64 0, i64 0))
  %1 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2
  store i32 0, i32* %1, align 8
  %ge = icmp sgt i32 %fcalltmp, 1
  br i1 %ge, label %ifcont, label %ifcont12.thread

ifcont:                                           ; preds = %entry
  store i32 1, i32* %1, align 8
  tail call void @writeInteger(i32 2)
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.6, i64 0, i64 0))
  %ge5 = icmp eq i32 %fcalltmp, 2
  br i1 %ge5, label %ifcont12.thread, label %ifcont12

ifcont12.thread:                                  ; preds = %ifcont, %entry
  %2 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 1
  store i32 5, i32* %2, align 4
  br label %afterloop

ifcont12:                                         ; preds = %ifcont
  %rvalue8 = load i32, i32* %1, align 8
  %addtmp9 = add i32 %rvalue8, 1
  store i32 %addtmp9, i32* %1, align 8
  tail call void @writeInteger(i32 3)
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.7, i64 0, i64 0))
  %3 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 1
  store i32 5, i32* %3, align 4
  %gt2 = icmp slt i32 %fcalltmp, 5
  br i1 %gt2, label %afterloop, label %elif17.lr.ph

elif17.lr.ph:                                     ; preds = %ifcont12
  %.promoted = load i32, i32* %1, align 8
  br label %elif17

elif17:                                           ; preds = %elif17.lr.ph, %ifcont44
  %rvalue384 = phi i32 [ %.promoted, %elif17.lr.ph ], [ %rvalue385, %ifcont44 ]
  %storemerge3 = phi i32 [ 5, %elif17.lr.ph ], [ %addtmp46, %ifcont44 ]
  %fcalltmp19 = call i8 @prime(%main_type* nonnull %main_frame, i32 %storemerge3)
  %elifcond = icmp eq i8 %fcalltmp19, 0
  br i1 %elifcond, label %ifcont25, label %elifthen

elifthen:                                         ; preds = %elif17
  %addtmp21 = add i32 %rvalue384, 1
  tail call void @writeInteger(i32 %storemerge3)
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.8, i64 0, i64 0))
  br label %ifcont25

ifcont25:                                         ; preds = %elif17, %elifthen
  %rvalue386 = phi i32 [ %rvalue384, %elif17 ], [ %addtmp21, %elifthen ]
  %addtmp27 = add i32 %storemerge3, 2
  %gt30 = icmp sgt i32 %addtmp27, %fcalltmp
  br i1 %gt30, label %afterloop.sink.split, label %elif33

elif33:                                           ; preds = %ifcont25
  %fcalltmp35 = call i8 @prime(%main_type* nonnull %main_frame, i32 %addtmp27)
  %elifcond36 = icmp eq i8 %fcalltmp35, 0
  br i1 %elifcond36, label %ifcont44, label %elifthen37

elifthen37:                                       ; preds = %elif33
  %addtmp39 = add i32 %rvalue386, 1
  tail call void @writeInteger(i32 %addtmp27)
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.9, i64 0, i64 0))
  br label %ifcont44

ifcont44:                                         ; preds = %elif33, %elifthen37
  %rvalue385 = phi i32 [ %rvalue386, %elif33 ], [ %addtmp39, %elifthen37 ]
  %addtmp46 = add i32 %storemerge3, 6
  %gt = icmp sgt i32 %addtmp46, %fcalltmp
  br i1 %gt, label %afterloop.sink.split, label %elif17

afterloop.sink.split:                             ; preds = %ifcont25, %ifcont44
  %rvalue385.lcssa.sink = phi i32 [ %rvalue385, %ifcont44 ], [ %rvalue386, %ifcont25 ]
  %addtmp46.lcssa.sink = phi i32 [ %addtmp46, %ifcont44 ], [ %addtmp27, %ifcont25 ]
  store i32 %rvalue385.lcssa.sink, i32* %1, align 8
  store i32 %addtmp46.lcssa.sink, i32* %3, align 4
  br label %afterloop

afterloop:                                        ; preds = %ifcont12.thread, %afterloop.sink.split, %ifcont12
  tail call void @writeString(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @str.10, i64 0, i64 0))
  %rvalue48 = load i32, i32* %1, align 8
  tail call void @writeInteger(i32 %rvalue48)
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.11, i64 0, i64 0))
  ret void
}

; Function Attrs: nounwind readnone
define i8 @prime(%main_type* nocapture readnone %main_frame, i32 %n) local_unnamed_addr #0 {
entry:
  br label %tailrecurse

tailrecurse:                                      ; preds = %tailrecurse, %entry
  %n.tr = phi i32 [ %n, %entry ], [ %usubtmp, %tailrecurse ]
  %lt = icmp slt i32 %n.tr, 0
  %usubtmp = sub i32 0, %n.tr
  br i1 %lt, label %tailrecurse, label %elif

elif:                                             ; preds = %tailrecurse
  %lt3 = icmp slt i32 %n.tr, 2
  br i1 %lt3, label %elifthen, label %elif4

elifthen:                                         ; preds = %elif20, %loop, %else, %elif8, %elif4, %elif
  %merge = phi i8 [ 0, %elif ], [ 1, %elif4 ], [ 0, %elif8 ], [ 1, %else ], [ 0, %elif20 ], [ 1, %loop ]
  ret i8 %merge

elif4:                                            ; preds = %elif
  %eq = icmp eq i32 %n.tr, 2
  br i1 %eq, label %elifthen, label %elif8

elif8:                                            ; preds = %elif4
  %modtmp9 = and i32 %n.tr, 1
  %eq10 = icmp eq i32 %modtmp9, 0
  br i1 %eq10, label %elifthen, label %else

else:                                             ; preds = %elif8
  %divtmp13 = lshr i32 %n.tr, 1
  %gt10 = icmp slt i32 %n.tr, 6
  br i1 %gt10, label %elifthen, label %elif20.preheader

elif20.preheader:                                 ; preds = %else
  br label %elif20

loop:                                             ; preds = %elif20
  %gt = icmp sgt i32 %addtmp, %divtmp13
  br i1 %gt, label %elifthen, label %elif20

elif20:                                           ; preds = %elif20.preheader, %loop
  %prime_frame.sroa.10.011 = phi i32 [ %addtmp, %loop ], [ 3, %elif20.preheader ]
  %modtmp23 = srem i32 %n.tr, %prime_frame.sroa.10.011
  %eq24 = icmp eq i32 %modtmp23, 0
  %addtmp = add nuw nsw i32 %prime_frame.sroa.10.011, 2
  br i1 %eq24, label %elifthen, label %loop
}

attributes #0 = { nounwind readnone }
