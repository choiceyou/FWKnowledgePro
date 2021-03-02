//
//  FWProxy.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/22.
//

#import "FWProxy.h"

@interface FWProxy ()

/// 注意：这里是一个弱指针
@property (nonatomic, weak) id target;

@end

@implementation FWProxy

+ (instancetype)proxyWithTarget:(id)target
{
    // 注意：NSProxy这个类没有init方法
    FWProxy *proxy = [FWProxy alloc];
    proxy.target = target;
    return proxy;
}


#pragma mark -
#pragma mark - 消息转发方法

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}

@end
