//
//  PMRParty+_initWithManagedObject.m
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import "PMRParty+initWithManagedObject.h"
#import "PMRPartyManagedObject.h"

@implementation PMRParty (initWithManagedObject)

- (instancetype)initWithManagedObject:(PMRPartyManagedObject*)managedObject {
    
    return [self initWithPartyID:managedObject.partyID
                            name:managedObject.name
                       startDate:managedObject.startDate
                         endDate:managedObject.endDate
                 logoImageNumber:managedObject.logoImageNumber
                 descriptionText:managedObject.descriptionText
                       creatorID:managedObject.creatorID
                        latitude:managedObject.latitude
                      longtitude:managedObject.longtitude];
}

@end
