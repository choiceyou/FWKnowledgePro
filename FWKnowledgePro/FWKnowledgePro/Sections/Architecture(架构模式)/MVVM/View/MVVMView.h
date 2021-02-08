//
//  MVVMView.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "MVVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MVVMViewDelegate <NSObject>

@optional

- (void)clickView;

@end


@interface MVVMView : UIView

@property (nonatomic, weak) id<MVVMViewDelegate> delegate;

- (instancetype)initWithViewModel:(MVVMViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
