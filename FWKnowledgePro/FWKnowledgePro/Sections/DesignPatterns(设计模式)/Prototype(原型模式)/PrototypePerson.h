//
//  PrototypePerson.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/27.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "PrototypeJob.h"

typedef NS_ENUM(NSInteger, PrototypeGender) {
    PrototypeGenderMale,    // 男性
    PrototypeGenderFemale,  // 女性
};

NS_ASSUME_NONNULL_BEGIN

@interface PrototypePerson : NSObject <NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) PrototypeGender gender;
@property (nonatomic, strong) PrototypeJob *job;

@end

NS_ASSUME_NONNULL_END
