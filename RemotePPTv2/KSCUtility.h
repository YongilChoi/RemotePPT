//
//  KSByteCalculator.h
//  RemotePPT
//
//  Created by kisu Park on 12. 7. 3..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#ifndef _KSCUtility

#define _KSCUtility_


int byteToInt32(unsigned char src[4]);
void int32ToByte(unsigned char *dest, int src);

char* mystrcat(char *dest, char *src);
void mystrcpy(char *dest, const char *src, unsigned int offset, unsigned int length);
void mybytecpy(unsigned char *dest, const unsigned char *src, unsigned int offset, unsigned int length);

#endif
