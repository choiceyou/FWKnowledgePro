//
//  MVCView.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "MVCModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVCView : UIView

- (void)setupView:(MVCModel *)model;

@end

NS_ASSUME_NONNULL_END
