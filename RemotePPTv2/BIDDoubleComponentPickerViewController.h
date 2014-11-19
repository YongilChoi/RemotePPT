//
//  BIDDoubleComponentPickerViewController.h
//  RemotePPT
//
//  Created by 동훈 서 on 13. 12. 21..
//  Copyright (c) 2013년 __MyCompanyName__. All rights reserved.
//

#ifndef RemotePPT_BIDDoubleComponentPickerViewController_h
#define RemotePPT_BIDDoubleComponentPickerViewController_h



#endif
#import <UIKit/UIKit.h>

@interface BIDDoubleComponentPickerViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *doublePicker;
@property (strong, nonatomic) NSArray *fillingTypes;
@property (strong, nonatomic) NSArray *breadTypes;

- (IBAction)buttonPressed:(id)sender;


@end- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    return self.breadTypes.count;
}

#pragma mark Picker Delegate Methods
/* - (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    if (component == kBreadComponent) {
        return [self.fillingTypes objectAtIndex:row];
    }
    return nil; // Or something, empty string for example. Method requires to return a NSString, so you have to return at least nil;
} */