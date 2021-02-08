//
//  IteratorProtocol.h
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/30.
//

NS_ASSUME_NONNULL_BEGIN

@protocol IteratorProtocol <NSObject>

@optional

- (BOOL)hasNext;
- (id)next;

@end

NS_ASSUME_NONNULL_END
