//
// Created by blackgeorge on 2/1/20.
//

#include <stdio.h>
#include <string.h>

//int readInteger() {
//    int n;
//    scanf("%d", &n);
//    return n;
//}

//void printmsg(char *string, int length){
//
//    asm(    "int $0x80\n\t"
//    :
//    :"a"(4), "b"(1), "c"(string), "d"(length)
//    );
//
//}


unsigned char _readByte() {
    unsigned int c;
    scanf("%u", &c); // Maybe results in conversion errors but im ok
    return c;
}

void _writeByte(unsigned char b) {
    printf("%d", b);
    fflush(stdout);
}

int _extend(unsigned char b) {
    int res = b;
    return res;
}

unsigned char _shrink(int i) {
    unsigned char res = i;
    if (i > 255) {
        res = i % 256;
    }
    return res;
}


