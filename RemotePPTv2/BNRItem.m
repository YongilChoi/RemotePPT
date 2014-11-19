//
//  BNRItem.c
//  RemotePPT
//
//  Created by 동훈 서 on 13. 12. 21..
//  Copyright (c) 2013년 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#import "BNRItem.h"

@implementation BNRItem

-(void)setItemName:(NSString *)str {
    itemName = str;
}

-(NSString *)itemName {
    return itemName;
}

-(void)setSerialNumber:(NSString *)str {
    serialNumber = str;
}

-(NSString *)serialNumber {
    return serialNumber;
}

-(void)setValueInDollars:(int)i {
    valueInDollars = i;
}

-(int)valueInDollars {
    return valueInDollars;
}

-(NSDate *)dateCreated {
    return dateCreated;
}

-(NSString *)description
{
    NSString *descriptionString = 
    [[NSString alloc]initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
     itemName,
     serialNumber; // Expected "]"
     valueInDollars, // Expression result unused
     dateCreated]; //Extraneous "]" before ";"
    
    return descriptionString;
}


@end