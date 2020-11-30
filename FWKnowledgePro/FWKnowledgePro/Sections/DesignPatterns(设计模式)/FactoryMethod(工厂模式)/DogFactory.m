//
//  DogFactory.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/27.
//

#import "DogFactory.h"

@implementation DogFactory

+ (id<AnimalProtocol>)createAnimal
{
    return [[Dog alloc] init];
}

@end
