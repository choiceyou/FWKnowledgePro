//
//  NSObject+sum.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import <Foundation/Foundation.h>
#import "SumManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (sum)

- (float)FW_makeMgr:(void(^)( SumManager * mgr))block;

@end

NS_ASSUME_NONNULL_END
