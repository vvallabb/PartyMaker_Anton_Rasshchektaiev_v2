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
@property (nullable, nonatomic, copy) NSString *partyID;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, copy) NSDate *endDate;
@property (nullable, nonatomic, copy) NSString *logoImageName;
@property (nullable, nonatomic, copy) NSString *descriptionText;
@property (nullable, nonatomic, copy) NSDate *creationDate;
@property (nullable, nonatomic, copy) NSDate *modificationDate;
@property (nullable, nonatomic, copy) NSString *creatorID;
@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *longtitude;

@end

NS_ASSUME_NONNULL_END
