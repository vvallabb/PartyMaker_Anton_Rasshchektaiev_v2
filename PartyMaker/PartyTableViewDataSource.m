//
//  PartyTableViewDataSource.m
//  Party Maker
//
//  Created by intern on 2/23/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "PartyTableViewDataSource.h"

@implementation PartyTableViewDataSource

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PMRPartyManagedObject"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"partyID" ascending:YES]];
    return fetchRequest;
}

@end
