//
//  KSTableViewController.h
//  RemotePPT
//
//  Created by Park kisu on 12. 7. 9..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "KSViewController.h"

@interface KSTableViewController : KSViewController <UITableViewDelegate, UITableViewDataSource>
{

}
@property (nonatomic, retain) UITableView *tableView;

- (id)initWithStyle:(UITableViewStyle)style;

@end
