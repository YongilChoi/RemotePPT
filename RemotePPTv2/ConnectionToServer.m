//
//  ConnectionToServer.m
//  RemotePPT
//
//  Created by Park kisu on 12. 7. 9..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "ConnectionToServer.h"
#import "KSTcpModule.h"
#import "AppDelegate.h"

@interface ConnectionToServer () <KSTcpModuleDelegate>
{
    NSString *_addr;
    int _port;
}
@end

@implementation ConnectionToServer

@synthesize delegate;

@synthesize address = _addr;
@synthesize port = _port;
@synthesize isConnection = _isConnection;
@synthesize userInfo = _userInfo;

- (void)dealloc
{
    [_addr release];
    [_userInfo release];
    
    [super dealloc];
}

- (id)initWithAddress:(NSString *)addr withPort:(int)port
{
    self = [super init];
    if (self) {
        _addr = [[NSString alloc] initWithString:addr];
        _port = port;
    }
    return self;
}

- (void)connection
{
    KSTcpModule *tcpModule = [self tcpModule];
    if (nil == tcpModule) {
        tcpModule = [[[KSTcpModule alloc] initWithInetAddr:self.address.UTF8String withPort:self.port] autorelease];
        [tcpModule setDelegate:self];
        [self setTcpModule:tcpModule];
    } else {
        [tcpModule setDelegate:self];
    }
    [tcpModule openSocket];
}

#pragma mark - KSTcpModule delegate

- (void)ksTcpModule:(KSTcpModule *)tcpModule connectionState:(KSTcpModuleConnectionState)state
{
    switch (state) {
        case KSTcpModuleConnectionSuccess:
        {
            _isConnection = YES;
        }
            break;
        case KSTcpModuleConnectionFail:
        {
            _isConnection = NO;
        }
            break;
        case KSTcpModuleConnectionTimeout:
        {
            _isConnection = NO;
        }
            break;
    }
    [self callConnectionStateDelegateMethodWithState:state];
}

- (void)ksTcpModuleDidCanDataSending:(KSTcpModule *)tcpModule
{
    
}

- (void)ksTcpModuleDidDataReceiving:(KSTcpModule *)tcpModule withData:(CFDataRef)data
{
    
}


- (void)callConnectionStateDelegateMethodWithState:(KSTcpModuleConnectionState)state
{
    id theDelegate = self.delegate;
    if ([theDelegate respondsToSelector:@selector(connectionToServer:connectionState:)]) {
        [theDelegate connectionToServer:self connectionState:state];
    }
}

- (KSTcpModule *)tcpModule
{
    return [[self appDelegate] tcpModule];
}

- (void)setTcpModule:(KSTcpModule *)tcpModule
{
    [[self appDelegate] setTcpModule:tcpModule];
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
