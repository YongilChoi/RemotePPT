//
//  PPTExplorerViewController.m
//  RemotePPT
//
//  Created by Park kisu on 12. 7. 9..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "PPTExplorerViewController.h"
#import "KSSqliteConnection.h"

@interface PPTExplorerViewController ()
{
    NSArray *_sectionTitles;
    
    NSArray *_newPresentation;
    NSArray *_recentPresentations;
}
@end

@implementation PPTExplorerViewController

@synthesize computerId;

- (void)dealloc
{
    [_sectionTitles release];
    [_newPresentation release];
    [_recentPresentations release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _sectionTitles = [[NSArray alloc] initWithObjects:@"New Presentation", @"Recent Presentations", nil];
        _newPresentation = [[NSArray alloc] initWithObjects:@"Open the new presentation", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadRecentList];
}


- (void)reloadRecentList
{
    KSSqliteConnection *conn = [[KSSqliteConnection alloc] init];
    if ([conn open]) {
        NSArray *objects = [conn sendSelect:[NSArray arrayWithObjects:@"id", @"computer_id", @"full_name", @"absolute_name", @"current_page", nil] withTableName:@"recent_ppt" withCondition:[NSString stringWithFormat:@"computer_id=%d", self.computerId]];
        _recentPresentations = [[NSArray alloc] initWithArray:objects];
    }
    [conn release];
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return _newPresentation.count;
        }
            break;
        case 1:
        {
            return _recentPresentations.count;
        }
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitles objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            [cell.textLabel setText:[_newPresentation objectAtIndex:indexPath.row]];
        }
            break;
        case 1:
        {
            [cell.textLabel setText:[[_recentPresentations objectAtIndex:indexPath.row] objectForKey:@"absolute_name"]];
        }
            break;
    }
    
    return cell;
}


#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
