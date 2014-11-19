//
//  KSByteCalculator.m
//  RemotePPT
//
//  Created by kisu Park on 12. 7. 3..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "KSCUtility.h"

#define NULL ((void*)0)

int byteToInt32(unsigned char src[4])
{
    int Int32 = src[3];
    Int32 = (Int32 << 8) + src[2];
    Int32 = (Int32 << 8) + src[1];
    Int32 = (Int32 << 8) + src[0];
    
    return Int32;
}

void int32ToByte(unsigned char *dest, int src)
{
    dest[3] = (src & 0xff000000);
    dest[2] = (src & 0x00ff0000);
    dest[1] = (src & 0x0000ff00);
    dest[0] = (src & 0x000000ff);
}

char* mystrcat(char *dest, char *src)
{
    if(NULL == dest) return src;
    while(*dest) dest++;
    while((*dest++ = *src++));
    return --dest;
}

void mystrcpy(char *dest, const char *src, unsigned int offset, unsigned int length)
{
    for(int i=0; i<length; i++) {
        dest[i] = *(src+i+offset);
    }
    dest[length] = '\0';
}

void mybytecpy(unsigned char *dest, const unsigned char *src, unsigned int offset, unsigned int length)
{
    for(int i=0; i<length; i++) {
        dest[i] = *(src+i+offset);
    }
}