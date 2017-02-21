//
//  PMRPersistanceStore.m
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import "PMRPersistanceStore.h"
//#import "PMRSettings.h"
//#import "PMRUserDefaultsStore.h"
#import "PMRCoreDataManager.h"
#import "PMRCoreDataManager+Party.h"

#define USE_CORE_DATA 1

@implementation PMRPersistanceStore

+ (void)addNewParty:(PMRParty*)party completion:(void (^)(BOOL))completion{
    
#if USE_CORE_DATA
    return [[PMRCoreDataManager sharedStore] addNewParty:party completion:completion];
#else
    return [[PMRUserDefaultsStore sharedStore] addNewParty:party completion:completion];
#endif

}

+ (NSArray<PMRParty *>*)getParties {
    
#if USE_CORE_DATA
    return [[PMRCoreDataManager sharedStore] getParties];
#else
    return [[PMRUserDefaultsStore sharedStore] getParties];
#endif
}

+ (void)deletePartyWithName:(NSString*)name completion:(void (^)(BOOL success))completion {
    
#if USE_CORE_DATA
    return [[PMRCoreDataManager sharedStore] deletePartyWithName:name completion:completion];
#else
    return [[PMRUserDefaultsStore sharedStore] deletePartyWithName:name completion:completion];
#endif
}

+ (void)deleteAllPartiesWithIDcompletion:(void (^)(BOOL success))completion {
    
#if USE_CORE_DATA
    [[PMRCoreDataManager sharedStore] deleteAllPartiesWithIDcompletion:completion];
#else
    #warning Not implemented!
    return nil;
#endif
}

+ (NSArray<PMRParty *>*)fetchAllPartiesWithoutIDcompletion:(void (^)(BOOL success))completion {
    
#if USE_CORE_DATA
    return [[PMRCoreDataManager sharedStore] fetchAllPartiesWithoutIDcompletion:completion];
#else
    #warning Not implemented!
    return nil;
#endif
}


@end
