//
//  FWBaseTableViewController.h
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/23.
//  该基类只是在特殊场景下使用一下，不作为真正使用

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWBaseTableViewController : UITableViewController

/// 数据源
@property (nonatomic, strong) NSMutableArray<NSString *> *titleArray;

@end

NS_ASSUME_NONNULL_END
