; ModuleID = 'bubble_ir.ll'
source_filename = "dana program"

%main_type = type { i32, i32, [16 x i32] }
%bsort_type = type { %main_type*, i32, [1 x i32]*, i8, i32 }

@str = private unnamed_addr constant [3 x i8] c", \00"
@str.1 = private unnamed_addr constant [2 x i8] c"\0A\00"
@str.2 = private unnamed_addr constant [16 x i8] c"Initial array: \00"
@str.3 = private unnamed_addr constant [15 x i8] c"Sorted array: \00"

define void @main() local_unnamed_addr {
entry:
  %main_frame = alloca %main_type, align 8
  %0 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 0
  store i32 65, i32* %0, align 8
  %1 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 1
  store i32 0, i32* %1, align 4
  store i32 35, i32* %0, align 8
  %lvalue_ptr192 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 0
  store i32 35, i32* %lvalue_ptr192, align 8
  store i32 1, i32* %1, align 4
  br label %then.then_crit_edge

then.then_crit_edge:                              ; preds = %entry, %then.then_crit_edge
  %addtmp7196 = phi i32 [ 1, %entry ], [ %addtmp7, %then.then_crit_edge ]
  %rvalue1.pre = load i32, i32* %0, align 8
  %multmp = mul i32 %rvalue1.pre, 137
  %addtmp = add i32 %addtmp7196, 220
  %addtmp3 = add i32 %addtmp, %multmp
  %modtmp = srem i32 %addtmp3, 101
  store i32 %modtmp, i32* %0, align 8
  %2 = sext i32 %addtmp7196 to i64
  %lvalue_ptr = getelementptr %main_type, %main_type* %main_frame, i64 0, i32 2, i64 %2
  store i32 %modtmp, i32* %lvalue_ptr, align 4
  %rvalue6 = load i32, i32* %1, align 4
  %addtmp7 = add i32 %rvalue6, 1
  store i32 %addtmp7, i32* %1, align 4
  %lt = icmp slt i32 %addtmp7, 16
  br i1 %lt, label %then.then_crit_edge, label %ifcont.i.15

loop.us.i:                                        ; preds = %ifcont.us.i.14, %loop.us.i.outer
  %rvalue4.us5.i.12116 = phi i32 [ %rvalue4.us5.i.11.rvalue8.us.i.12.rvalue4.us5.i.12116, %ifcont.us.i.14 ], [ %rvalue4.us5.i.12117.lcssa148, %loop.us.i.outer ]
  %rvalue4.us5.i.11113 = phi i32 [ %rvalue8.us.i.13.rvalue4.us5.i.11.rvalue4.us5.i.11113, %ifcont.us.i.14 ], [ %rvalue4.us5.i.11114.lcssa146, %loop.us.i.outer ]
  %rvalue4.us5.i.10109 = phi i32 [ %rvalue8.us.i.12.rvalue4.us5.i.10108, %ifcont.us.i.14 ], [ %rvalue4.us5.i.10110.lcssa144, %loop.us.i.outer ]
  %rvalue4.us5.i.9105 = phi i32 [ %rvalue8.us.i.11.rvalue4.us5.i.9.rvalue4.us5.i.9105, %ifcont.us.i.14 ], [ %rvalue4.us5.i.9106.lcssa142, %loop.us.i.outer ]
  %rvalue4.us5.i.8101 = phi i32 [ %rvalue8.us.i.10.rvalue4.us5.i.8100, %ifcont.us.i.14 ], [ %rvalue4.us5.i.8102.lcssa140, %loop.us.i.outer ]
  %rvalue4.us5.i.797 = phi i32 [ %rvalue8.us.i.9.rvalue4.us5.i.7.rvalue4.us5.i.797, %ifcont.us.i.14 ], [ %rvalue4.us5.i.798.lcssa138, %loop.us.i.outer ]
  %rvalue4.us5.i.693 = phi i32 [ %rvalue8.us.i.8.rvalue4.us5.i.692, %ifcont.us.i.14 ], [ %rvalue4.us5.i.694.lcssa136, %loop.us.i.outer ]
  %rvalue4.us5.i.589 = phi i32 [ %rvalue8.us.i.7.rvalue4.us5.i.5.rvalue4.us5.i.589, %ifcont.us.i.14 ], [ %rvalue4.us5.i.590.lcssa134, %loop.us.i.outer ]
  %rvalue4.us5.i.485 = phi i32 [ %rvalue8.us.i.6.rvalue4.us5.i.484, %ifcont.us.i.14 ], [ %rvalue4.us5.i.486.lcssa132, %loop.us.i.outer ]
  %rvalue4.us5.i.381 = phi i32 [ %rvalue8.us.i.5.rvalue4.us5.i.3.rvalue4.us5.i.381, %ifcont.us.i.14 ], [ %rvalue4.us5.i.382.lcssa130, %loop.us.i.outer ]
  %rvalue4.us5.i.277 = phi i32 [ %rvalue8.us.i.4.rvalue4.us5.i.276, %ifcont.us.i.14 ], [ %rvalue4.us5.i.278.lcssa128, %loop.us.i.outer ]
  %rvalue4.us5.i.173 = phi i32 [ %rvalue8.us.i.3.rvalue4.us5.i.1.rvalue4.us5.i.173, %ifcont.us.i.14 ], [ %rvalue4.us5.i.174.lcssa126, %loop.us.i.outer ]
  %rvalue4.us5.i69 = phi i32 [ %rvalue8.us.i.2.rvalue4.us5.i68, %ifcont.us.i.14 ], [ %rvalue4.us5.i70.lcssa124, %loop.us.i.outer ]
  %rvalue4.us.pre.i65 = phi i32 [ %rvalue8.us.i.1.rvalue4.us.pre.i.rvalue4.us.pre.i65, %ifcont.us.i.14 ], [ %rvalue4.us.pre.i66.lcssa122, %loop.us.i.outer ]
  %rvalue8.us.i61 = phi i32 [ %rvalue8.us.i.rvalue8.us.i61, %ifcont.us.i.14 ], [ %rvalue8.us.i62.lcssa120, %loop.us.i.outer ]
  %rvalue8.us.i.13 = phi i32 [ %rvalue4.us5.i.11.rvalue8.us.i.12.rvalue8.us.i.13, %ifcont.us.i.14 ], [ %rvalue8.us.i.13.ph, %loop.us.i.outer ]
  %rvalue8.us.i.12 = phi i32 [ %rvalue8.us.i.13.rvalue4.us5.i.11.rvalue8.us.i.12, %ifcont.us.i.14 ], [ %rvalue8.us.i.12.ph, %loop.us.i.outer ]
  %rvalue8.us.i.11 = phi i32 [ %rvalue8.us.i.12.rvalue4.us5.i.11, %ifcont.us.i.14 ], [ %rvalue8.us.i.11.ph, %loop.us.i.outer ]
  %rvalue8.us.i.10 = phi i32 [ %rvalue8.us.i.11.rvalue4.us5.i.9.rvalue8.us.i.10, %ifcont.us.i.14 ], [ %rvalue8.us.i.10.ph, %loop.us.i.outer ]
  %rvalue8.us.i.9 = phi i32 [ %rvalue8.us.i.10.rvalue4.us5.i.9, %ifcont.us.i.14 ], [ %rvalue8.us.i.9.ph, %loop.us.i.outer ]
  %rvalue8.us.i.8 = phi i32 [ %rvalue8.us.i.9.rvalue4.us5.i.7.rvalue8.us.i.8, %ifcont.us.i.14 ], [ %rvalue8.us.i.8.ph, %loop.us.i.outer ]
  %rvalue8.us.i.7 = phi i32 [ %rvalue8.us.i.8.rvalue4.us5.i.7, %ifcont.us.i.14 ], [ %rvalue8.us.i.7.ph, %loop.us.i.outer ]
  %rvalue8.us.i.6 = phi i32 [ %rvalue8.us.i.7.rvalue4.us5.i.5.rvalue8.us.i.6, %ifcont.us.i.14 ], [ %rvalue8.us.i.6.ph, %loop.us.i.outer ]
  %rvalue8.us.i.5 = phi i32 [ %rvalue8.us.i.6.rvalue4.us5.i.5, %ifcont.us.i.14 ], [ %rvalue8.us.i.5.ph, %loop.us.i.outer ]
  %rvalue8.us.i.4 = phi i32 [ %rvalue8.us.i.5.rvalue4.us5.i.3.rvalue8.us.i.4, %ifcont.us.i.14 ], [ %rvalue8.us.i.4.ph, %loop.us.i.outer ]
  %rvalue8.us.i.3 = phi i32 [ %rvalue8.us.i.4.rvalue4.us5.i.3, %ifcont.us.i.14 ], [ %rvalue8.us.i.3.ph, %loop.us.i.outer ]
  %rvalue8.us.i.2 = phi i32 [ %rvalue8.us.i.3.rvalue4.us5.i.1.rvalue8.us.i.2, %ifcont.us.i.14 ], [ %rvalue8.us.i.2.ph, %loop.us.i.outer ]
  %rvalue8.us.i.1 = phi i32 [ %rvalue8.us.i.2.rvalue4.us5.i.1, %ifcont.us.i.14 ], [ %rvalue8.us.i.1.ph, %loop.us.i.outer ]
  %rvalue8.us.i = phi i32 [ %rvalue8.us.i.1.rvalue4.us.pre.i.rvalue8.us.i, %ifcont.us.i.14 ], [ %rvalue8.us.i.ph, %loop.us.i.outer ]
  %rvalue4.us.pre.i = phi i32 [ %rvalue8.us.i.rvalue4.us.pre.i, %ifcont.us.i.14 ], [ %rvalue4.us.pre.i.ph, %loop.us.i.outer ]
  %gt.us.i = icmp sgt i32 %rvalue4.us.pre.i, %rvalue8.us.i
  %rvalue4.us.pre.i.rvalue4.us.pre.i65 = select i1 %gt.us.i, i32 %rvalue4.us.pre.i, i32 %rvalue4.us.pre.i65
  %rvalue8.us.i.rvalue8.us.i61 = select i1 %gt.us.i, i32 %rvalue8.us.i, i32 %rvalue8.us.i61
  %rvalue8.us.i.rvalue4.us.pre.i = select i1 %gt.us.i, i32 %rvalue8.us.i, i32 %rvalue4.us.pre.i
  %rvalue4.us.pre.i.rvalue8.us.i = select i1 %gt.us.i, i32 %rvalue4.us.pre.i, i32 %rvalue8.us.i
  %gt.us.i.1 = icmp sgt i32 %rvalue4.us.pre.i.rvalue8.us.i, %rvalue8.us.i.1
  %rvalue4.us.pre.i.rvalue8.us.i.rvalue4.us5.i69 = select i1 %gt.us.i.1, i32 %rvalue4.us.pre.i.rvalue8.us.i, i32 %rvalue4.us5.i69
  %rvalue8.us.i.1.rvalue4.us.pre.i.rvalue4.us.pre.i65 = select i1 %gt.us.i.1, i32 %rvalue8.us.i.1, i32 %rvalue4.us.pre.i.rvalue4.us.pre.i65
  %rvalue8.us.i.1.rvalue4.us.pre.i.rvalue8.us.i = select i1 %gt.us.i.1, i32 %rvalue8.us.i.1, i32 %rvalue4.us.pre.i.rvalue8.us.i
  %rvalue4.us.pre.i.rvalue8.us.i.rvalue8.us.i.1 = select i1 %gt.us.i.1, i32 %rvalue4.us.pre.i.rvalue8.us.i, i32 %rvalue8.us.i.1
  %gt.us.i.2 = icmp sgt i32 %rvalue4.us.pre.i.rvalue8.us.i.rvalue8.us.i.1, %rvalue8.us.i.2
  %rvalue4.us5.i.1.rvalue4.us5.i.173 = select i1 %gt.us.i.2, i32 %rvalue4.us.pre.i.rvalue8.us.i.rvalue8.us.i.1, i32 %rvalue4.us5.i.173
  %rvalue8.us.i.2.rvalue4.us5.i68 = select i1 %gt.us.i.2, i32 %rvalue8.us.i.2, i32 %rvalue4.us.pre.i.rvalue8.us.i.rvalue4.us5.i69
  %rvalue8.us.i.2.rvalue4.us5.i.1 = select i1 %gt.us.i.2, i32 %rvalue8.us.i.2, i32 %rvalue4.us.pre.i.rvalue8.us.i.rvalue8.us.i.1
  %rvalue4.us5.i.1.rvalue8.us.i.2 = select i1 %gt.us.i.2, i32 %rvalue4.us.pre.i.rvalue8.us.i.rvalue8.us.i.1, i32 %rvalue8.us.i.2
  %gt.us.i.3 = icmp sgt i32 %rvalue4.us5.i.1.rvalue8.us.i.2, %rvalue8.us.i.3
  %rvalue4.us5.i.1.rvalue8.us.i.2.rvalue4.us5.i.277 = select i1 %gt.us.i.3, i32 %rvalue4.us5.i.1.rvalue8.us.i.2, i32 %rvalue4.us5.i.277
  %rvalue8.us.i.3.rvalue4.us5.i.1.rvalue4.us5.i.173 = select i1 %gt.us.i.3, i32 %rvalue8.us.i.3, i32 %rvalue4.us5.i.1.rvalue4.us5.i.173
  %rvalue8.us.i.3.rvalue4.us5.i.1.rvalue8.us.i.2 = select i1 %gt.us.i.3, i32 %rvalue8.us.i.3, i32 %rvalue4.us5.i.1.rvalue8.us.i.2
  %rvalue4.us5.i.1.rvalue8.us.i.2.rvalue8.us.i.3 = select i1 %gt.us.i.3, i32 %rvalue4.us5.i.1.rvalue8.us.i.2, i32 %rvalue8.us.i.3
  %gt.us.i.4 = icmp sgt i32 %rvalue4.us5.i.1.rvalue8.us.i.2.rvalue8.us.i.3, %rvalue8.us.i.4
  %rvalue4.us5.i.3.rvalue4.us5.i.381 = select i1 %gt.us.i.4, i32 %rvalue4.us5.i.1.rvalue8.us.i.2.rvalue8.us.i.3, i32 %rvalue4.us5.i.381
  %rvalue8.us.i.4.rvalue4.us5.i.276 = select i1 %gt.us.i.4, i32 %rvalue8.us.i.4, i32 %rvalue4.us5.i.1.rvalue8.us.i.2.rvalue4.us5.i.277
  %rvalue8.us.i.4.rvalue4.us5.i.3 = select i1 %gt.us.i.4, i32 %rvalue8.us.i.4, i32 %rvalue4.us5.i.1.rvalue8.us.i.2.rvalue8.us.i.3
  %rvalue4.us5.i.3.rvalue8.us.i.4 = select i1 %gt.us.i.4, i32 %rvalue4.us5.i.1.rvalue8.us.i.2.rvalue8.us.i.3, i32 %rvalue8.us.i.4
  %gt.us.i.5 = icmp sgt i32 %rvalue4.us5.i.3.rvalue8.us.i.4, %rvalue8.us.i.5
  %rvalue4.us5.i.3.rvalue8.us.i.4.rvalue4.us5.i.485 = select i1 %gt.us.i.5, i32 %rvalue4.us5.i.3.rvalue8.us.i.4, i32 %rvalue4.us5.i.485
  %rvalue8.us.i.5.rvalue4.us5.i.3.rvalue4.us5.i.381 = select i1 %gt.us.i.5, i32 %rvalue8.us.i.5, i32 %rvalue4.us5.i.3.rvalue4.us5.i.381
  %rvalue8.us.i.5.rvalue4.us5.i.3.rvalue8.us.i.4 = select i1 %gt.us.i.5, i32 %rvalue8.us.i.5, i32 %rvalue4.us5.i.3.rvalue8.us.i.4
  %rvalue4.us5.i.3.rvalue8.us.i.4.rvalue8.us.i.5 = select i1 %gt.us.i.5, i32 %rvalue4.us5.i.3.rvalue8.us.i.4, i32 %rvalue8.us.i.5
  %gt.us.i.6 = icmp sgt i32 %rvalue4.us5.i.3.rvalue8.us.i.4.rvalue8.us.i.5, %rvalue8.us.i.6
  %rvalue4.us5.i.5.rvalue4.us5.i.589 = select i1 %gt.us.i.6, i32 %rvalue4.us5.i.3.rvalue8.us.i.4.rvalue8.us.i.5, i32 %rvalue4.us5.i.589
  %rvalue8.us.i.6.rvalue4.us5.i.484 = select i1 %gt.us.i.6, i32 %rvalue8.us.i.6, i32 %rvalue4.us5.i.3.rvalue8.us.i.4.rvalue4.us5.i.485
  %rvalue8.us.i.6.rvalue4.us5.i.5 = select i1 %gt.us.i.6, i32 %rvalue8.us.i.6, i32 %rvalue4.us5.i.3.rvalue8.us.i.4.rvalue8.us.i.5
  %rvalue4.us5.i.5.rvalue8.us.i.6 = select i1 %gt.us.i.6, i32 %rvalue4.us5.i.3.rvalue8.us.i.4.rvalue8.us.i.5, i32 %rvalue8.us.i.6
  %gt.us.i.7 = icmp sgt i32 %rvalue4.us5.i.5.rvalue8.us.i.6, %rvalue8.us.i.7
  %rvalue4.us5.i.5.rvalue8.us.i.6.rvalue4.us5.i.693 = select i1 %gt.us.i.7, i32 %rvalue4.us5.i.5.rvalue8.us.i.6, i32 %rvalue4.us5.i.693
  %rvalue8.us.i.7.rvalue4.us5.i.5.rvalue4.us5.i.589 = select i1 %gt.us.i.7, i32 %rvalue8.us.i.7, i32 %rvalue4.us5.i.5.rvalue4.us5.i.589
  %rvalue8.us.i.7.rvalue4.us5.i.5.rvalue8.us.i.6 = select i1 %gt.us.i.7, i32 %rvalue8.us.i.7, i32 %rvalue4.us5.i.5.rvalue8.us.i.6
  %rvalue4.us5.i.5.rvalue8.us.i.6.rvalue8.us.i.7 = select i1 %gt.us.i.7, i32 %rvalue4.us5.i.5.rvalue8.us.i.6, i32 %rvalue8.us.i.7
  %gt.us.i.8 = icmp sgt i32 %rvalue4.us5.i.5.rvalue8.us.i.6.rvalue8.us.i.7, %rvalue8.us.i.8
  %rvalue4.us5.i.7.rvalue4.us5.i.797 = select i1 %gt.us.i.8, i32 %rvalue4.us5.i.5.rvalue8.us.i.6.rvalue8.us.i.7, i32 %rvalue4.us5.i.797
  %rvalue8.us.i.8.rvalue4.us5.i.692 = select i1 %gt.us.i.8, i32 %rvalue8.us.i.8, i32 %rvalue4.us5.i.5.rvalue8.us.i.6.rvalue4.us5.i.693
  %rvalue8.us.i.8.rvalue4.us5.i.7 = select i1 %gt.us.i.8, i32 %rvalue8.us.i.8, i32 %rvalue4.us5.i.5.rvalue8.us.i.6.rvalue8.us.i.7
  %rvalue4.us5.i.7.rvalue8.us.i.8 = select i1 %gt.us.i.8, i32 %rvalue4.us5.i.5.rvalue8.us.i.6.rvalue8.us.i.7, i32 %rvalue8.us.i.8
  %gt.us.i.9 = icmp sgt i32 %rvalue4.us5.i.7.rvalue8.us.i.8, %rvalue8.us.i.9
  %rvalue4.us5.i.7.rvalue8.us.i.8.rvalue4.us5.i.8101 = select i1 %gt.us.i.9, i32 %rvalue4.us5.i.7.rvalue8.us.i.8, i32 %rvalue4.us5.i.8101
  %rvalue8.us.i.9.rvalue4.us5.i.7.rvalue4.us5.i.797 = select i1 %gt.us.i.9, i32 %rvalue8.us.i.9, i32 %rvalue4.us5.i.7.rvalue4.us5.i.797
  %rvalue8.us.i.9.rvalue4.us5.i.7.rvalue8.us.i.8 = select i1 %gt.us.i.9, i32 %rvalue8.us.i.9, i32 %rvalue4.us5.i.7.rvalue8.us.i.8
  %rvalue4.us5.i.7.rvalue8.us.i.8.rvalue8.us.i.9 = select i1 %gt.us.i.9, i32 %rvalue4.us5.i.7.rvalue8.us.i.8, i32 %rvalue8.us.i.9
  %gt.us.i.10 = icmp sgt i32 %rvalue4.us5.i.7.rvalue8.us.i.8.rvalue8.us.i.9, %rvalue8.us.i.10
  %rvalue4.us5.i.9.rvalue4.us5.i.9105 = select i1 %gt.us.i.10, i32 %rvalue4.us5.i.7.rvalue8.us.i.8.rvalue8.us.i.9, i32 %rvalue4.us5.i.9105
  %rvalue8.us.i.10.rvalue4.us5.i.8100 = select i1 %gt.us.i.10, i32 %rvalue8.us.i.10, i32 %rvalue4.us5.i.7.rvalue8.us.i.8.rvalue4.us5.i.8101
  %rvalue8.us.i.10.rvalue4.us5.i.9 = select i1 %gt.us.i.10, i32 %rvalue8.us.i.10, i32 %rvalue4.us5.i.7.rvalue8.us.i.8.rvalue8.us.i.9
  %rvalue4.us5.i.9.rvalue8.us.i.10 = select i1 %gt.us.i.10, i32 %rvalue4.us5.i.7.rvalue8.us.i.8.rvalue8.us.i.9, i32 %rvalue8.us.i.10
  %gt.us.i.11 = icmp sgt i32 %rvalue4.us5.i.9.rvalue8.us.i.10, %rvalue8.us.i.11
  %rvalue4.us5.i.9.rvalue8.us.i.10.rvalue4.us5.i.10109 = select i1 %gt.us.i.11, i32 %rvalue4.us5.i.9.rvalue8.us.i.10, i32 %rvalue4.us5.i.10109
  %rvalue8.us.i.11.rvalue4.us5.i.9.rvalue4.us5.i.9105 = select i1 %gt.us.i.11, i32 %rvalue8.us.i.11, i32 %rvalue4.us5.i.9.rvalue4.us5.i.9105
  %rvalue8.us.i.11.rvalue4.us5.i.9.rvalue8.us.i.10 = select i1 %gt.us.i.11, i32 %rvalue8.us.i.11, i32 %rvalue4.us5.i.9.rvalue8.us.i.10
  %rvalue4.us5.i.9.rvalue8.us.i.10.rvalue8.us.i.11 = select i1 %gt.us.i.11, i32 %rvalue4.us5.i.9.rvalue8.us.i.10, i32 %rvalue8.us.i.11
  %gt.us.i.12 = icmp sgt i32 %rvalue4.us5.i.9.rvalue8.us.i.10.rvalue8.us.i.11, %rvalue8.us.i.12
  %rvalue4.us5.i.11.rvalue4.us5.i.11113 = select i1 %gt.us.i.12, i32 %rvalue4.us5.i.9.rvalue8.us.i.10.rvalue8.us.i.11, i32 %rvalue4.us5.i.11113
  %rvalue8.us.i.12.rvalue4.us5.i.10108 = select i1 %gt.us.i.12, i32 %rvalue8.us.i.12, i32 %rvalue4.us5.i.9.rvalue8.us.i.10.rvalue4.us5.i.10109
  %rvalue8.us.i.12.rvalue4.us5.i.11 = select i1 %gt.us.i.12, i32 %rvalue8.us.i.12, i32 %rvalue4.us5.i.9.rvalue8.us.i.10.rvalue8.us.i.11
  %rvalue4.us5.i.11.rvalue8.us.i.12 = select i1 %gt.us.i.12, i32 %rvalue4.us5.i.9.rvalue8.us.i.10.rvalue8.us.i.11, i32 %rvalue8.us.i.12
  %gt.us.i.13 = icmp sgt i32 %rvalue4.us5.i.11.rvalue8.us.i.12, %rvalue8.us.i.13
  %rvalue4.us5.i.11.rvalue8.us.i.12.rvalue4.us5.i.12116 = select i1 %gt.us.i.13, i32 %rvalue4.us5.i.11.rvalue8.us.i.12, i32 %rvalue4.us5.i.12116
  %rvalue8.us.i.13.rvalue4.us5.i.11.rvalue4.us5.i.11113 = select i1 %gt.us.i.13, i32 %rvalue8.us.i.13, i32 %rvalue4.us5.i.11.rvalue4.us5.i.11113
  %rvalue8.us.i.13.rvalue4.us5.i.11.rvalue8.us.i.12 = select i1 %gt.us.i.13, i32 %rvalue8.us.i.13, i32 %rvalue4.us5.i.11.rvalue8.us.i.12
  %rvalue4.us5.i.11.rvalue8.us.i.12.rvalue8.us.i.13 = select i1 %gt.us.i.13, i32 %rvalue4.us5.i.11.rvalue8.us.i.12, i32 %rvalue8.us.i.13
  %gt.us.i.14 = icmp sgt i32 %rvalue4.us5.i.11.rvalue8.us.i.12.rvalue8.us.i.13, %rvalue8.us.i.14.ph
  br i1 %gt.us.i.14, label %loop.us.i.outer.loopexit, label %ifcont.us.i.14

ifcont.i9.15:                                     ; preds = %ifcont.us.i.14
  store i32 %rvalue8.us.i62.lcssa120, i32* %lvalue_ptr8.i, align 8
  store i32 %rvalue4.us.pre.i66.lcssa122, i32* %lvalue_ptr8.i.1, align 4
  store i32 %rvalue4.us5.i70.lcssa124, i32* %lvalue_ptr8.i.2, align 8
  store i32 %rvalue4.us5.i.174.lcssa126, i32* %lvalue_ptr8.i.3, align 4
  store i32 %rvalue4.us5.i.278.lcssa128, i32* %lvalue_ptr8.i.4, align 8
  store i32 %rvalue4.us5.i.382.lcssa130, i32* %lvalue_ptr8.i.5, align 4
  store i32 %rvalue4.us5.i.486.lcssa132, i32* %lvalue_ptr8.i.6, align 8
  store i32 %rvalue4.us5.i.590.lcssa134, i32* %lvalue_ptr8.i.7, align 4
  store i32 %rvalue4.us5.i.694.lcssa136, i32* %lvalue_ptr8.i.8, align 8
  store i32 %rvalue4.us5.i.798.lcssa138, i32* %lvalue_ptr8.i.9, align 4
  store i32 %rvalue4.us5.i.8102.lcssa140, i32* %lvalue_ptr8.i.10, align 8
  store i32 %rvalue4.us5.i.9106.lcssa142, i32* %lvalue_ptr8.i.11, align 4
  store i32 %rvalue4.us5.i.10110.lcssa144, i32* %lvalue_ptr8.i.12, align 8
  store i32 %rvalue4.us5.i.11114.lcssa146, i32* %lvalue_ptr8.i.13, align 4
  store i32 %rvalue4.us5.i.12117.lcssa148, i32* %lvalue_ptr8.i.14, align 8
  store i32 %rvalue4.us5.i.13.lcssa149, i32* %lvalue_ptr8.i.15, align 4
  store i32 %rvalue8.us.i.rvalue8.us.i61, i32* %lvalue_ptr8.i, align 8
  store i32 %rvalue8.us.i.1.rvalue4.us.pre.i.rvalue4.us.pre.i65, i32* %lvalue_ptr8.i.1, align 4
  store i32 %rvalue8.us.i.2.rvalue4.us5.i68, i32* %lvalue_ptr8.i.2, align 8
  store i32 %rvalue8.us.i.3.rvalue4.us5.i.1.rvalue4.us5.i.173, i32* %lvalue_ptr8.i.3, align 4
  store i32 %rvalue8.us.i.4.rvalue4.us5.i.276, i32* %lvalue_ptr8.i.4, align 8
  store i32 %rvalue8.us.i.5.rvalue4.us5.i.3.rvalue4.us5.i.381, i32* %lvalue_ptr8.i.5, align 4
  store i32 %rvalue8.us.i.6.rvalue4.us5.i.484, i32* %lvalue_ptr8.i.6, align 8
  store i32 %rvalue8.us.i.7.rvalue4.us5.i.5.rvalue4.us5.i.589, i32* %lvalue_ptr8.i.7, align 4
  store i32 %rvalue8.us.i.8.rvalue4.us5.i.692, i32* %lvalue_ptr8.i.8, align 8
  store i32 %rvalue8.us.i.9.rvalue4.us5.i.7.rvalue4.us5.i.797, i32* %lvalue_ptr8.i.9, align 4
  store i32 %rvalue8.us.i.10.rvalue4.us5.i.8100, i32* %lvalue_ptr8.i.10, align 8
  store i32 %rvalue8.us.i.11.rvalue4.us5.i.9.rvalue4.us5.i.9105, i32* %lvalue_ptr8.i.11, align 4
  store i32 %rvalue8.us.i.12.rvalue4.us5.i.10108, i32* %lvalue_ptr8.i.12, align 8
  store i32 %rvalue8.us.i.13.rvalue4.us5.i.11.rvalue4.us5.i.11113, i32* %lvalue_ptr8.i.13, align 4
  store i32 %rvalue4.us5.i.11.rvalue8.us.i.12.rvalue4.us5.i.12116, i32* %lvalue_ptr8.i.14, align 8
  tail call void @writeString(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.3, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.rvalue4.us.pre.i)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.1.rvalue4.us.pre.i.rvalue8.us.i)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.2.rvalue4.us5.i.1)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.3.rvalue4.us5.i.1.rvalue8.us.i.2)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.4.rvalue4.us5.i.3)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.5.rvalue4.us5.i.3.rvalue8.us.i.4)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.6.rvalue4.us5.i.5)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.7.rvalue4.us5.i.5.rvalue8.us.i.6)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.8.rvalue4.us5.i.7)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.9.rvalue4.us5.i.7.rvalue8.us.i.8)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.10.rvalue4.us5.i.9)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.11.rvalue4.us5.i.9.rvalue8.us.i.10)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.12.rvalue4.us5.i.11)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.13.rvalue4.us5.i.11.rvalue8.us.i.12)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue4.us5.i.11.rvalue8.us.i.12.rvalue8.us.i.13)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  tail call void @writeInteger(i32 %rvalue8.us.i.14.ph)
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.1, i64 0, i64 0))
  ret void

loop.us.i.outer.loopexit:                         ; preds = %loop.us.i
  br label %loop.us.i.outer

loop.us.i.outer:                                  ; preds = %loop.us.i.outer.loopexit, %ifcont.i.15
  %rvalue4.us5.i.13.lcssa149 = phi i32 [ %lvalue_ptr8.i.15.promoted, %ifcont.i.15 ], [ %rvalue4.us5.i.11.rvalue8.us.i.12.rvalue8.us.i.13, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i.12117.lcssa148 = phi i32 [ %lvalue_ptr8.i.14.promoted147, %ifcont.i.15 ], [ %rvalue8.us.i.14.ph, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i.11114.lcssa146 = phi i32 [ %lvalue_ptr8.i.13.promoted145, %ifcont.i.15 ], [ %rvalue8.us.i.13.rvalue4.us5.i.11.rvalue4.us5.i.11113, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i.10110.lcssa144 = phi i32 [ %lvalue_ptr8.i.12.promoted143, %ifcont.i.15 ], [ %rvalue8.us.i.12.rvalue4.us5.i.10108, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i.9106.lcssa142 = phi i32 [ %lvalue_ptr8.i.11.promoted141, %ifcont.i.15 ], [ %rvalue8.us.i.11.rvalue4.us5.i.9.rvalue4.us5.i.9105, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i.8102.lcssa140 = phi i32 [ %lvalue_ptr8.i.10.promoted139, %ifcont.i.15 ], [ %rvalue8.us.i.10.rvalue4.us5.i.8100, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i.798.lcssa138 = phi i32 [ %lvalue_ptr8.i.9.promoted137, %ifcont.i.15 ], [ %rvalue8.us.i.9.rvalue4.us5.i.7.rvalue4.us5.i.797, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i.694.lcssa136 = phi i32 [ %lvalue_ptr8.i.8.promoted135, %ifcont.i.15 ], [ %rvalue8.us.i.8.rvalue4.us5.i.692, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i.590.lcssa134 = phi i32 [ %lvalue_ptr8.i.7.promoted133, %ifcont.i.15 ], [ %rvalue8.us.i.7.rvalue4.us5.i.5.rvalue4.us5.i.589, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i.486.lcssa132 = phi i32 [ %lvalue_ptr8.i.6.promoted131, %ifcont.i.15 ], [ %rvalue8.us.i.6.rvalue4.us5.i.484, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i.382.lcssa130 = phi i32 [ %lvalue_ptr8.i.5.promoted129, %ifcont.i.15 ], [ %rvalue8.us.i.5.rvalue4.us5.i.3.rvalue4.us5.i.381, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i.278.lcssa128 = phi i32 [ %lvalue_ptr8.i.4.promoted127, %ifcont.i.15 ], [ %rvalue8.us.i.4.rvalue4.us5.i.276, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i.174.lcssa126 = phi i32 [ %lvalue_ptr8.i.3.promoted125, %ifcont.i.15 ], [ %rvalue8.us.i.3.rvalue4.us5.i.1.rvalue4.us5.i.173, %loop.us.i.outer.loopexit ]
  %rvalue4.us5.i70.lcssa124 = phi i32 [ %lvalue_ptr8.i.2.promoted123, %ifcont.i.15 ], [ %rvalue8.us.i.2.rvalue4.us5.i68, %loop.us.i.outer.loopexit ]
  %rvalue4.us.pre.i66.lcssa122 = phi i32 [ %lvalue_ptr8.i.1.promoted121, %ifcont.i.15 ], [ %rvalue8.us.i.1.rvalue4.us.pre.i.rvalue4.us.pre.i65, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i62.lcssa120 = phi i32 [ %lvalue_ptr8.i.promoted119, %ifcont.i.15 ], [ %rvalue8.us.i.rvalue8.us.i61, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.14.ph = phi i32 [ %rvalue9.i.15, %ifcont.i.15 ], [ %rvalue4.us5.i.11.rvalue8.us.i.12.rvalue8.us.i.13, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.13.ph = phi i32 [ %rvalue9.i.14, %ifcont.i.15 ], [ %rvalue8.us.i.14.ph, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.12.ph = phi i32 [ %rvalue9.i.13, %ifcont.i.15 ], [ %rvalue8.us.i.13.rvalue4.us5.i.11.rvalue8.us.i.12, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.11.ph = phi i32 [ %rvalue9.i.12, %ifcont.i.15 ], [ %rvalue8.us.i.12.rvalue4.us5.i.11, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.10.ph = phi i32 [ %rvalue9.i.11, %ifcont.i.15 ], [ %rvalue8.us.i.11.rvalue4.us5.i.9.rvalue8.us.i.10, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.9.ph = phi i32 [ %rvalue9.i.10, %ifcont.i.15 ], [ %rvalue8.us.i.10.rvalue4.us5.i.9, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.8.ph = phi i32 [ %rvalue9.i.9, %ifcont.i.15 ], [ %rvalue8.us.i.9.rvalue4.us5.i.7.rvalue8.us.i.8, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.7.ph = phi i32 [ %rvalue9.i.8, %ifcont.i.15 ], [ %rvalue8.us.i.8.rvalue4.us5.i.7, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.6.ph = phi i32 [ %rvalue9.i.7, %ifcont.i.15 ], [ %rvalue8.us.i.7.rvalue4.us5.i.5.rvalue8.us.i.6, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.5.ph = phi i32 [ %rvalue9.i.6, %ifcont.i.15 ], [ %rvalue8.us.i.6.rvalue4.us5.i.5, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.4.ph = phi i32 [ %rvalue9.i.5, %ifcont.i.15 ], [ %rvalue8.us.i.5.rvalue4.us5.i.3.rvalue8.us.i.4, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.3.ph = phi i32 [ %rvalue9.i.4, %ifcont.i.15 ], [ %rvalue8.us.i.4.rvalue4.us5.i.3, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.2.ph = phi i32 [ %rvalue9.i.3, %ifcont.i.15 ], [ %rvalue8.us.i.3.rvalue4.us5.i.1.rvalue8.us.i.2, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.1.ph = phi i32 [ %rvalue9.i.2, %ifcont.i.15 ], [ %rvalue8.us.i.2.rvalue4.us5.i.1, %loop.us.i.outer.loopexit ]
  %rvalue8.us.i.ph = phi i32 [ %rvalue9.i.1, %ifcont.i.15 ], [ %rvalue8.us.i.1.rvalue4.us.pre.i.rvalue8.us.i, %loop.us.i.outer.loopexit ]
  %rvalue4.us.pre.i.ph = phi i32 [ %rvalue9.i, %ifcont.i.15 ], [ %rvalue8.us.i.rvalue4.us.pre.i, %loop.us.i.outer.loopexit ]
  br label %loop.us.i

ifcont.us.i.14:                                   ; preds = %loop.us.i
  %narrow = or i1 %gt.us.i.1, %gt.us.i
  %narrow150 = or i1 %gt.us.i.2, %narrow
  %narrow151 = or i1 %gt.us.i.3, %narrow150
  %narrow152 = or i1 %gt.us.i.4, %narrow151
  %narrow153 = or i1 %gt.us.i.5, %narrow152
  %narrow154 = or i1 %gt.us.i.6, %narrow153
  %narrow155 = or i1 %gt.us.i.7, %narrow154
  %narrow156 = or i1 %gt.us.i.8, %narrow155
  %narrow157 = or i1 %gt.us.i.9, %narrow156
  %narrow158 = or i1 %gt.us.i.10, %narrow157
  %narrow159 = or i1 %gt.us.i.11, %narrow158
  %narrow160 = or i1 %gt.us.i.12, %narrow159
  %narrow161 = or i1 %gt.us.i.13, %narrow160
  br i1 %narrow161, label %loop.us.i, label %ifcont.i9.15

ifcont.i.15:                                      ; preds = %then.then_crit_edge
  tail call void @writeString(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.2, i64 0, i64 0))
  %lvalue_ptr8.i = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 0
  %rvalue9.i = load i32, i32* %lvalue_ptr8.i, align 8
  tail call void @writeInteger(i32 %rvalue9.i)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.1 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 1
  %rvalue9.i.1 = load i32, i32* %lvalue_ptr8.i.1, align 4
  tail call void @writeInteger(i32 %rvalue9.i.1)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.2 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 2
  %rvalue9.i.2 = load i32, i32* %lvalue_ptr8.i.2, align 8
  tail call void @writeInteger(i32 %rvalue9.i.2)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.3 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 3
  %rvalue9.i.3 = load i32, i32* %lvalue_ptr8.i.3, align 4
  tail call void @writeInteger(i32 %rvalue9.i.3)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.4 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 4
  %rvalue9.i.4 = load i32, i32* %lvalue_ptr8.i.4, align 8
  tail call void @writeInteger(i32 %rvalue9.i.4)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.5 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 5
  %rvalue9.i.5 = load i32, i32* %lvalue_ptr8.i.5, align 4
  tail call void @writeInteger(i32 %rvalue9.i.5)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.6 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 6
  %rvalue9.i.6 = load i32, i32* %lvalue_ptr8.i.6, align 8
  tail call void @writeInteger(i32 %rvalue9.i.6)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.7 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 7
  %rvalue9.i.7 = load i32, i32* %lvalue_ptr8.i.7, align 4
  tail call void @writeInteger(i32 %rvalue9.i.7)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.8 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 8
  %rvalue9.i.8 = load i32, i32* %lvalue_ptr8.i.8, align 8
  tail call void @writeInteger(i32 %rvalue9.i.8)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.9 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 9
  %rvalue9.i.9 = load i32, i32* %lvalue_ptr8.i.9, align 4
  tail call void @writeInteger(i32 %rvalue9.i.9)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.10 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 10
  %rvalue9.i.10 = load i32, i32* %lvalue_ptr8.i.10, align 8
  tail call void @writeInteger(i32 %rvalue9.i.10)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.11 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 11
  %rvalue9.i.11 = load i32, i32* %lvalue_ptr8.i.11, align 4
  tail call void @writeInteger(i32 %rvalue9.i.11)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.12 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 12
  %rvalue9.i.12 = load i32, i32* %lvalue_ptr8.i.12, align 8
  tail call void @writeInteger(i32 %rvalue9.i.12)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.13 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 13
  %rvalue9.i.13 = load i32, i32* %lvalue_ptr8.i.13, align 4
  tail call void @writeInteger(i32 %rvalue9.i.13)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.14 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 14
  %rvalue9.i.14 = load i32, i32* %lvalue_ptr8.i.14, align 8
  tail call void @writeInteger(i32 %rvalue9.i.14)
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  %lvalue_ptr8.i.15 = getelementptr inbounds %main_type, %main_type* %main_frame, i64 0, i32 2, i64 15
  %rvalue9.i.15 = load i32, i32* %lvalue_ptr8.i.15, align 4
  tail call void @writeInteger(i32 %rvalue9.i.15)
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.1, i64 0, i64 0))
  %lvalue_ptr8.i.promoted119 = load i32, i32* %lvalue_ptr8.i, align 8
  %lvalue_ptr8.i.1.promoted121 = load i32, i32* %lvalue_ptr8.i.1, align 4
  %lvalue_ptr8.i.2.promoted123 = load i32, i32* %lvalue_ptr8.i.2, align 8
  %lvalue_ptr8.i.3.promoted125 = load i32, i32* %lvalue_ptr8.i.3, align 4
  %lvalue_ptr8.i.4.promoted127 = load i32, i32* %lvalue_ptr8.i.4, align 8
  %lvalue_ptr8.i.5.promoted129 = load i32, i32* %lvalue_ptr8.i.5, align 4
  %lvalue_ptr8.i.6.promoted131 = load i32, i32* %lvalue_ptr8.i.6, align 8
  %lvalue_ptr8.i.7.promoted133 = load i32, i32* %lvalue_ptr8.i.7, align 4
  %lvalue_ptr8.i.8.promoted135 = load i32, i32* %lvalue_ptr8.i.8, align 8
  %lvalue_ptr8.i.9.promoted137 = load i32, i32* %lvalue_ptr8.i.9, align 4
  %lvalue_ptr8.i.10.promoted139 = load i32, i32* %lvalue_ptr8.i.10, align 8
  %lvalue_ptr8.i.11.promoted141 = load i32, i32* %lvalue_ptr8.i.11, align 4
  %lvalue_ptr8.i.12.promoted143 = load i32, i32* %lvalue_ptr8.i.12, align 8
  %lvalue_ptr8.i.13.promoted145 = load i32, i32* %lvalue_ptr8.i.13, align 4
  %lvalue_ptr8.i.14.promoted147 = load i32, i32* %lvalue_ptr8.i.14, align 8
  %lvalue_ptr8.i.15.promoted = load i32, i32* %lvalue_ptr8.i.15, align 4
  br label %loop.us.i.outer
}

declare void @writeInteger(i32) local_unnamed_addr

declare void @writeString(i8*) local_unnamed_addr

; Function Attrs: norecurse nounwind
define void @bsort(%main_type* %main_frame, i32 %n, i32* %x) local_unnamed_addr #0 {
entry:
  %subtmp = add i32 %n, -1
  %lt1 = icmp sgt i32 %subtmp, 0
  br i1 %lt1, label %loop.us.preheader, label %afterloop27

loop.us.preheader:                                ; preds = %entry
  br label %loop.us

loop.us:                                          ; preds = %loop.us.preheader, %loop1.afterloop_crit_edge.us
  %rvalue4.us.pre = load i32, i32* %x, align 4
  br label %then.us

then.us:                                          ; preds = %loop.us, %ifcont.us
  %rvalue4.us = phi i32 [ %rvalue4.us.pre, %loop.us ], [ %rvalue4.us5, %ifcont.us ]
  %storemerge3.us = phi i32 [ 0, %loop.us ], [ %addtmp.us, %ifcont.us ]
  %bsort_frame.sroa.5.02.us = phi i8 [ 0, %loop.us ], [ %bsort_frame.sroa.5.1.us, %ifcont.us ]
  %addtmp.us = add nuw nsw i32 %storemerge3.us, 1
  %0 = sext i32 %addtmp.us to i64
  %lvalue_ptr7.us = getelementptr i32, i32* %x, i64 %0
  %rvalue8.us = load i32, i32* %lvalue_ptr7.us, align 4
  %gt.us = icmp sgt i32 %rvalue4.us, %rvalue8.us
  br i1 %gt.us, label %then10.us, label %ifcont.us

then10.us:                                        ; preds = %then.us
  %1 = sext i32 %storemerge3.us to i64
  %lvalue_ptr.us = getelementptr i32, i32* %x, i64 %1
  store i32 %rvalue8.us, i32* %lvalue_ptr.us, align 4
  store i32 %rvalue4.us, i32* %lvalue_ptr7.us, align 4
  br label %ifcont.us

ifcont.us:                                        ; preds = %then10.us, %then.us
  %rvalue4.us5 = phi i32 [ %rvalue4.us, %then10.us ], [ %rvalue8.us, %then.us ]
  %bsort_frame.sroa.5.1.us = phi i8 [ 1, %then10.us ], [ %bsort_frame.sroa.5.02.us, %then.us ]
  %lt.us = icmp slt i32 %addtmp.us, %subtmp
  br i1 %lt.us, label %then.us, label %loop1.afterloop_crit_edge.us

loop1.afterloop_crit_edge.us:                     ; preds = %ifcont.us
  %inttobit.us = icmp eq i8 %bsort_frame.sroa.5.1.us, 0
  br i1 %inttobit.us, label %afterloop27, label %loop.us

afterloop27:                                      ; preds = %loop1.afterloop_crit_edge.us, %entry
  ret void
}

; Function Attrs: norecurse nounwind
define void @swap(%bsort_type* nocapture readnone %bsort_frame, i32* nocapture %x, i32* nocapture %y) local_unnamed_addr #0 {
entry:
  %rvalue = load i32, i32* %x, align 4
  %rvalue3 = load i32, i32* %y, align 4
  store i32 %rvalue3, i32* %x, align 4
  store i32 %rvalue, i32* %y, align 4
  ret void
}

define void @writeArray(%main_type* nocapture readnone %main_frame, i8* %msg, i32 %n, i32* nocapture readonly %x) local_unnamed_addr {
entry:
  tail call void @writeString(i8* %msg)
  %lt4 = icmp sgt i32 %n, 0
  br i1 %lt4, label %then.preheader, label %afterloop

then.preheader:                                   ; preds = %entry
  br label %then

then:                                             ; preds = %then.preheader, %ifcont
  %writeArray_frame.sroa.7.05 = phi i32 [ %addtmp, %ifcont ], [ 0, %then.preheader ]
  %gt = icmp eq i32 %writeArray_frame.sroa.7.05, 0
  br i1 %gt, label %ifcont, label %then5

then5:                                            ; preds = %then
  tail call void @writeString(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str, i64 0, i64 0))
  br label %ifcont

ifcont:                                           ; preds = %then, %then5
  %0 = sext i32 %writeArray_frame.sroa.7.05 to i64
  %lvalue_ptr8 = getelementptr i32, i32* %x, i64 %0
  %rvalue9 = load i32, i32* %lvalue_ptr8, align 4
  tail call void @writeInteger(i32 %rvalue9)
  %addtmp = add nuw nsw i32 %writeArray_frame.sroa.7.05, 1
  %lt = icmp slt i32 %addtmp, %n
  br i1 %lt, label %then, label %afterloop

afterloop:                                        ; preds = %ifcont, %entry
  tail call void @writeString(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.1, i64 0, i64 0))
  ret void
}

attributes #0 = { norecurse nounwind }
