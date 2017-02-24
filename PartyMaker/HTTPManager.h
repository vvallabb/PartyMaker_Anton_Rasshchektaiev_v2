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
#import "PMRCoreDataManager+Party.h"

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

// add party
- (void)sendAddPartyRequestWithParty: (PMRParty*) party;

// delete party
- (void)sendDeletePartyRequestWith:(NSString*) partyID;

// update party
- (void)sendUpdatePartyRequestWith:(PMRParty*) party;

// get all parties
- (void)sendGetAllPartiesRequest;

#pragma mark - Supporting methods

+(instancetype) sharedInstance;

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
