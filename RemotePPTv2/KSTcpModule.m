//
//  KSTcpModule.m
//  RemotePPT
//
//  Created by kisu Park on 12. 7. 3..
//  Copyright (c) 2012년 kisu Park. All rights reserved.
//

#import "KSTcpModule.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

typedef struct sockaddr_in sockaddr;

void createSockAddr ( sockaddr *sockaddr, sa_family_t family, const char *in_addr, int in_port);
void CFSockCallBack ( CFSocketRef s, CFSocketCallBackType callbackType, CFDataRef address, const void *data, void *info );


@implementation KSTcpModule

@synthesize delegate;

- (void)dealloc
{
    CFRelease(_socket);
    CFRelease(_addr);
    
    [super dealloc];
}

- (id)initWithInetAddr:(const char *)in_addr withPort:(int)port
{
    self = [super init];
    if (self) {
        CFSocketContext socketContext = {0, (void *) self, NULL, NULL, NULL};
        CFSocketRef socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketDataCallBack | kCFSocketWriteCallBack |kCFSocketConnectCallBack, CFSockCallBack, &socketContext);
        _socket = socket;
        
        sockaddr client_address;
        createSockAddr(&client_address, AF_INET, in_addr, port);
        
        _addr = CFDataCreate( NULL, (UInt8 *)&client_address, sizeof( sockaddr ) );
        
        _timeout  = 10.0;
    }
    return self;
}

- (id)initWithInetAddr:(const char*)in_addr withPort:(int)port withTimeout:(CFTimeInterval)timeout
{
    self = [self initWithInetAddr:in_addr withPort:port];
    if (self) {
        _timeout = timeout;
    }
    return self;
}

- (void)openSocket
{
    CFSocketError error = CFSocketConnectToAddress(_socket, (CFDataRef)_addr, _timeout);
    NSLog(@"%s", [error discription]); 

    switch (error) {
        case kCFSocketSuccess:
        {
            CFRunLoopSourceRef FrameRunLoopSource = CFSocketCreateRunLoopSource(NULL, _socket , 0);
            CFRunLoopAddSource(CFRunLoopGetCurrent(), FrameRunLoopSource, kCFRunLoopCommonModes);
            CFRelease(FrameRunLoopSource);
            NSLog(@"Connection Success");
            [self callConnectionStateDelegateMethodWithState:KSTcpModuleConnectionSuccess];
        }
            break;
        case kCFSocketError:
        {
            NSLog(@"Connection Error");
            [self callConnectionStateDelegateMethodWithState:KSTcpModuleConnectionFail];
        }
            break;
        case kCFSocketTimeout:
        {
            NSLog(@"Connection Timeout");
            [self callConnectionStateDelegateMethodWithState:KSTcpModuleConnectionTimeout];
        }
            break;
    }
}

- (void)closeSocket
{
    CFSocketInvalidate(_socket);
}

- (void)callConnectionStateDelegateMethodWithState:(KSTcpModuleConnectionState)state
{
    id<KSTcpModuleDelegate> theDelegate = self.delegate;
    if ([theDelegate respondsToSelector:@selector(ksTcpModule:connectionState:)]) {
        [theDelegate ksTcpModule:self connectionState:state];
    }
}


- (void)sendData:(const unsigned char *)data dataLength:(const unsigned int)length
{
    unsigned char sendbuf[length];
    memcpy(sendbuf, data, length);
    
    CFDataRef dt = CFDataCreate(NULL, (UInt8 *)sendbuf, length);
    CFSocketError error = CFSocketSendData(_socket, NULL, dt, length);
    switch (error) {
        case kCFSocketSuccess:
            NSLog(@"Sending Complete: %s", sendbuf);
            break;
        case kCFSocketError:
        {
            NSLog(@"Sending Error");
        }
            break;
        case kCFSocketTimeout:
        {
            NSLog(@"Sending Timeout");
        }
            break;
    }
    CFRelease(dt);
}

@end



#pragma mark - C Language

// sockaddr_in 생성
void createSockAddr ( sockaddr *sock_addr, sa_family_t family, const char *in_addr, int in_port)
{
    memset(sock_addr,0,sizeof(sockaddr));
    sock_addr->sin_family=family;
    sock_addr->sin_addr.s_addr = inet_addr(in_addr);
    sock_addr->sin_port= htons(in_port);
}

//소켓에사용된콜백함수
void CFSockCallBack ( CFSocketRef s, CFSocketCallBackType callbackType, CFDataRef address, const void *data, void *info )
{
    KSTcpModule *tcpModule = (KSTcpModule *) info;
    switch (callbackType) {
        case kCFSocketDataCallBack: // 데이터 수신시 여기에 프로그래밍하세요
        {
            id<KSTcpModuleDelegate> theDelegate = tcpModule.delegate;
            if ([theDelegate respondsToSelector:@selector(ksTcpModuleDidDataReceiving:withData:)]) {
                [theDelegate ksTcpModuleDidDataReceiving:tcpModule withData:(CFDataRef)data];
            }
        }
            break;
            
        case kCFSocketReadCallBack: // 소켓에서읽을수있습니다.
        {
            NSLog(@"can reading");
        }
            break;
            
        case kCFSocketWriteCallBack: // 데이터송신이가능해졌습니다.
        {
            id<KSTcpModuleDelegate> theDelegate = tcpModule.delegate;
            if ([theDelegate respondsToSelector:@selector(ksTcpModuleDidCanDataSending:)]) {
                [theDelegate ksTcpModuleDidCanDataSending:tcpModule];
            }
        }
            break;
            
        case kCFSocketConnectCallBack: // 연결이이루어졌습니다.
            NSLog(@"connection success");
            break;
            
        default:
            NSLog(@"unhandling callbackType");
            break;
    }
}
