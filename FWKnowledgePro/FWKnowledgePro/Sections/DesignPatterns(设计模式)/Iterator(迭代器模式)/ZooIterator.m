//
//  ZooIterator.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/30.
//

#import "ZooIterator.h"

@interface ZooIterator ()

@property (nonatomic, strong) NSMutableArray *animalArray;
@property (nonatomic, assign) NSInteger position;

@end


@implementation ZooIterator

- (instancetype)initWithData:(NSMutableArray *)array
{
    self = [super init];
    if (self) {
        self.animalArray = array.mutableCopy;
    }
    return self;
}

- (BOOL)hasNext
{
    if (self.position >= self.animalArray.count || ![self.animalArray objectAtIndex:self.position]) {
        return NO;
    } else {
        return YES;
    }
}

- (id)next
{
    if ([self hasNext]) {
        id object = [self.animalArray objectAtIndex:self.position];
        self.position ++;
        return object;
    } else {
        return nil;
    }
}

@end
