//
//  HTTPManager.h
//  Party Maker
//
//  Created by intern on 2/7/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPManager : NSObject

+(instancetype) sharedInstance;

- (NSMutableURLRequest*) getRequestWithType:(NSString*) type headers:(NSArray*) headers method:(NSString*) _method params:(NSDictionary*) _params;

- (NSString*) makeDateRepresentationForAPICall:(NSDate*) _date;

// send the login request
- (NSDictionary*) sendTheLoginRequestWithName: (NSString*) name
                                     password: (NSString*) password;

// send the register request
- (void) sendTheRegisterRequestWithEmail: (NSString*) email
                                password: (NSString*) password
                                    name: (NSString*) name;

// send the creator_id request
- (void) sendTheGetCreator_idRequestWithCreatorID: (NSString*) creator_id;

// send the addParty request
- (void) sendTheAddPartyRequestWithDictionary: (NSDictionary*) dictionary;

// send the deleteParty request
- (void) sendTheDeletePartyRequestWithParty_id: (NSString*) party_id
                                    creator_id: (NSString*) creator_id;

// serialization
- (NSData*) serializationWithDictionary: (NSDictionary *) dictionary;

// deserialization
- (NSDictionary*) deserializationWithData: (NSData *) data;

@end
