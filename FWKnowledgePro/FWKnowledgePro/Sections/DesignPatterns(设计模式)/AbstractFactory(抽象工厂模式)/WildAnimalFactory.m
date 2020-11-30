//
//  WildAnimalFactory.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/30.
//

#import "WildAnimalFactory.h"
#import "WildDog.h"
#import "WildCat.h"

@implementation WildAnimalFactory

- (nonnull id<AbstractCat>)createCat
{
    return [[WildCat alloc] init];
}

- (nonnull id<AbstractDog>)createDog
{
    return [[WildDog alloc] init];
}

@end
