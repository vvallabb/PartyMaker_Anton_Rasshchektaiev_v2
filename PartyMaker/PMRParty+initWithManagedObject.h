//
//  PMRParty+initWithManagedObject.h
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import "PMRParty.h"
@class PMRPartyManagedObject;

@interface PMRParty (initWithManagedObject)

- (instancetype)initWithManagedObject:(PMRPartyManagedObject*)managedObject;

@end
