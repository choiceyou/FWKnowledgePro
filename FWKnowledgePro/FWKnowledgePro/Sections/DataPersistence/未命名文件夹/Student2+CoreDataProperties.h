//
//  Student2+CoreDataProperties.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/25.
//
//

#import "Student2+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Student2 (CoreDataProperties)

+ (NSFetchRequest<Student2 *> *)fetchRequest;

@property (nonatomic) int16_t user_id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSString *hobby;
@property (nullable, nonatomic, copy) NSString *sex;

@end

NS_ASSUME_NONNULL_END
