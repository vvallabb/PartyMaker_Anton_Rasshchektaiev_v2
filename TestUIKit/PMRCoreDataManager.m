//
//  PMRCoreDataManager.m
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import "PMRCoreDataManager.h"
//#import "PMRSettings.h"


@interface PMRCoreDataManager ()

@property(nonatomic, copy) NSString *modelName;
@property(nonatomic, strong) NSURL *storeLocation;
// CoreData stack
@property (nonatomic, strong, readwrite) NSManagedObjectContext *backgroundThreadContext;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *mainThreadContext;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation PMRCoreDataManager

+ (instancetype)sharedStore {
    
    static PMRCoreDataManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[PMRCoreDataManager alloc] initWithModelName:@"model" andStoreLocation:[PMRCoreDataManager defaultStoreURL]];
    });
    return shareInstance;
}

+ (NSURL *)defaultStoreURL {
    
    NSError *error = nil;
    BOOL isDirectory = YES;
    
    NSURL *documentsDirectroy = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( ![fileManager fileExistsAtPath:documentsDirectroy.path isDirectory:&isDirectory] ) {
        [fileManager createDirectoryAtPath:documentsDirectroy.path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (error){
        NSLog(@"Can't create folder for store :%@", error);
    }
    
    NSURL *storeURL = [documentsDirectroy URLByAppendingPathComponent:@"database.sqlite"];
    return storeURL;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithModelName:(NSString *)modelName andStoreLocation:(NSURL *)storeLocation {
    
    self = [super init];
    if (self) {
        self.modelName = modelName;
        self.storeLocation = storeLocation;
    }
    return self;
}

#pragma mark - Accessor methods

- (NSManagedObjectContext *)mainThreadContext {

    if (!_mainThreadContext) {
        _mainThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainThreadContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }

    return _mainThreadContext;
}

- (NSManagedObjectContext *)backgroundThreadContext {

    if (!_backgroundThreadContext) {
        _backgroundThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundThreadContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }

    return _backgroundThreadContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }

    NSError *error = nil;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption       : @YES};

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelName withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];

    NSLog(@"PMRCoreDataManager creating the CoreData persitent store");
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeLocation options:options error:&error]) {
        NSLog(@"error when creating persistentStoreCoordinator, error: %@, userInfo: %@", error, error.userInfo);
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyAnotherContextChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.backgroundThreadContext];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyAnotherContextChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.mainThreadContext];

    return _persistentStoreCoordinator;
}

- (void)performWriteOperation:(void (^)(NSManagedObjectContext *context))writeOperationBlock completion:(void (^ _Nullable )(void))completion {
    
    NSManagedObjectContext *context = self.backgroundThreadContext;
    [context performBlock:^{

        //doing work
        writeOperationBlock(context);
        
        //saving context
        if ( !context.hasChanges ) {
            return;
        }
        
        NSError *error = nil;
        [context save:&error];
        
        if (error) {
            NSLog(@"%s error saving context %@", __PRETTY_FUNCTION__, error);
        }
        
        //calling completion
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
}

- (void)applyAnotherContextChanges:(NSNotification *)notification {
    
    if (notification.object == self.backgroundThreadContext){
        [self applyChangesToContext:self.mainThreadContext fromNotification:notification];
    } else {
        [self applyChangesToContext:self.backgroundThreadContext fromNotification:notification];
    }
}

- (void)applyChangesToContext:(NSManagedObjectContext *)context fromNotification:(NSNotification *)notification {
    
    @synchronized (self) {
        [context performBlock:^{
            [context mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

@end
