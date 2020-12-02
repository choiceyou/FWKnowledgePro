//
//  MyParkProtocol.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/30.
//

NS_ASSUME_NONNULL_BEGIN

@class Iterator;

@protocol MyParkProtocol <NSObject>

@required

- (Iterator *)createIterator;

@end

NS_ASSUME_NONNULL_END
