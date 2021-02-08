//
//  Student2+CoreDataProperties.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/25.
//
//

#import "Student2+CoreDataProperties.h"

@implementation Student2 (CoreDataProperties)

+ (NSFetchRequest<Student2 *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Student2"];
}

@dynamic user_id;
@dynamic name;
@dynamic age;
@dynamic hobby;
@dynamic sex;

@end
