//
//  FWBaseLevelTableViewController.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kFirstLevel;
extern NSString *const kSecondLevel;

@interface FWBaseLevelTableViewController : UITableViewController

/// 数据源
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *dataArray;

@end

NS_ASSUME_NONNULL_END
