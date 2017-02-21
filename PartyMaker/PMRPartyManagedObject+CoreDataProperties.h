//
//  PMRPartyManagedObject+CoreDataProperties.h
//  Party Maker
//
//  Created by intern on 2/9/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "PMRPartyManagedObject.h"


NS_ASSUME_NONNULL_BEGIN

@interface PMRPartyManagedObject (CoreDataProperties)

+ (NSFetchRequest<PMRPartyManagedObject *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *partyID;
@property (nullable, nonatomic, copy) NSNumber *startDate;
@property (nullable, nonatomic, copy) NSNumber *endDate;
@property (nullable, nonatomic, copy) NSNumber *logoImageNumber;
@property (nullable, nonatomic, copy) NSString *descriptionText;
@property (nullable, nonatomic, copy) NSNumber *creatorID;
@property (nullable, nonatomic, copy) NSNumber *latitude;
@property (nullable, nonatomic, copy) NSNumber *longtitude;

@end

NS_ASSUME_NONNULL_END
