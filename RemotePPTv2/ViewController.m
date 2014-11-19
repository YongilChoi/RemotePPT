//
//  ViewController.m
//  RemotePPT
//
//  Created by kisu Park on 12. 6. 13..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "KSTcpModule.h"
#import "KSCUtility.h"
#import "SlideShow.h"

#define FULL_LENGTH_LENGTH 4
#define CATEGORY_LENGTH 4
#define DATATYPE_LENGTH 4
#define ACTION_LENGTH 4
#define ACTION_VALUE_LENGTH 4
#define HEAD_LENGTH 16


@implementation UILabel (PresentationPageLabel)
- (void)setPresentationPage:(NSInteger)currPageIndex maxPageIndex:(NSInteger)maxPageIndex
{
    [self setText:[NSString stringWithFormat:@"%d/%d", currPageIndex, maxPageIndex]];
}

@end

@implementation UIButton (PresentationArrowButton)
- (void)setBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setTitle:nil forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title
{
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

@end

int getLengthFromByte(const UInt8 *byte, int startLen);
int getInt32FromByte(unsigned char *byte);

@interface ViewController () <KSTcpModuleDelegate>
{

}
@end

@implementation ViewController

@synthesize canSending = _canSending;
@synthesize canImageReceiving = _canImageReceiving;

- (void)dealloc
{
    [_presentationScrollView release];
    [_presentationImageViews release];
    [_presentationPageLabel release];
    [leftArrow release];
    [rightArrow release];
    
    [_tcpModule release];
    [_slideShow release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPresentationIndex = 0;
    maxPresentationIndex = 0;
    _canSending = NO;
    _canImageReceiving = NO;
    _isActioning = NO;
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 0;
    [_pageControl addTarget:self action:@selector(onChangedPage:) forControlEvents:UIControlEventValueChanged];
    
    _presentationImageViews = [[NSMutableArray alloc] init];
    _slideShow = [[SlideShow alloc] init];
    
    [_presentationPageLabel setPresentationPage:currentPresentationIndex maxPageIndex:maxPresentationIndex];

    [leftArrow setTag:ActionPrevPage];
    [rightArrow setTag:ActionNextPage];
    [blackActionBtn setTag:ActionStateDarkness];
    
    [leftArrow addTarget:self action:@selector(onActionButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [rightArrow addTarget:self action:@selector(onActionButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [blackActionBtn addTarget:self action:@selector(onActionButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [_presentationScrollView setDelegate:self];

    KSTcpModule *tcpModule = [[KSTcpModule alloc] initWithInetAddr:"220.75.222.157" withPort:1313 withTimeout:30.0];
    [tcpModule setDelegate:self];
    [tcpModule openSocket];
    _tcpModule = tcpModule;
}

- (void)onChangedPage:(UIPageControl *)pgCtl
{
    int currentPage = pgCtl.currentPage;
    
    [_presentationPageLabel setPresentationPage:currentPage maxPageIndex:maxPresentationIndex];
    

    currentPresentationIndex = currentPage;
    unsigned char action[4];
    int32ToByte(action, ActionGoToPage);
    
    unsigned char pageIndex[4];
    int32ToByte(pageIndex, currentPage + 1);   // 페이지는 1부터 시작
    
    unsigned char data[8];
    for (int i=0; i<4; i++) {
        data[i] = action[i];
    }
    for (int i=0; i<4; i++) {
        data[i+4] = pageIndex[i];
    }
    
    [_tcpModule sendData:data dataLength:8];


}

- (void)onActionButtonTouched:(UIButton *)sender
{
    const unsigned int tag = sender.tag;
    unsigned char action[4];
    int32ToByte(action, tag);

    [_tcpModule sendData:action dataLength:4];
}


- (void)addPresentationImage:(UIImage *)image
{
/*    if (!self.canImageReceiving || imageCount == maxPresentationIndex) {
        return;
    }
    */
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    [imgView setFrame:CGRectMake(_presentationScrollView.frame.size.width * maxPresentationIndex++, 0, _presentationScrollView.frame.size.width, _presentationScrollView.frame.size.height)];
    [_presentationScrollView setContentSize:CGSizeMake(_presentationScrollView.frame.size.width * maxPresentationIndex, _presentationScrollView.frame.size.height)];
    [_presentationScrollView addSubview:imgView];
    [_presentationImageViews addObject:imgView];
    [imgView release];
}

- (void)onPresentationAction:(enum Action)action actionValue:(int)val
{
    _isActioning = YES;
    switch (action) {
        case ActionPrevPage:
        {
            [self movePresentationPageAtIndex:--currentPresentationIndex];
            /*[_presentationScrollView setContentOffset:CGPointMake(_presentationScrollView.frame.size.width * --currentPresentationIndex, 0) animated:YES];
            [self reloadArrowBtnWithIndex:currentPresentationIndex];*/
            
            NSLog(@"Prev Action, page: %d", currentPresentationIndex);
        }
            break;
        case ActionNextPage:
        {
            /*[_presentationScrollView setContentOffset:CGPointMake(_presentationScrollView.frame.size.width * ++currentPresentationIndex, 0) animated:YES];
            
            [self reloadArrowBtnWithIndex:currentPresentationIndex];*/
            [self movePresentationPageAtIndex:++currentPresentationIndex];
            
            NSLog(@"Next Action, page: %d", currentPresentationIndex);
        }
            break;
        case ActionStateDarkness:
        {
            
            NSLog(@"Screen State: Darkness");
        }
            break;
        case ActionGoToPage:
        {
            currentPresentationIndex = val - 1;
            /*[_presentationScrollView setContentOffset:CGPointMake(_presentationScrollView.frame.size.width * currentPresentationIndex, 0) animated:YES];
            [self reloadArrowBtnWithIndex:currentPresentationIndex];*/
            [self movePresentationPageAtIndex:currentPresentationIndex];
            NSLog(@"GotoPage Action, page: %d", currentPresentationIndex);
        }
            break;
        case ActionStateDone:
        {
            NSLog(@"Screen State: Done");
        }
            break;
        case ActionStateRunning:
        {
            NSLog(@"Screen State: Running");
        }
            break;
        case ActionStateEnd:
        {
            int count = [_presentationImageViews count];
            
            for (int i=0; i<count; i++) {
                UIView *subView = [_presentationImageViews objectAtIndex:i];
                [subView removeFromSuperview];
            }
            
            [_presentationImageViews removeAllObjects];
            [self reloadArrowBtnWithIndex:currentPresentationIndex];
            NSLog(@"Presentation Ended");
        }
            break;
    }
}

- (void)movePresentationPageAtIndex:(NSUInteger)index
{
    [_presentationScrollView setContentOffset:CGPointMake(_presentationScrollView.frame.size.width * index, 0) animated:YES];
    [self reloadArrowBtnWithIndex:index];
    [_presentationPageLabel setPresentationPage:index+1 maxPageIndex:maxPresentationIndex];
}




#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //int currentPage = currentPresentationIndex;
    
    CGFloat pageWidth = scrollView.frame.size.width;
    _pageControl.currentPage = floor((scrollView.contentOffset.x - pageWidth / _slideShow.slideImages.count) / pageWidth) + 1;
    NSLog(@"%d", _pageControl.currentPage);

    //if (0 == (int)scrollView.contentOffset.x % (int)scrollView.frame.size.width) {
        //urrentPage =  floor((scrollView.contentOffset.x - scrollView.frame.size.width / maxPresentationIndex+1) / scrollView.frame.size.width);
        _isActioning = NO;
        
}

- (void)reloadArrowBtnWithIndex:(NSInteger)currIndex
{
    if (-1 < currIndex -1) {
        UIImageView *prevImgView = [_presentationImageViews objectAtIndex:currIndex-1];
        [leftArrow setBackgroundImage:prevImgView.image];
    } else {
        [leftArrow setTitle:@"Empty"];
    }
    
    if (maxPresentationIndex > currIndex + 1) {
        UIImageView *nextImgView = [_presentationImageViews objectAtIndex:currIndex+1];
        [rightArrow setBackgroundImage:nextImgView.image];
    } else if (maxPresentationIndex +1 == currIndex +1) {
        [rightArrow setTitle:@"End"];
    } else {
        [rightArrow setTitle:@"Empty"];
    }
}

#pragma mark - KSTcpModule delegate

- (void)ksTcpModuleDidCanDataSending:(KSTcpModule *)tcpModule
{
    _canSending = true;
}

- (void)ksTcpModuleDidDataReceiving:(KSTcpModule *)tcpModule withData:(CFDataRef)data
{
    if (NULL == _accmData) _accmData = CFDataCreateMutable(NULL, 0);;
    const UInt8 *recData = CFDataGetBytePtr((CFDataRef)data);
    int recDataLen = CFDataGetLength((CFDataRef)data);
    CFDataAppendBytes(_accmData, recData, recDataLen);
    
    //const UInt8 *gRecData = CFDataGetBytePtr((CFDataRef)gRMData);
    int gRecDataLen = CFDataGetLength((CFDataRef)_accmData);
    
    [self parsingBinary:_accmData withDataLength:gRecDataLen];
}


- (void)parsingBinary:(CFMutableDataRef)rData withDataLength:(int)rDataLen
{
    if(FULL_LENGTH_LENGTH > rDataLen) return;   // 전체길이 식별가능여부 검사
    
    const UInt8 *byteData = CFDataGetBytePtr(rData);
    
    const int fullLength = getLengthFromByte(byteData, 0);
    if(fullLength > rDataLen) return;           // 파일 하나분량 이상인지 검사
    
    const int category = getLengthFromByte(byteData, 4);
    
    switch (category) {
        case CategoryTransmissionFlag:
        {
            const int transFlag = getLengthFromByte(byteData, 8);
            switch (transFlag) {
                case TransmissionFlagSendingStart:
                {
                    int dataCount = 0;
                    dataCount = getLengthFromByte(byteData, 12);
                    NSLog(@"%i", dataCount);
                    
                    const int fileNameLength = getLengthFromByte(byteData, 16);
                    char file_name[fileNameLength+1];
                    mystrcpy(file_name, (const char *)byteData, 20, fileNameLength);
                    NSString *fileName = [[NSString alloc] initWithUTF8String:(const char *)file_name];
                    NSLog(@"%@", fileName);
                    [fileName release];
                    
                    _canImageReceiving = YES;
                    
                    //[_presentationPageLabel setPresentationPage:1 maxPageIndex:dataCount];
                    NSLog(@"Presentation Image Receiving Start");
                }
                    break;
                case TransmissionFlagSendingEnd:
                {
                    _canImageReceiving = NO;
                    /*if (1 == imageCount) {
                        [leftArrow setTitle:@"Empty"];
                        [rightArrow setTitle:@"Empty"];
                    } else if (1 < imageCount) {
                        [leftArrow setTitle:@"Empty"];
                        [rightArrow setBackgroundImage:[[_presentationImageViews objectAtIndex:1] image]];
                    }*/
                    [self slideShowUpdate:_slideShow];
                    
                    NSLog(@"Presentation Image Receiving End");
                }
                    break;
            }
        }
            break;
        case CategoryActionEnum:
        {
            const int action = getLengthFromByte(byteData, 8);
            const int param = getLengthFromByte(byteData, 12);
            [self onPresentationAction:action actionValue:param];
        }
            break;
        case CategoryDataBinary:
        {
            const int dataType = getLengthFromByte(byteData, 8);
            const int dataLength = getLengthFromByte(byteData, 12);
            switch (dataType) {
                case DataTypeInteger:
                {
                    
                }
                    break;
                case DataTypeText:
                {
                    char text[dataLength+1];
                    mystrcpy(text, (const char *)byteData, 16, dataLength);
                }
                    break;
                case DataTypeImage:
                {
                    UInt8 image[dataLength];
                    mybytecpy(image, byteData, 16, dataLength);
                    [_slideShow addByteImage:image withLength:dataLength];
                }
                    break;
            }
        }
            break;
    }
    CFDataDeleteBytes(rData, CFRangeMake(0, fullLength));
    
    rDataLen = CFDataGetLength((CFDataRef)rData);
    if (0 != rDataLen) {
        [self parsingBinary:rData withDataLength:rDataLen];
    }
}

- (void)slideShowUpdate:(SlideShow *)slideShow
{
    NSMutableArray *slideImages = slideShow.slideImages;
    int imageCount = slideImages.count;
    
    _pageControl.numberOfPages = imageCount;
    for (int i=0; i<imageCount; i++) {
        [self addPresentationImage:[slideImages objectAtIndex:i]];
    }
    [_presentationPageLabel setPresentationPage:1 maxPageIndex:imageCount];
    
    if (1 == imageCount) {
        [leftArrow setTitle:@"Empty"];
        [rightArrow setTitle:@"Empty"];
    } else if (1 < imageCount) {
        [leftArrow setTitle:@"Empty"];
        [rightArrow setBackgroundImage:[[_presentationImageViews objectAtIndex:1] image]];
    }
}


@end






int getLengthFromByte(const UInt8 *byte, int startLen)
{
    unsigned char tempByteArray[4];
    for(int i=0; i<4; i++) {    // starLen으로부터 4바이트만큼 가져온다.
        tempByteArray[i] = *(byte+i+startLen);
    }
    int length = byteToInt32(tempByteArray); // byte로부터 int형태의 파일이름길이 추출
    return length;
}

// 0~4까지의 데이터를 Int32로 추출하고 포인터를 4만큼 이동시킨다.
int getInt32FromByte(unsigned char *byte)
{
    unsigned char tempByte[4];
    for(int i=0; i<4; i++) {
        tempByte[i] = *byte++;
    }
    int int32 = byteToInt32(tempByte);
    return int32;
}

