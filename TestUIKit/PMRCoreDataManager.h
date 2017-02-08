//
//  PMRCoreDataManager.h
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

@class NSManagedObjectID;
@class NSManagedObjectContext;
@class NSPersistentStoreCoordinator;
@import Foundation;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface PMRCoreDataManager : NSObject

+ (instancetype)sharedStore;

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainThreadContext;

- (void)performWriteOperation:(void (^)(NSManagedObjectContext *context))writeOperationBlock completion:(void (^ _Nullable )(void))completion;

@end

NS_ASSUME_NONNULL_END
