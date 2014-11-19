//
//  AddComputerViewController.h
//  RemotePPT
//
//  Created by kisu Park on 12. 7. 5..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "KSViewController.h"

@interface AddComputerViewController : KSViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    @private
        IBOutlet UITableView *_tableView;
        NSArray *_cellTitles;
        NSArray *_cellValues;
        NSArray *_cellValueThumbs;
        NSArray *_cellValueThumbTitles;
        NSArray *_cellIdentifiers;
    
        CGFloat _keyboardHeight;
    
//        NSDictionary *_computerInfo;
        NSArray *_computerInfo;
        NSNumber *_computer_id;
    
        enum {
            TagComputerNameTxtf = 0,
            TagComputerAddrTxtf,
            TagPortTxtf,
            TagPwTxtf,
            TagPwSaveSwch
        };
    
        enum {
            TagThumbTitleLb = 112
        };
}

@property (nonatomic, retain, readonly) NSDictionary *computerInfo;

- (void)updateInfo:(NSDictionary *)info;

@end
