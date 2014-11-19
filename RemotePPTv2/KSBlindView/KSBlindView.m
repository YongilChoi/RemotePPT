//
//  KSBlindView.m
//  SmartPlanner
//
//  Created by kisu Park on 12. 4. 18..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "KSBlindView.h"

@implementation KSBlindView

//@synthesize indicatorView = _indicatorView;

@synthesize indicatorViewStyle;
@synthesize isBlind = _isBlind;
@synthesize delegate;

- (void)dealloc
{
    [_indicatorView release];
    [_lbTitle release];
    [_boxImageView release];
    [_blindView release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 320, 460)];

        [self setIsBlind:NO];
        _blindView = [[UIView alloc] initWithFrame:self.frame];
        [_blindView setBackgroundColor:[UIColor blackColor]];
        [_blindView setAlpha:0.1];
        
        _boxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100, self.frame.size.height/2 - 50, 200, 100)];
        [_boxImageView setImage:[UIImage imageNamed:@"bgBox.png"]];
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(_boxImageView.frame.size.width/2 - 50, _boxImageView.frame.size.height/2 + 5, 100, 18)];
        [_lbTitle setText:@"Loading..."];
        [_lbTitle setFont:[UIFont fontWithName:@"AppleGothic" size:10]];
        [_lbTitle setTextAlignment:UITextAlignmentCenter];
        [_lbTitle setTextColor:[UIColor whiteColor]];
        [_lbTitle setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:_blindView];
        [self addSubview:_boxImageView];
        [_boxImageView addSubview:_lbTitle];
        
        [self setIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        
    }
    return self;
}

- (id)initWithDelegate:(id)theDelegate
{
    self = [self init];
    if (self) {
        [self setDelegate:theDelegate];
    }
    return self;
}

- (id)initWithDelegate:(id)theDelegate withIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    self = [self initWithDelegate:theDelegate];
    if (self) {
        [self setIndicatorViewStyle:style];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)blind
{
    if (self.isBlind) {
        return;
    }
    UIView *delegateView = [(UIViewController *)self.delegate view];
    [delegateView addSubview:self];
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(blinding:) userInfo:nil repeats:YES];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.indicatorViewStyle];
    [_indicatorView setFrame:CGRectMake(160 - (_indicatorView.frame.size.width/2), self.frame.size.height/2 - (_indicatorView.frame.size.height/2) - 17, _indicatorView.frame.size.width, _indicatorView.frame.size.height)];
    [_indicatorView startAnimating];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self addSubview:_indicatorView];
    
    self.isBlind = YES;
}

- (void)nonBlind
{
    if (!self.isBlind) {
        return;
    }
    [_indicatorView stopAnimating];
    [_indicatorView removeFromSuperview];
    [_indicatorView release]; _indicatorView = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self removeFromSuperview];
    [_blindView setAlpha:0.1];
    
    self.isBlind = NO;
}

- (void)blinding:(NSTimer *)timer
{
    if (0.4 < _blindView.alpha) {
        [timer invalidate];
        timer = nil;
    }
    [_blindView setAlpha:_blindView.alpha+0.02];
}

@end
