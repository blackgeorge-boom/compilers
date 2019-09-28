; ModuleID = 'dana program'
source_filename = "dana program"

@str = private unnamed_addr constant [8 x i8] c"makaris\00"

define void @main() {
entry:
	  %rvalue = load [8 x i8], [8 x i8]* @str
	    call void @writeString([8 x i8] %rvalue)
		  ret void
}

declare void @writeInteger(i32)

declare void @writeChar(i8)

declare void @writeString([8 x i8])
