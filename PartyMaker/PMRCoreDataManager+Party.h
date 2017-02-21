//
//  PMRCoreDataManager+Party.h
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import "PMRCoreDataManager.h"
@class PMRParty;

NS_ASSUME_NONNULL_BEGIN

@interface PMRCoreDataManager (Party)

- (void)addNewParty:(PMRParty*)party completion:(void (^)(BOOL success))completion;

- (NSArray<PMRParty *>*)getParties;

- (void)deleteAllPartiesWithIDcompletion:(void (^)(BOOL success))completion;

- (NSArray<PMRParty *>*)fetchAllPartiesWithoutIDcompletion:(void (^)(BOOL success))completion;

- (void)deletePartyWithName:(NSString*)name completion:(void (^)(BOOL success))completion;;

@end

NS_ASSUME_NONNULL_END
