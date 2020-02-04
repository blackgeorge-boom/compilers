//
// Created by blackgeorge on 2/1/20.
//

#include <cstdio>
#include "our_libs.h"

void writeByte(unsigned char b){
    std::cout << int(b);
}
unsigned char readByte(){
    int c;
    std::cin >> c;
    return char(c);
}
int extend (unsigned char b){
    return int(b);
}
unsigned char shrink(int i){
    if (i>255) {
        i = i%256;
    }
    return char(i);
}
//char readByte();
//{
//
//}
//int extend(char b);
//char shrink(int i);
