//
//  PMRPartyManagedObject.h
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMRPartyManagedObject : NSManagedObject

+ (PMRPartyManagedObject*)fetchPartyWithName:(NSString*)name inContext:(NSManagedObjectContext *)context;
+ (PMRPartyManagedObject*)createPartyWithName:(NSString*)name inContext:(NSManagedObjectContext *)context;

+ (PMRPartyManagedObject*)fetchPartyWithPartyID:(NSString*)partyID inContext:(NSManagedObjectContext *)context;
+ (PMRPartyManagedObject*)createPartyWithPartyID:(NSString*)partyID inContext:(NSManagedObjectContext *)context;

+ (NSArray<PMRPartyManagedObject *>*)fetchAllPartiesInContext:(NSManagedObjectContext *)context;
+ (NSArray<PMRPartyManagedObject *>*)fetchAllPartiesWithIDinContext:(NSManagedObjectContext *)context;
+ (NSArray<PMRPartyManagedObject *>*)fetchAllPartiesWithoutIDinContext:(NSManagedObjectContext *)context;


@end

NS_ASSUME_NONNULL_END

#import "PMRPartyManagedObject+CoreDataProperties.h"
