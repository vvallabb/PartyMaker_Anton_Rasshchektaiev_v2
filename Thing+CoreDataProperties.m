//
//  Thing+CoreDataProperties.m
//  Party Maker
//
//  Created by intern on 2/15/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "Thing+CoreDataProperties.h"

@implementation Thing (CoreDataProperties)

+ (NSFetchRequest<Thing *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Thing"];
}

@dynamic identifier;
@dynamic name;

@end
