//
//  KSSqliteConnection.h
//  RemotePPT
//
//  Created by Park kisu on 12. 7. 6..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface KSSqliteConnection : NSObject
{
    @private
    sqlite3 *_db;
    BOOL _isOpen;
}

@property (nonatomic, assign, readonly) BOOL isOpen;

- (BOOL)open;

- (BOOL)sendExecQuery:(NSString *)execQuery;;
- (NSArray *)sendSelect:(NSArray *)selects withTableName:(NSString *)tbName withCondition:(NSString *)condition;

@end
