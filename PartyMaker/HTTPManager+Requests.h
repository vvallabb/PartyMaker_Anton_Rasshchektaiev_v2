//
//  HTTPManager+Requests.h
//  Party Maker
//
//  Created by intern on 2/23/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "HTTPManager.h"

@interface HTTPManager (Requests)

#pragma mark - Requests

// login
- (void)sendLoginRequestWithEmail: (NSString*) email
                         password: (NSString*) password;

// register
- (void)sendRegisterRequestWithEmail: (NSString*) email
                            password: (NSString*) password
                                name: (NSString*) name;

// send the party request
- (void)sendTheGetPartyRequestWithCreatorID: (NSString*) creator_id;

// add party
- (void)sendAddPartyRequestWithParty: (PMRParty*) party;

// delete party
- (void)sendDeletePartyRequestWith:(NSString*) partyID;

// update party
- (void)sendUpdatePartyRequestWith:(PMRParty*) party;

// get user
- (void)sendGetUserRequestWith:(NSString*) userID;

// get all users
- (void)sendGetAllUsersRequest;


@end
