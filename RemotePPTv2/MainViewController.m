//
//  MainViewController.m
//  RemotePPT
//
//  Created by kisu Park on 12. 7. 5..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "MainViewController.h"
#import "ComputerListViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_computerListBtn setTag:kComputerListBtnTag];
    [_recentBtn setTag:kRecentBtnTag];
    [_helpBtn setTag:kHelpBtnTag];
    
    [_computerListBtn addTarget:self action:@selector(onButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_recentBtn addTarget:self action:@selector(onButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_helpBtn addTarget:self action:@selector(onButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)onButtonAction:(UIButton *)sender
{
    int tag = sender.tag;
    switch (tag) {
        case kComputerListBtnTag:
        {
            ComputerListViewController *viewController = [[ComputerListViewController alloc] initWithNibName:@"ComputerListViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
         //   [viewController release];
        }
            break;
        case kRecentBtnTag:
        {
            
        }
        case kHelpBtnTag:
        {
            
        }
    }
}


@end
