//
//  DomesticAnimalFactory.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/30.
//

#import "DomesticAnimalFactory.h"
#import "DomesticDog.h"
#import "DomesticCat.h"

@implementation DomesticAnimalFactory

- (nonnull id<AbstractCat>)createCat
{
    return [[DomesticCat alloc] init];
}

- (nonnull id<AbstractDog>)createDog
{
    return [[DomesticDog alloc] init];
}

@end
