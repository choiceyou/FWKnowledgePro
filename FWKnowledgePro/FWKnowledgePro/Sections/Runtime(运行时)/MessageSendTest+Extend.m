//
//  MessageSendTest+Extend.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/27.
//

#import "MessageSendTest+Extend.h"
#import <objc/runtime.h>

static const void *MSTTypeKey = &MSTTypeKey;

@implementation MessageSendTest (Extend)

- (void)setType:(NSString *)type
{
    objc_setAssociatedObject(self, MSTTypeKey, type, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)type
{
    return objc_getAssociatedObject(self, MSTTypeKey);
}

@end
