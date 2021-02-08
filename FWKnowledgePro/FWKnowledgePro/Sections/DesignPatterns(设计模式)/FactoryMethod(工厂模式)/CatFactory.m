//
//  CatFactory.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/27.
//

#import "CatFactory.h"

@implementation CatFactory

+ (id<AnimalProtocol>)createAnimal
{
    return [[Cat alloc] init];
}

@end
