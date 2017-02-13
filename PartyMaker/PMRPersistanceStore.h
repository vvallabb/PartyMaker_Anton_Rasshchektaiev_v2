//
//  PMRPersistanceStore.h
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PMRParty;

@interface PMRPersistanceStore : NSObject

+ (void)addNewParty:(PMRParty*)party completion:(void (^)(BOOL success))completion;
+ (NSArray<PMRParty *>*)getParties;
+ (void)deletePartyWithName:(NSString*)name completion:(void (^)(BOOL success))completion;
+ (void)deleteAllPartiesWithIDcompletion:(void (^)(BOOL success))completion;
+ (NSArray<PMRParty *>*)fetchAllPartiesWithoutIDcompletion:(void (^)(BOOL success))completion;

@end
