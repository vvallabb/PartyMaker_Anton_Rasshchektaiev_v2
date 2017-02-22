//
//  HTTPManager+Utility.h
//  Party Maker
//
//  Created by intern on 2/21/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPManager.h"

@interface HTTPManager(Utility)

// send the login request
- (void)sendLoginRequestWithEmail: (NSString*) email
                         password: (NSString*) password;

// send the register request
- (void)sendTheRegisterRequestWithEmail: (NSString*) email
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
