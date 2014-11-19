//
//  SlideShow.h
//  RemotePPT
//
//  Created by kisu Park on 12. 7. 4..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideShow : NSObject
{
    @private
    NSString *_title;
    NSMutableArray *_slideImages;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain, readonly) NSMutableArray *slideImages;

- (void)addByteImage:(UInt8 *)byteImage withLength:(unsigned int)length;

@end
