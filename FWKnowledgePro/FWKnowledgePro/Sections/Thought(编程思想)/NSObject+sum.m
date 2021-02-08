//
//  NSObject+sum.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "NSObject+sum.h"

@implementation NSObject (sum)

- (float)FW_makeMgr:(void(^)( SumManager * mgr))block
{
    SumManager *mgr = [[SumManager alloc] init];
    block(mgr);
    return mgr.result;
}

@end
