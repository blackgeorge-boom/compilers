Call parameter type does not match function signature!
  %main2_frame = alloca %main2_type
 %main_type*  %fcalltmp33 = call i32 @work(%main2_type* %main2_frame, [101 x i8]* %lvalue_ptr29, i32 %rvalue30, [101 x i8]* %lvalue_ptr31, i32 %rvalue32)
The faulty IR is:
------------------------------------------------

