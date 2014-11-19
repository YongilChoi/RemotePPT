//
//  KSEncrypt.m
//  RemotePPT
//
//  Created by Park kisu on 12. 7. 6..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "KSEncrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation KSEncrypt

//1. MD5 해쉬
+ (NSString*)md5:(NSString*)srcStr
{
	const char *cStr = [srcStr UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, strlen(cStr), result);
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],
			result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15]];
}

//2. Base64 Encoding
//-(NSString*) base64:(NSString*)srcStr
//{
//	NSLog(@"Original string: %@", srcStr);  
//	NSData *sourceData = [srcStr dataUsingEncoding:NSUTF8StringEncoding];  
//	
//	NSString *base64EncodedString = [sourceData base64Encoding];  
//	NSLog(@"Encoded form: %@", base64EncodedString);	
//	
//	return base64EncodedString;
//}

//3. Hex encoding
-(NSString *) hexEncode:(NSData*)data
{
    NSMutableString *hex = [NSMutableString string];
    unsigned char *bytes = (unsigned char *)[data bytes];
    char temp[3];
    NSUInteger i = 0;
    
    for (i = 0; i < [data length]; i++) 
	{
		temp[0] = temp[1] = temp[2] = 0;
		(void)sprintf(temp, "%02x", bytes[i]);
		[hex appendString:[NSString stringWithUTF8String:temp]];
	}
    return hex;	
}

//4. DES Encryption - ECB 모드 
//-(NSData *) desEncrypt:(NSString*)srcStr
//{
//	NSString *token = @"moauth1026336512"; 
//	NSString *key = @"DmsCksDk"; 
//	
//	NSData *keyData   = [key dataUsingEncoding:NSUTF8StringEncoding];
//	NSData *plainData = [token dataUsingEncoding:NSUTF8StringEncoding]; 
//	NSMutableData *encData = [NSMutableData dataWithLength: plainData.length + 256];
//	size_t bytesWritten = 0;
//	
//	CCCryptorStatus ccStatus;
//	ccStatus = CCCrypt(kCCEncrypt, 
//					   kCCAlgorithmDES, 
//					   /*kCCOptionPKCS7Padding|*/kCCOptionECBMode, 
//					   [keyData bytes],   //[IN]key 
//					   kCCKeySizeDES,     //[IN]key length 
//					   NULL,              //[IN]iv, 
//					   [plainData bytes], //[IN]plainText 
//					   [plainData length],//[IN]plainText length 
//					   encData.mutableBytes, //[OUT]encryptText
//					   encData.length,       //[OUT]encryptText  
//					   &bytesWritten);       //
//	
//	encData.length = bytesWritten;
//    
//	return encData;	
//}

@end
