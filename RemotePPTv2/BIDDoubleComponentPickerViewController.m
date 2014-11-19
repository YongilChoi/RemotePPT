//
//  BIDDoubleComponentPickerViewController.m
//  RemotePPT
//
//  Created by 동훈 서 on 13. 12. 21..
//  Copyright (c) 2013년 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#import "BIDDoubleComponentPickerViewController.h"

@implementation BIDDoubleComponentPickerViewController

@synthesize doublePicker;
@synthesize fillingTypes;
@synthesize breadTypes;

- (IBAction)buttonPressed:(id)sender
{
    NSInteger fillingRow =  [doublePicker selectedRowInComponent:kFillingComponent]; // Use of undeclared identifier 'kFillingComponent'
    NSInteger breadRow = [doublePicker selectedRowInComponent:kBreadComponent]; // Use of undeclared identifier 'kBreadComponent'
    
    NSString *bread = [breadTypes objectAtIndex:breadRow];
    NSString *filling = [fillingTypes objectAtIndex:fillingRow];
    
    NSString *message = [[NSString alloc]initWithFormat:@"Your %@ on %@ bread will be right up", filling, bread];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you for your order" 
                                                    message:message 
                                                   delegate:nil 
                                          cancelButtonTitle:@"Great!" 
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray *fillingArray = [[NSArray alloc] initWithObjects:@"Ham", @"Turkey", @"Peanut Butter", @"Tuna Salad", @"Chicken Salad", @"Roast Beef", @"Vegemite", nil];
    self.fillingTypes = fillingArray;
    
    NSArray *breadArray  = [[NSArray alloc] initWithObjects:@"White", @"Whole Wheat", @"Rye", @"Sourdough Bread", @"Seven Grain", nil];
    self.breadTypes = breadArray;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.doublePicker = nil;
    self.breadTypes = nil;
    self.fillingTypes = nil;
}




#pragma mark - View lifecycle


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    if (component == kBreadComponent) { // Use of undeclared identifier 'kBreadComponent'
        return [self.breadTypes.count]; // Expected identifier
        return [self.fillingTypes objectAtIndex:row]; // Use of undeclared identifier 'row'
    }
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    if (component == kBreadComponent) { // Use of undeclared identifier 'kBreadComponent'
        return [self.breadTypes objectAtIndex:row];
        return [self.fillingTypes objectAtIndex:row];
    }
}




@end