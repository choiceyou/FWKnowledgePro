//
//  MPPerson.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/2.
//

#import "MPPerson.h"

@interface MPPerson ()

/// .h文件中定义readonly，.m文件中定义readwrite
@property (nonatomic, assign, readwrite) double height;

@end


@implementation MPPerson

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.height = 176;
    }
    return self;
}

@end
