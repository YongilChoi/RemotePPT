//
//  KSViewController.h
//  RemotePPT
//
//  Created by kisu Park on 12. 6. 14..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@class KSTcpModule;
@interface KSViewController : UIViewController
{
    CGFloat width, height;
}

- (BOOL)isIPad;
- (AppDelegate *)appDelegate;

- (KSTcpModule *)tcpModule;
- (void)setTcpModule:(KSTcpModule *)tcpModule;

@end
