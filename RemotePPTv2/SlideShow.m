//
//  SlideShow.m
//  RemotePPT
//
//  Created by kisu Park on 12. 7. 4..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "SlideShow.h"

@implementation SlideShow

@synthesize title = _title;
@synthesize slideImages = _slideImages;

- (void)dealloc
{
    [_title release];
    [_slideImages release];
    
    [super dealloc];
}


- (void)addByteImage:(UInt8 *)byteImage withLength:(unsigned int)length
{
    if (NULL == _slideImages) {
        _slideImages = [[NSMutableArray alloc] init];
    }
    NSData *imageData = [[NSData alloc] initWithBytes:byteImage length:length];
    UIImage *img = [[UIImage alloc] initWithData:imageData];
    [imageData release];
    [_slideImages addObject:img];
    [img release];
}

@end
