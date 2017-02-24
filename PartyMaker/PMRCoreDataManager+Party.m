//
//  PMRCoreDataManager+Party.m
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import "PMRCoreDataManager+Party.h"
#import "PMRPartyManagedObject.h"
#import "PMRParty.h"
#import "PMRParty+initWithManagedObject.h"

@implementation PMRCoreDataManager (Party)

- (void)addNewParty:(PMRParty*)party completion:(void (^)(BOOL success))completion {
    
    // we shoudn't add a party with the same name
    PMRPartyManagedObject *partyObject = [PMRPartyManagedObject fetchPartyWithName:party.name inContext:self.mainThreadContext];
    if ( partyObject ) {
        if (completion) completion(NO);
    }
    else {
        [self performWriteOperation:^(NSManagedObjectContext *context) {
            PMRPartyManagedObject *partyObject = [PMRPartyManagedObject createPartyWithName:party.name inContext:context];
            partyObject.partyID = party.partyID;
            partyObject.name = party.name;
            partyObject.startDate = party.startDate;
            partyObject.endDate = party.endDate;
            partyObject.logoImageName = party.logoImageName;
            partyObject.descriptionText = party.descriptionText;
            partyObject.creationDate = nil;
            partyObject.modificationDate = party.modificationDate;
            partyObject.creatorID = party.creatorID;
            partyObject.longtitude = party.longtitude;
            partyObject.latitude = party.latitude;
        } completion:^{
            if (completion) completion(YES);
        }];
        
        
        
        [self performWriteOperation:^(NSManagedObjectContext * _Nonnull context) {
            
        } completion:^{
//            [NSThread currentThread].isMainThread == YES
        }];
    }
}

- (NSArray<PMRParty *>*)getParties {
    
    NSArray<PMRPartyManagedObject *>* partyObjectsArray = [PMRPartyManagedObject fetchAllPartiesInContext:self.mainThreadContext];
    
    return [self pmr_convertManagedObjectsToDTO:partyObjectsArray];
}

- (void)deleteAllPartiesWithIDcompletion:(void (^)(BOOL success))completion {
    
    [self performWriteOperation:^(NSManagedObjectContext * _Nonnull context) {
        NSArray<PMRPartyManagedObject *>* partyObjectsArray = [PMRPartyManagedObject fetchAllPartiesWithIDinContext:context];
        for ( PMRPartyManagedObject *managedObject in partyObjectsArray ) {
            [context deleteObject:managedObject];
        }
    }
    completion:^{
        if (completion) completion(YES);
    }];
}

- (NSArray<PMRParty *>*)fetchAllPartiesWithoutIDcompletion:(void (^)(BOOL success))completion {
    
    NSArray<PMRPartyManagedObject *>* partyObjectsArray = [PMRPartyManagedObject fetchAllPartiesWithoutIDinContext:self.mainThreadContext];
    
    return [self pmr_convertManagedObjectsToDTO:partyObjectsArray];
}

- (void)deletePartyWithName:(NSString*)name completion:(void (^)(BOOL success))completion {
    
    [self performWriteOperation:^(NSManagedObjectContext *context) {
        
        PMRPartyManagedObject *partyObject = [PMRPartyManagedObject fetchPartyWithName:name inContext:context];
        if ( partyObject ) {
            [context deleteObject:partyObject];
        }
    }
    completion:^{
        if (completion) completion(YES);
    }];
}

- (NSArray<PMRParty *>*)pmr_convertManagedObjectsToDTO:(NSArray<PMRPartyManagedObject *>*)managedObjectsArray {
    
    NSMutableArray<PMRParty *>* arrayToReturn = [@[] mutableCopy];
    
    for ( PMRPartyManagedObject *partyObject in managedObjectsArray ) {
        PMRParty *party = [[PMRParty alloc] initWithManagedObject:partyObject];
        [arrayToReturn addObject:party];
    }
    
    return arrayToReturn;
}

@end
