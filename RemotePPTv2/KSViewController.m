//
//  KSViewController.m
//  RemotePPT
//
//  Created by kisu Park on 12. 6. 14..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "KSViewController.h"
#import "KSTcpModule.h"
#import "AppDelegate.h"

@interface KSViewController ()

@end

@implementation KSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:[self convertNibName:nibNameOrNil] bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - utility method

- (BOOL)isIPad
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

- (NSString *)convertNibName:(NSString *)nibName
{
    if ([self isIPad]) {
        nibName = [NSString stringWithFormat:@"%@_iPad", nibName];
    } else {
        nibName = [NSString stringWithFormat:@"%@_iPhone", nibName];
    }
    return nibName;
}

- (KSTcpModule *)tcpModule
{
    return [[self appDelegate] tcpModule];
}

- (void)setTcpModule:(KSTcpModule *)tcpModule
{
    [[self appDelegate] setTcpModule:tcpModule];
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
