//
//  FWBaseWebViewController.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/4.
//

#import "FWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWBaseWebViewController : FWBaseViewController

+ (instancetype)webVCWithContent:(NSString *)content title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
