//
//  CYPerson.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/9.
//

#import "CYPerson.h"

@implementation CYPerson

+ (void)load
{
    NSLog(@"CYPerson load");
}

+ (void)initialize
{
    if (self == [CYPerson class]) {
        
    }
    NSLog(@"CYPerson initialize");
}

@end
