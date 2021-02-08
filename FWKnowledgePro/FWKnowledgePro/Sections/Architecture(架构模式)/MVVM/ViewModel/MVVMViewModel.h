//
//  MVVMViewModel.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import <Foundation/Foundation.h>
@class MVVMViewController;

NS_ASSUME_NONNULL_BEGIN

@interface MVVMViewModel : NSObject

- (instancetype)initWithVC:(MVVMViewController *)currentVC;

@end

NS_ASSUME_NONNULL_END
