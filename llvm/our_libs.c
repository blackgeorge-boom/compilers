//
// Created by blackgeorge on 2/1/20.
//

#include <stdio.h>

//int readInteger() {
//    int n;
//    scanf("%d", &n);
//    return n;
//}

void writeByte(char b) {
    printf("%d", b);
}

unsigned char readByte() {
    unsigned int c;
    scanf("%u", &c); // Maybe results in conversion errors but im ok
    return c;
}

int extend(unsigned char b) {
    int res = b;
    return res;
}

unsigned char shrink(int i) {
    char res = i;
    if (i > 255) {
        res = i % 256;
    }
    return res;
}
