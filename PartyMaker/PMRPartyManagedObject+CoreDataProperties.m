//
//  PMRPartyManagedObject+CoreDataProperties.m
//  Party Maker
//
//  Created by intern on 2/9/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "PMRPartyManagedObject+CoreDataProperties.h"

@implementation PMRPartyManagedObject (CoreDataProperties)

+ (NSFetchRequest<PMRPartyManagedObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PMRPartyManagedObject"];
}

@dynamic name;
@dynamic partyID;
@dynamic startDate;
@dynamic endDate;
@dynamic logoImageNumber;
@dynamic descriptionText;
@dynamic creatorID;
@dynamic latitude;
@dynamic longtitude;

@end
