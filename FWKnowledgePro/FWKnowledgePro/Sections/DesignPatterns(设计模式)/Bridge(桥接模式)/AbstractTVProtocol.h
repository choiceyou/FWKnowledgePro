//
//  AbstractTVProtocol.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/12/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AbstractTVProtocol <NSObject>

@required

- (void)on;
- (void)off;
- (void)setChannel:(NSInteger)index;
- (void)setVolume:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
