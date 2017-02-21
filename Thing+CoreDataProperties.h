//
//  Thing+CoreDataProperties.h
//  Party Maker
//
//  Created by intern on 2/15/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "Thing+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Thing (CoreDataProperties)

+ (NSFetchRequest<Thing *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *identifier;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
