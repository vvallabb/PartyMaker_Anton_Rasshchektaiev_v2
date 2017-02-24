//
//  TableViewDataSource.m
//  Party Maker
//
//  Created by air on 24.02.17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "TableViewDataSource.h"

@interface TableViewDataSource ()

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *frc;

@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock cellConfigurationBlock;

@end

@implementation TableViewDataSource

- (instancetype)initWithTableView:(UITableView*)tableView
                          context:(NSManagedObjectContext*)context
                  reuseIdentifier:(NSString*)reuseIdentifier
           cellConfigurationBlock:(TableViewCellConfigureBlock)cellConfigurationBlock {
    
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.context = context;
        self.cellConfigurationBlock = cellConfigurationBlock;
        self.reuseIdentifier = reuseIdentifier;
        
        self.tableView.dataSource = self;
    }
    return self;
}

- (NSFetchRequest*)fetchRequest {
    
    NSAssert(NO, @"Thing method should be implemented properly in child class!");
    
    return nil;
}

- (NSManagedObject*)objectAtIndex:(NSIndexPath*)indexPath {
    
    return [self.frc objectAtIndexPath:indexPath];
}

- (void)setPaused:(BOOL)paused {
    
    _paused = paused;
    
    if ( _paused ) {
        self.frc.delegate = nil;
    }
    else {
        self.frc.delegate = self;
        
        NSError *error = nil;
        [self.frc performFetch:&error];
        if ( error ) {
            NSLog(@"Error happened, %@", error);
        }
        
        [self.tableView reloadData];
    }
}

- (NSFetchedResultsController*)frc {
    
    if ( !_frc ) {
        _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest]
                                                   managedObjectContext:self.context
                                                     sectionNameKeyPath:nil
                                                              cacheName:nil];
        _frc.delegate = self;
    }
    
    return _frc;
}

#pragma mark UITableViewDataSource methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> info = self.frc.sections[section];
    
    return [info numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
    NSManagedObject *object = [self.frc objectAtIndexPath:indexPath];
    
    self.cellConfigurationBlock(cell, object);
    
    return cell;
}

#pragma mark NSFetchedResultsControllerDelegate methods
- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            
            if([[self.tableView indexPathsForVisibleRows] containsObject:indexPath]){
                NSManagedObject *object = [self.frc objectAtIndexPath:indexPath];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                self.cellConfigurationBlock(cell, object);
            }
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
    }
}


@end
