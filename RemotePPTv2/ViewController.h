//
//  ViewController.h
//  RemotePPT
//
//  Created by kisu Park on 12. 6. 13..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "KSViewController.h"

@class KSTcpModule;
@class SlideShow;
@interface ViewController : KSViewController < UIScrollViewDelegate>
{
    @private
        IBOutlet UIButton *leftArrow, *rightArrow, *blackActionBtn;
        IBOutlet UIScrollView *_presentationScrollView;
        IBOutlet UILabel *_presentationPageLabel;
        UIPageControl *_pageControl;
        NSMutableArray *_presentationImageViews;
    
        NSUInteger currentPresentationIndex;
        NSUInteger maxPresentationIndex;
    
        BOOL _canSending;
        BOOL _canImageReceiving;
        BOOL _isActioning;
    
        KSTcpModule *_tcpModule;
        CFMutableDataRef _accmData;
    
        SlideShow *_slideShow;

    
    enum Category
    {
        CategoryTransmissionFlag = 0,
        CategoryDataBinary,
        CategoryActionEnum,
    };
    
    enum DataType
    {
        DataTypeInteger = 0,
        DataTypeText,
        DataTypeImage,
    };
    
    enum Action
    {
        ActionPrevPage = 0,
        ActionNextPage,
        ActionStateDarkness,
        ActionGoToPage,
        ActionStateDone,
        ActionStateRunning,
        ActionStateEnd,
    };
    
    enum TransmissionFlag
    {
        TransmissionFlagSendingStart = 0,
        TransmissionFlagSendingEnd,
    };
}

@property (assign) BOOL canSending;
@property (assign, readonly) BOOL canImageReceiving;

- (void)addPresentationImage:(UIImage *)image;
- (void)onPresentationAction:(enum Action)action actionValue:(int)val;

@end
