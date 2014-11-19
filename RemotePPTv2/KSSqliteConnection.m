//
//  KSSqliteConnection.m
//  RemotePPT
//
//  Created by Park kisu on 12. 7. 6..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "KSSqliteConnection.h"



@implementation KSSqliteConnection

@synthesize isOpen = _isOpen;

- (void)dealloc
{
    free(_db);
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)open
{
    NSString *pathResourceDatabase = [self pathResourceForDatabase];    // 리소스에 있는 데이터베이스 경로
    NSString *pathDatabase = [self pathForDatabase];    // 다큐먼트에 있는 데이터베이스 경로
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDatabase = [fileManager fileExistsAtPath:pathDatabase];  // 다큐먼트에 데이터베이스가 있는지 검사 ? 1 : 0
    
    NSError *error;
    if(!isDatabase) {   // 다큐먼트 경로에 데이터베이스가 없을 경우
        isDatabase = [fileManager copyItemAtPath:pathResourceDatabase toPath:pathDatabase error:&error];   // 리소스에 있는 데이터베이스를 다큐먼트로 복사
        if (!isDatabase) 
            NSLog(@"Error : %@", [error localizedDescription]);
    }    
    [fileManager release];
    
    // 데이터베이스 오픈
    if(sqlite3_open([pathDatabase UTF8String], &_db)!= SQLITE_OK){
        sqlite3_close(_db);
        _isOpen = NO;
        NSLog(@"fail open database");   // 데이터베이스 오픈 실패
    } else {
        _isOpen = YES;
    }
    return _isOpen;

}

- (BOOL)sendExecQuery:(NSString *)execQuery;
{
    if (!_isOpen) return false;
    const char *query = [execQuery UTF8String];
    char *errorMsg = NULL;
    if(sqlite3_exec(_db, query, NULL, NULL, NULL)!=SQLITE_OK) {
        NSLog(@"Failed execQuery: %s", errorMsg);
        return NO;
    }
    return YES;
}

- (NSArray *)sendSelect:(NSArray *)selects withTableName:(NSString *)tbName withCondition:(NSString *)condition
{
    if (!_isOpen) return nil;
    
    sqlite3_stmt *stmt;
    
    NSString *selectString = [selects componentsJoinedByString:@","];
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@", selectString, tbName, condition ? condition : @"1"];
    
    const char *query = [selectQuery UTF8String];

    if(sqlite3_prepare_v2(_db, query, -1, &stmt, NULL) == SQLITE_OK) {
        NSMutableArray *mArrSelectVals = [[NSMutableArray alloc] init];
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableDictionary *mDicTuple = [[NSMutableDictionary alloc] init];
            for (int i=0; i<selects.count; i++) {
                int type = sqlite3_column_type(stmt, i);
                NSString *key = [selects objectAtIndex:i];
                id val = NULL;
                switch (type) {
                    case SQLITE_INTEGER:
                    {
                        val = [[NSNumber alloc] initWithInt:(int)sqlite3_column_int(stmt, i)];
                    }
                        break;
                    case SQLITE_FLOAT:
                    {
                        val = [[NSNumber alloc] initWithFloat:(float)sqlite3_column_double(stmt, i)];
                    }
                        break;
                    case SQLITE_TEXT:
                    {
                        val = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, i)];
                    }
                        break;
                }
                if (NULL == val) continue;
                
                [mDicTuple setObject:val forKey:key];
                [val release];
            }
            [mArrSelectVals addObject:mDicTuple];
            [mDicTuple release];
        } 
        return [(NSArray *)mArrSelectVals autorelease];
    } else {
        NSLog(@"sqlite: failed SELECT");
        return nil;
    }
}

// -> 데이터베이스 주소 가져오기(리소스)
- (NSString *)pathResourceForDatabase
{
    NSString *resourcePaths = [[NSBundle mainBundle] pathForResource:@"remotePPT" ofType:@"db"];
    return resourcePaths;
}

// -> 데이터베이스 주소 가져오기(다큐먼트)
- (NSString *)pathForDatabase
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    return  [documentDirectory stringByAppendingPathComponent:@"remotePPT.db"];
}

@end
