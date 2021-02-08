//
//  AbstractAnimal.h
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/30.
//

#import <Foundation/Foundation.h>
#import "AbstractDog.h"
#import "AbstractCat.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AbstractAnimal <NSObject>

@required

- (id<AbstractDog>)createDog;
- (id<AbstractCat>)createCat;

@end

NS_ASSUME_NONNULL_END
