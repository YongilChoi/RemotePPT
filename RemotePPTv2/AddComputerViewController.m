//
//  AddComputerViewController.m
//  RemotePPT
//
//  Created by kisu Park on 12. 7. 5..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "AddComputerViewController.h"
#import "KSSqliteConnection.h"
#import "KSEncrypt.h"

#define DefaultTableViewHeight 289

@interface AddComputerViewController ()

@end

@implementation AddComputerViewController

@synthesize computerInfo = _computer_info;

- (void)dealloc
{
    [_tableView release];
    
    [_cellTitles release];
    [_cellValues release];
    [_cellValueThumbs release];
    [_cellValueThumbTitles release];
    [_cellIdentifiers release];
    
    [_computerInfo release];
    [_computer_id release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *saveComputerBbtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(onSaveComputerBbtnTouched)];
    
    [self.navigationItem setRightBarButtonItem:saveComputerBbtn];
    [saveComputerBbtn release];
    
    _cellTitles = [[NSArray alloc] initWithObjects:@"컴퓨터 이름", @"컴퓨터 주소", @"포트", @"비밀번호", @"비밀번호 저장", nil];
    
    NSMutableArray *mArrCellValues = [[NSMutableArray alloc] initWithCapacity:_cellTitles.count];
    for (int i=0; i<_cellTitles.count - 1; i++) {
        UITextField *txtf = [[UITextField alloc] initWithFrame:CGRectMake(122, 6, 175, 31)];
        [txtf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [txtf setTextAlignment:UITextAlignmentRight];
        [txtf setFont:[UIFont fontWithName:@"AppleGothic" size:14]];
        [txtf setDelegate:self];
        [txtf setReturnKeyType:UIReturnKeyDone];
        if (nil != _computerInfo) {
            [txtf setText:[_computerInfo objectAtIndex:i]];
        }
         
        switch (i) {
            case 0:
                [txtf setTag:TagComputerNameTxtf];
                break;
            case 1:
                [txtf setTag:TagComputerAddrTxtf];
                break;
            case 2:
                [txtf setTag:TagPortTxtf];
                break;
            case 3:
                [txtf setTag:TagPwTxtf];
                break;
        }
        
        [mArrCellValues addObject:txtf];
        [txtf release];
    }
    UISwitch *swch = [[UISwitch alloc] initWithFrame:CGRectMake(225, 8, 79, 27)];
    [swch setTag:TagPwSaveSwch];
    [swch setOn:YES];
    [mArrCellValues addObject:swch];
    [swch release];
    
    _cellValues = [[NSArray alloc] initWithArray:mArrCellValues];
    
    NSArray *cellThumbTitle = [[NSArray alloc] initWithObjects:@"Display Name", @"Ip or Domain", @"Port", @"Password", @"", nil];
    NSMutableArray *mArrCellThumbs = [[NSMutableArray alloc] initWithCapacity:_cellTitles.count - 1];
    for (int i=0; i<_cellTitles.count - 1; i++) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 175, 31)];
        [lb setBackgroundColor:[UIColor clearColor]];
        [lb setTextColor:[UIColor lightGrayColor]];
        [lb setTextAlignment:UITextAlignmentRight];
        [lb setFont:[UIFont fontWithName:@"AppleGothic" size:14]];
        
        if (nil != _computerInfo) {
            [lb setText:nil];
        } else {
            [lb setText:[cellThumbTitle objectAtIndex:i]];
        }
        
        [lb setTag:TagThumbTitleLb];
        [mArrCellThumbs addObject:lb];
        [lb release];
    }
    _cellValueThumbs = (NSArray *)mArrCellThumbs;
    _cellValueThumbTitles = cellThumbTitle;
    
    _cellIdentifiers = [[NSArray alloc] initWithObjects:@"ComputerNameCell", @"ComputerAddrCell", @"PortCell", @"PwCell", @"PwSaveCell", nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [_tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, DefaultTableViewHeight)];
    
}

- (void)updateInfo:(NSDictionary *)info
{
    NSString *name = [info objectForKey:@"name"];
    NSString *addr = [info objectForKey:@"address"];
    NSString *port = [info objectForKey:@"port"];
    NSString *pw = [info objectForKey:@"password"];
    
    _computerInfo = [[NSArray alloc] initWithObjects:name, addr, port, pw, nil];
    _computer_id = [[NSNumber alloc] initWithInt:[[info objectForKey:@"id"] intValue]];
}

- (BOOL)saveComputer
{
    KSSqliteConnection *sqliteConn = [[KSSqliteConnection alloc] init];
    if([sqliteConn open]) {
        if (nil != _computer_id) { // update
            NSString *updateQuery = [NSString stringWithFormat:@"UPDATE computer SET name='%@', address='%@', port='%@', password='%@' WHERE id=%d", [[_cellValues objectAtIndex:0] text], [[_cellValues objectAtIndex:1] text], [[_cellValues objectAtIndex:2] text], [[_cellValues objectAtIndex:3] text], [_computer_id intValue]];
            return [sqliteConn sendExecQuery:updateQuery];
        } else {    // insert
            NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO computer VALUES(NULL, '%@', '%@', '%@', '%@')", [[_cellValues objectAtIndex:0] text], [[_cellValues objectAtIndex:1] text], [[_cellValues objectAtIndex:2] text], [[_cellValues objectAtIndex:3] text]];
            return [sqliteConn sendExecQuery:insertQuery];
        }
    }
    return NO;
}


#pragma mark User Event

- (void)onSaveComputerBbtnTouched
{
    BOOL succ = [self saveComputer];
    if (succ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}




#pragma mark UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%d", range.location);
    NSLog(@"%d", string.length);
    if (0 == range.location && 0 < string.length) {
        UILabel *lb = (UILabel *)[textField viewWithTag:TagThumbTitleLb];
        [lb setText:nil];
    } else if (0 == range.location && 0 == string.length) {
        UILabel *lb = (UILabel *)[textField viewWithTag:TagThumbTitleLb];
        [lb setText:[_cellValueThumbTitles objectAtIndex:textField.tag]];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame;
	CGFloat keyboardHeight;
	
	// 3.2 and above
	if (&UIKeyboardFrameEndUserInfoKey)
	{		
		[[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];		
		if ([self interfaceOrientation] == UIDeviceOrientationPortrait || [self interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) 
			keyboardHeight = keyboardFrame.size.height;
		else
			keyboardHeight = keyboardFrame.size.width;
        _keyboardHeight = keyboardHeight;
	}
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [_tableView setFrame:CGRectMake(0, 0, _tableView.frame.size.width, self.view.frame.size.height - keyboardHeight)];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [_tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, DefaultTableViewHeight)];
    [UIView commitAnimations];
}


#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString *CellIdentifier = [_cellIdentifiers objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width - 20, 44)];
        [cell addSubview:[_cellValues objectAtIndex:indexPath.row]];
    }
    
    cell.textLabel.text = [_cellTitles objectAtIndex:indexPath.row];
    
    id cellValue = [_cellValues objectAtIndex:indexPath.row];
    if ([cellValue isKindOfClass:[UITextField class]]) {
        [cellValue addSubview:[_cellValueThumbs objectAtIndex:indexPath.row]];
    }
    
    

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"접속정보";
}

#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
