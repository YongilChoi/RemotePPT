//
//  KSTableViewController.m
//  RemotePPT
//
//  Created by Park kisu on 12. 7. 9..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "KSTableViewController.h"

@interface KSTableViewController ()
{
    @public
    IBOutlet UITableView *tableView;
}
@end

@implementation KSTableViewController
@synthesize tableView;

- (void)dealloc
{
    [tableView release];
    
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        tableView = [[UITableView alloc] initWithFrame:self.view.frame style:style];
        [self.view addSubview:tableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


#pragma mark - UITableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
