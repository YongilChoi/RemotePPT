//
//  ComputerListViewController.h
//  RemotePPT
//
//  Created by kisu Park on 12. 7. 5..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "KSViewController.h"

@interface ComputerListViewController : KSViewController < UITableViewDataSource, UITableViewDelegate >
{
    @private
    IBOutlet UITableView *_tableView;
}

@end
