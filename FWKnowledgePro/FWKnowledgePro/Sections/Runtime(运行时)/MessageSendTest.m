//
//  MessageSendTest.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/26.
//

/**
 消息转发三部曲：
 
 1、动态解析方法：resolveInstanceMethod；
 2、找消息备用接收者：forwardingTargetForSelector；
 3.1、消息签名：methodSignatureForSelector；
 3.2、消息转发：forwardInvocation；
 4、消息还是无法处理：doesNotRecognizeSelector；
 */

#import "MessageSendTest.h"
#import <objc/runtime.h>
#import "MessageSendTest2.h"

@implementation MessageSendTest


/// 1、动态解析方法
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
//    NSString *methodName = NSStringFromSelector(sel);
//    if ([methodName isEqualToString:@"setName:"]) {
//        return class_addMethod(self, sel, (IMP)sendMessage, "v@:@");
//    }
    return NO;
}

void sendMessage(id self, SEL _cmd, NSString *message) {
    NSLog(@"sendMessage：%@", message);
}


/// 2、找备用接收者
- (id)forwardingTargetForSelector:(SEL)aSelector
{
//    NSString *methodName = NSStringFromSelector(aSelector);
//    if ([methodName isEqualToString:@"setName:"]) {
//        return [MessageSendTest2 new];
//    }
    return [super forwardingTargetForSelector:aSelector];
}


/// 3.1、消息签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
//    NSString *methodName = NSStringFromSelector(aSelector);
//    if ([methodName isEqualToString:@"setName:"]) {
//        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
//    }
    return [super methodSignatureForSelector:aSelector];
}

/// 3.2、消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL sel = [anInvocation selector];
    MessageSendTest2 *mst = [MessageSendTest2 new];
    if ([mst respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:mst];
    } else {
        [super forwardInvocation:anInvocation];
    }
}


/// 4、消息还是未处理
- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"消息还是未处理：%@", NSStringFromSelector(aSelector));
}

@end
