//
//  ComputerListViewController.m
//  RemotePPT
//
//  Created by kisu Park on 12. 7. 5..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "ComputerListViewController.h"
#import "AddComputerViewController.h"
#import "KSSqliteConnection.h"
#import "ConnectionToServer.h"
#import "PPTExplorerViewController.h"
#import "KSBlindView.h"

#define TimeOut 15.0

@interface ComputerListViewController () <ConnectionToServerDelegate>
{
    NSMutableArray *_objects;
    int _computerId;
    
    KSBlindView *_blindView;
}

@end


@implementation ComputerListViewController

- (void)dealloc
{
    [_objects release];
    
    [_blindView release];
    
    [super dealloc];
}

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
    _blindView = [[KSBlindView alloc] initWithDelegate:self withIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIBarButtonItem *addComputerBbtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddComputerBbtnTouched)];
    
    [self.navigationItem setRightBarButtonItem:addComputerBbtn];
    [addComputerBbtn release];
}

- (void)reloadList
{
    KSSqliteConnection *sqliteConn = [[KSSqliteConnection alloc] init];
    if ([sqliteConn open]) {
        NSArray *selects = [[NSArray alloc] initWithObjects:@"id", @"name", @"address", @"port", @"password", nil];
        NSArray *results = [sqliteConn sendSelect:selects withTableName:@"computer" withCondition:@"1"];
        [selects release];
        
        [_objects release];
        _objects = [[NSMutableArray alloc] initWithArray:results];
        NSLog(@"%@", [_objects description]);
        [_tableView reloadData];
    }
    [sqliteConn release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadList];
}

#pragma mark User Event

- (void)onAddComputerBbtnTouched
{
    AddComputerViewController *viewController = [[AddComputerViewController alloc] initWithNibName:@"AddComputerViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)onInfoBtnTouched:(UIButton *)btn
{
    int row = btn.tag;
    AddComputerViewController *viewController = [[AddComputerViewController alloc] initWithNibName:@"AddComputerViewController" bundle:nil];
    NSDictionary *objDic = [_objects objectAtIndex:row];
    [viewController updateInfo:objDic];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


#pragma mark UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

#pragma mark UITableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [infoBtn setFrame:CGRectMake(cell.frame.size.width * 0.87, (cell.frame.size.height - infoBtn.frame.size.height)/2, infoBtn.frame.size.width, infoBtn.frame.size.height)];
        [infoBtn addTarget:self action:@selector(onInfoBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [infoBtn setTag:indexPath.row];
        [cell addSubview:infoBtn];
    }
    
    cell.textLabel.text = [[_objects objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}


#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _computerId = [[[_objects objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    
    NSString *addr = [[_objects objectAtIndex:indexPath.row] objectForKey:@"address"];
    NSString *port = [[_objects objectAtIndex:indexPath.row] objectForKey:@"port"];
    
    if (!_blindView.isBlind) {
        [_blindView blind];
    }
    
    ConnectionToServer *conn = [[ConnectionToServer alloc] initWithAddress:addr withPort:port.intValue];
    [conn setDelegate:self];
    
    [conn performSelector:@selector(connection) withObject:nil afterDelay:0.5];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strQuery=[[NSString alloc] initWithString:@""];
    
    
    strQuery = [NSString stringWithFormat:@"DELETE FROM computer WHERE id=%d", [[[_objects objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]];
    KSSqliteConnection *sqliteConn = [[KSSqliteConnection alloc] init];
    
    if([sqliteConn open] && [sqliteConn sendExecQuery:strQuery]) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}


#pragma mark - ConnectionToServer delegate
- (void)connectionToServer:(ConnectionToServer *)connToServer connectionState:(KSTcpModuleConnectionState)state
{
    if (_blindView.isBlind) {
        [_blindView nonBlind];
    }
    switch (state) {
        case KSTcpModuleConnectionSuccess:
        {
            PPTExplorerViewController *viewController = [[PPTExplorerViewController alloc] initWithNibName:@"PPTExplorerViewController" bundle:nil];
            [viewController setComputerId:_computerId];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
            break;
        case KSTcpModuleConnectionFail:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:nil delegate:nil cancelButtonTitle:@"확인" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }
            break;
        case KSTcpModuleConnectionTimeout:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Timeout" message:nil delegate:nil cancelButtonTitle:@"확인" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }
            break;
            
        default:
            break;
    }
    if ([connToServer retainCount]) {
        [connToServer release];
    }
}


@end
