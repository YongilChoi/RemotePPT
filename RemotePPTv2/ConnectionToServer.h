//
//  ConnectionToServer.h
//  RemotePPT
//
//  Created by Park kisu on 12. 7. 9..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSTcpModule.h"

@class ConnectionToServer;
@protocol ConnectionToServerDelegate <NSObject>

@optional
- (void)connectionToServer:(ConnectionToServer *)connToServer connectionState:(KSTcpModuleConnectionState)state;
- (void)connectionToServer:(ConnectionToServer *)connToServer receivingData:(CFDataRef)data;

@end


@interface ConnectionToServer : NSObject
{
    BOOL _isConnection;
    NSDictionary *_userInfo;
}

@property (nonatomic, assign) id<ConnectionToServerDelegate> delegate;

@property (nonatomic, retain) NSString *address;
@property (nonatomic, assign) int port;

@property (nonatomic, assign) BOOL isConnection;
@property (nonatomic, retain) NSDictionary *userInfo;

- (id)initWithAddress:(NSString *)addr withPort:(int)port;

- (void)connection;

@end