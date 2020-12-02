//
//  WildlifeParkIterator.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/30.
//

#import "WildlifeParkIterator.h"

@interface WildlifeParkIterator ()

@property (nonatomic, strong) NSArray *animalArray;
@property (nonatomic, assign) NSInteger position;

@end


@implementation WildlifeParkIterator

- (instancetype)initWithData:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.animalArray = array;
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
