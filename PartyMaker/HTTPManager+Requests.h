//
//  HTTPManager+Requests.h
//  Party Maker
//
//  Created by intern on 2/21/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPManager.h"
#import "PMRParty.h"

@interface HTTPManager(Requests)

// send the login request
- (void)sendLoginRequestWithEmail: (NSString*) email
                            password: (NSString*) password;

// send the register request
- (void)sendTheRegisterRequestWithEmail: (NSString*) email
                                password: (NSString*) password
                                    name: (NSString*) name;

// send the party request
- (void)sendTheGetPartyRequestWithCreatorID: (NSString*) creator_id;

// add party request
- (void)sendAddPartyRequestWithParty: (PMRParty*) party;

// send the deleteParty request
- (void)sendTheDeletePartyRequestWithParty_id: (NSString*) party_id
                                    creator_id: (NSString*) creator_id;

// get user request
- (void)sendGetUserRequestWith:(NSString*) userID;

// get all users request
- (void)sendGetAllUsersRequest;

@end
