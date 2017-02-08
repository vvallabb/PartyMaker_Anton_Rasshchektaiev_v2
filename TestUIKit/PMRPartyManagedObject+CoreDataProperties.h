//
//  PMRPartyManagedObject+CoreDataProperties.h
//  Party Maker
//
//  Created by intern on 2/8/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PMRPartyManagedObject.h"

@interface PMRPartyManagedObject(CoreDataProperties)

@property (nonatomic, readwrite) NSString *partyID;
@property (nonatomic, readwrite) NSDate *startDate;
@property (nonatomic, readwrite) NSDate *endDate;
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *logoImageName;
@property (nonatomic, readwrite) NSString *descriptionText;
@property (nonatomic, readwrite) NSDate *creationDate;
@property (nonatomic, readwrite) NSDate *modificationDate;
@property (nonatomic, readwrite) NSString *creatorID;
@property (nonatomic, readwrite) NSString *latitude;
@property (nonatomic, readwrite) NSString *longtitude;

@end
