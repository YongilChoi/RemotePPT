//
//  MainViewController.h
//  RemotePPT
//
//  Created by kisu Park on 12. 7. 5..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "KSViewController.h"

@interface MainViewController : KSViewController
{
    @private
    IBOutlet UIButton *_computerListBtn, *_recentBtn, *_helpBtn;
    
    enum {
        kComputerListBtnTag = 0,
        kRecentBtnTag,
        kHelpBtnTag,
    };
}

@end
