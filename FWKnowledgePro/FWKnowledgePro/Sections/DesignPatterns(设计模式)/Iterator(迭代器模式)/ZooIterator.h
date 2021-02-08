//
//  ZooIterator.h
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/30.
//

#import <Foundation/Foundation.h>
#import "Iterator.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZooIterator : Iterator

- (instancetype)initWithData:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
