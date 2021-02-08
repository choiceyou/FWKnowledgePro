//
//  RTPerson5.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTPerson5 : NSObject
{
    NSString *name;
    NSString *gender;
}

@property (nonatomic, copy) NSString *nickName;

- (void)eat;
- (void)sleep;

@end

NS_ASSUME_NONNULL_END
