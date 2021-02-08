//
//  FactoryProtocol.h
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/27.
//

#import <Foundation/Foundation.h>
#import "AnimalProtocol.h"

@protocol FactoryProtocol <NSObject>

@required

+ (id<AnimalProtocol>)createAnimal;

@end
