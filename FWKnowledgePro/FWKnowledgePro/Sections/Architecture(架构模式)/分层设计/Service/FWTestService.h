//
//  FWTestService.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWTestService : NSObject

+ (void)loadData:(NSDictionary *)params success:(void(^)(NSDictionary *result))successBlock failure:(void(^)(NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
