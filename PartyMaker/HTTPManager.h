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
@property (nonatomic, strong) UIViewController *createPartyVC;
@property (nonatomic, strong) NSURLSession *defaultSession;

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
