//
//  KSBlindView.h
//  SmartPlanner
//
//  Created by kisu Park on 12. 4. 18..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSBlindView : UIView
{
    UIActivityIndicatorView *_indicatorView;
    UIView *_blindView;
    UIImageView *_boxImageView;
    UILabel *_lbTitle;
    
    BOOL _isBlind;
}

//@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) UIActivityIndicatorViewStyle indicatorViewStyle;
@property (assign) BOOL isBlind;
@property (assign) id delegate;

- (id)initWithDelegate:(id)theDelegate;
- (id)initWithDelegate:(id)theDelegate withIndicatorStyle:(UIActivityIndicatorViewStyle)style;

- (void)blind;
- (void)nonBlind;

@end
