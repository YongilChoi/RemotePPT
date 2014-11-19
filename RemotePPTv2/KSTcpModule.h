//
//  KSTcpModule.h
//  RemotePPT
//
//  Created by kisu Park on 12. 7. 3..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef unsigned char byte;
typedef enum
{
    KSTcpModuleConnectionSuccess = 0,
    KSTcpModuleConnectionFail,
    KSTcpModuleConnectionTimeout,
}KSTcpModuleConnectionState;
    
@class KSTcpModule;
@protocol KSTcpModuleDelegate <NSObject>

- (void)ksTcpModule:(KSTcpModule *)tcpModule connectionState:(KSTcpModuleConnectionState)state;
- (void)ksTcpModuleDidDataReceiving:(KSTcpModule *)tcpModule withData:(CFDataRef)data;
- (void)ksTcpModuleDidCanDataSending:(KSTcpModule *)tcpModule;

@end

@interface KSTcpModule : NSObject
{
    CFSocketRef _socket;
    CFDataRef _addr;
    CFTimeInterval _timeout;
}

@property (assign) id<KSTcpModuleDelegate> delegate;

- (id)initWithInetAddr:(const char*)in_addr withPort:(int)port;
- (id)initWithInetAddr:(const char*)in_addr withPort:(int)port withTimeout:(CFTimeInterval)timeout;

- (void)openSocket;
- (void)closeSocket;

- (void)sendData:(const byte *)data dataLength:(const unsigned int)length;

@end
