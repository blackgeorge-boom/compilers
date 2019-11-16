; ModuleID = 'a.ll'
source_filename = "dana program"

%main_type = type { i32, i32, i32 }

@str = private unnamed_addr constant [8 x i8] c"Limit: \00"
@str.5 = private unnamed_addr constant [9 x i8] c"Primes:\0A\00"
@str.10 = private unnamed_addr constant [9 x i8] c"\0ATotal: \00"
@str.11 = private unnamed_addr constant [2 x i8] c"\0A\00"

declare void @writeInteger(i32) local_unnamed_addr

declare void @writeString(i8*) local_unnamed_addr

declare i32 @readInteger() local_unnamed_addr

define void @main() local_unnamed_addr {
entry:
  tail call void @writeString(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str, i64 0, i64 0))
  %fcalltmp = tail call i32 @readInteger()
  tail call void @writeString(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @str.5, i64 0, i64 0))
  %ge = icmp sgt i32 %fcalltmp, 1
  br i1 %ge, label %ifcont, label %afterloop

ifcont:                                           ; preds = %entry
  tail call void @writeInteger(i32 2)
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.11, i64 0, i64 0))
  %ge5 = icmp eq i32 %fcalltmp, 2
  br i1 %ge5, label %afterloop, label %ifcont12

ifcont12:                                         ; preds = %ifcont
  tail call void @writeInteger(i32 3)
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.11, i64 0, i64 0))
  %gt37 = icmp slt i32 %fcalltmp, 5
  br i1 %gt37, label %afterloop, label %elif17.preheader

elif17.preheader:                                 ; preds = %ifcont12
  br label %elif17

elif17:                                           ; preds = %elif17.preheader, %ifcont44
  %storemerge40 = phi i32 [ %addtmp46, %ifcont44 ], [ 5, %elif17.preheader ]
  %main_frame.sroa.11.238 = phi i32 [ %main_frame.sroa.11.4, %ifcont44 ], [ 2, %elif17.preheader ]
  br label %tailrecurse.i

tailrecurse.i:                                    ; preds = %tailrecurse.i, %elif17
  %n.tr.i = phi i32 [ %storemerge40, %elif17 ], [ %usubtmp.i, %tailrecurse.i ]
  %lt.i = icmp slt i32 %n.tr.i, 0
  %usubtmp.i = sub i32 0, %n.tr.i
  br i1 %lt.i, label %tailrecurse.i, label %elif.i

elif.i:                                           ; preds = %tailrecurse.i
  %lt3.i = icmp slt i32 %n.tr.i, 2
  br i1 %lt3.i, label %ifcont25, label %elif4.i

elif4.i:                                          ; preds = %elif.i
  %eq.i = icmp eq i32 %n.tr.i, 2
  br i1 %eq.i, label %elifthen, label %elif8.i

elif8.i:                                          ; preds = %elif4.i
  %modtmp9.i = and i32 %n.tr.i, 1
  %eq10.i = icmp eq i32 %modtmp9.i, 0
  br i1 %eq10.i, label %ifcont25, label %else.i

else.i:                                           ; preds = %elif8.i
  %divtmp13.i = lshr i32 %n.tr.i, 1
  %gt10.i = icmp slt i32 %n.tr.i, 6
  br i1 %gt10.i, label %elifthen, label %elif20.i.preheader

elif20.i.preheader:                               ; preds = %else.i
  br label %elif20.i

loop.i:                                           ; preds = %elif20.i
  %gt.i = icmp sgt i32 %addtmp.i, %divtmp13.i
  br i1 %gt.i, label %elifthen, label %elif20.i

elif20.i:                                         ; preds = %elif20.i.preheader, %loop.i
  %prime_frame.sroa.10.011.i = phi i32 [ %addtmp.i, %loop.i ], [ 3, %elif20.i.preheader ]
  %modtmp23.i = srem i32 %n.tr.i, %prime_frame.sroa.10.011.i
  %eq24.i = icmp eq i32 %modtmp23.i, 0
  %addtmp.i = add nuw nsw i32 %prime_frame.sroa.10.011.i, 2
  br i1 %eq24.i, label %ifcont25, label %loop.i

elifthen:                                         ; preds = %loop.i, %else.i, %elif4.i
  %addtmp21 = add i32 %main_frame.sroa.11.238, 1
  tail call void @writeInteger(i32 %storemerge40)
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.11, i64 0, i64 0))
  br label %ifcont25

ifcont25:                                         ; preds = %elif20.i, %elif8.i, %elif.i, %elifthen
  %main_frame.sroa.11.3 = phi i32 [ %addtmp21, %elifthen ], [ %main_frame.sroa.11.238, %elif.i ], [ %main_frame.sroa.11.238, %elif8.i ], [ %main_frame.sroa.11.238, %elif20.i ]
  %addtmp27 = add i32 %storemerge40, 2
  %gt30 = icmp sgt i32 %addtmp27, %fcalltmp
  br i1 %gt30, label %afterloop, label %tailrecurse.i4.preheader

tailrecurse.i4.preheader:                         ; preds = %ifcont25
  br label %tailrecurse.i4

tailrecurse.i4:                                   ; preds = %tailrecurse.i4.preheader, %tailrecurse.i4
  %n.tr.i1 = phi i32 [ %usubtmp.i3, %tailrecurse.i4 ], [ %addtmp27, %tailrecurse.i4.preheader ]
  %lt.i2 = icmp slt i32 %n.tr.i1, 0
  %usubtmp.i3 = sub i32 0, %n.tr.i1
  br i1 %lt.i2, label %tailrecurse.i4, label %elif.i6

elif.i6:                                          ; preds = %tailrecurse.i4
  %lt3.i5 = icmp slt i32 %n.tr.i1, 2
  br i1 %lt3.i5, label %ifcont44, label %elif4.i9

elif4.i9:                                         ; preds = %elif.i6
  %eq.i8 = icmp eq i32 %n.tr.i1, 2
  br i1 %eq.i8, label %elifthen37, label %elif8.i12

elif8.i12:                                        ; preds = %elif4.i9
  %modtmp9.i10 = and i32 %n.tr.i1, 1
  %eq10.i11 = icmp eq i32 %modtmp9.i10, 0
  br i1 %eq10.i11, label %ifcont44, label %else.i15

else.i15:                                         ; preds = %elif8.i12
  %divtmp13.i13 = lshr i32 %n.tr.i1, 1
  %gt10.i14 = icmp slt i32 %n.tr.i1, 6
  br i1 %gt10.i14, label %elifthen37, label %elif20.i23.preheader

elif20.i23.preheader:                             ; preds = %else.i15
  br label %elif20.i23

loop.i18:                                         ; preds = %elif20.i23
  %gt.i17 = icmp sgt i32 %addtmp.i22, %divtmp13.i13
  br i1 %gt.i17, label %elifthen37, label %elif20.i23

elif20.i23:                                       ; preds = %elif20.i23.preheader, %loop.i18
  %prime_frame.sroa.10.011.i19 = phi i32 [ %addtmp.i22, %loop.i18 ], [ 3, %elif20.i23.preheader ]
  %modtmp23.i20 = srem i32 %n.tr.i1, %prime_frame.sroa.10.011.i19
  %eq24.i21 = icmp eq i32 %modtmp23.i20, 0
  %addtmp.i22 = add nuw nsw i32 %prime_frame.sroa.10.011.i19, 2
  br i1 %eq24.i21, label %ifcont44, label %loop.i18

elifthen37:                                       ; preds = %loop.i18, %else.i15, %elif4.i9
  %addtmp39 = add i32 %main_frame.sroa.11.3, 1
  tail call void @writeInteger(i32 %addtmp27)
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.11, i64 0, i64 0))
  br label %ifcont44

ifcont44:                                         ; preds = %elif20.i23, %elif8.i12, %elif.i6, %elifthen37
  %main_frame.sroa.11.4 = phi i32 [ %addtmp39, %elifthen37 ], [ %main_frame.sroa.11.3, %elif.i6 ], [ %main_frame.sroa.11.3, %elif8.i12 ], [ %main_frame.sroa.11.3, %elif20.i23 ]
  %addtmp46 = add i32 %storemerge40, 6
  %gt = icmp sgt i32 %addtmp46, %fcalltmp
  br i1 %gt, label %afterloop, label %elif17

afterloop:                                        ; preds = %ifcont44, %ifcont25, %entry, %ifcont, %ifcont12
  %main_frame.sroa.11.5 = phi i32 [ 2, %ifcont12 ], [ 0, %entry ], [ 1, %ifcont ], [ %main_frame.sroa.11.3, %ifcont25 ], [ %main_frame.sroa.11.4, %ifcont44 ]
  tail call void @writeString(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @str.10, i64 0, i64 0))
  tail call void @writeInteger(i32 %main_frame.sroa.11.5)
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
