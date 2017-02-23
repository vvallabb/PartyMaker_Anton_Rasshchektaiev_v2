//
//  HTTPManager.h
//  Party Maker
//
//  Created by intern on 2/7/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginScreenViewController.h"
#import "CreatePartyViewController.h"
#import "PMRParty.h"

@interface HTTPManager : NSObject

@property (nonatomic, strong) UIViewController *loginScreenVC;
@property (nonatomic, strong) UIViewController *registerScreenVC;
@property (nonatomic, strong) UIViewController *createPartyVC;


@property (nonatomic, strong) NSURLSession *defaultSession;

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

#pragma mark - Supporting methods

+(instancetype) sharedInstance;

- (NSMutableURLRequest*) getRequestWithType:(NSString*) type headers:(NSArray*) headers method:(NSString*) _method params:(NSDictionary*) _params;

- (NSString*) makeDateRepresentationForAPICall:(NSDate*) _date;

// serialization
- (NSData*) serializationWithDictionary: (NSDictionary *) dictionary;

// deserialization
- (NSDictionary*) deserializationWithData: (NSData *) data;

// get data from NSUserDefaults
- (NSString*) getAccessToken;
- (NSString*)getCreatorID;

// party convertion
- (NSDictionary*)convertPartyForRequest:(PMRParty*) party;
- (PMRParty*)convertDictionaryToParty:(NSDictionary*)dictionary;



@end
