//
//  PMRPartyManagedObject.m
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import "PMRPartyManagedObject.h"

@implementation PMRPartyManagedObject

+ (PMRPartyManagedObject*)fetchPartyWithName:(NSString*)name inContext:(NSManagedObjectContext *)context {
    
    return [self pmr_fetchPartyWithParameterName:@"name" parameterValue:name inContext:context];
}

+ (PMRPartyManagedObject*)createPartyWithName:(NSString*)name inContext:(NSManagedObjectContext *)context {
    
    PMRPartyManagedObject *party = [NSEntityDescription insertNewObjectForEntityForName:@"PMRPartyManagedObject" inManagedObjectContext:context];
    party.name = name;
    
    return party;
}

+ (PMRPartyManagedObject*)fetchPartyWithPartyID:(NSString *)partyID inContext:(NSManagedObjectContext *)context {
    
    return [self pmr_fetchPartyWithParameterName:@"partyID" parameterValue:partyID inContext:context];
}

+ (PMRPartyManagedObject*)createPartyWithPartyID:(NSString *)partyID inContext:(NSManagedObjectContext *)context {
    
    PMRPartyManagedObject *party = [NSEntityDescription insertNewObjectForEntityForName:@"PMRPartyManagedObject" inManagedObjectContext:context];
    party.partyID = partyID;
    
    return party;
}

+ (NSArray<PMRPartyManagedObject*>*)fetchAllPartiesInContext:(NSManagedObjectContext *)context {
    
    return [self pmr_fetchAllPartiesWithPredicate:nil context:context];
}

+ (NSArray<PMRPartyManagedObject *>*)fetchAllPartiesWithIDinContext:(NSManagedObjectContext *)context{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"partyID != nil"];
    return [self pmr_fetchAllPartiesWithPredicate:predicate context:context];
}

+ (NSArray<PMRPartyManagedObject *>*)fetchAllPartiesWithoutIDinContext:(NSManagedObjectContext *)context {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"partyID == nil"];
    return [self pmr_fetchAllPartiesWithPredicate:predicate context:context];
}

+ (NSArray<PMRPartyManagedObject *>*)pmr_fetchAllPartiesWithPredicate:(NSPredicate*)predicate
                                                              context:(NSManagedObjectContext *)context {
    
    NSFetchRequest *fetch = [NSFetchRequest new];
    fetch.entity = [NSEntityDescription entityForName:@"PMRPartyManagedObject" inManagedObjectContext:context];
    if ( predicate ) {
        fetch.predicate = predicate;
    }
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&error];
    if ( error ) {
        NSLog(@"PMRPartyManagedObject pmr_fetchAllPartiesWithPredicate: failed with error %@", error);
    }
    
    return fetchedObjects;
}

#pragma mark Private methods
+ (PMRPartyManagedObject*)pmr_fetchPartyWithParameterName:(NSString *)parameterName
                                           parameterValue:(NSObject *)parameterValue
                                                inContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *fetch = [NSFetchRequest new];
    fetch.entity = [NSEntityDescription entityForName:@"PMRPartyManagedObject" inManagedObjectContext:context];
    fetch.predicate = [NSPredicate predicateWithFormat:@"%K == %@", parameterName, parameterValue];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&error];
    if ( error ) {
        NSLog(@"PMRPartyManagedObject pmr_fetchPartyWithParameterName: failed with error %@", error);
    }
    
    return [fetchedObjects lastObject];
}



@end
