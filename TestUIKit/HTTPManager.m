//
//  HTTPManager.m
//  Party Maker
//
//  Created by intern on 2/7/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "HTTPManager.h"

NSString *APIURLLink;

@interface HTTPManager()

@property (nonatomic, strong) NSURLSession *defaultSession;

@end

@implementation HTTPManager

// configure the session
- (void) makeSessionConfigurations {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.defaultSession = [NSURLSession sessionWithConfiguration:sessionConfig];
    APIURLLink = @"http://itworks.in.ua/party/";
}

// received methods
//----------------------------------------------------------------------
- (NSMutableURLRequest*) getRequestWithType:(NSString*) _type headers:(NSArray *) headers method:(NSString*) _method params:(NSDictionary*) _params {
    NSURL *url = [NSURL URLWithString:GetBaseEncodedUrlWithPath(_method)];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:_type];
    if (_params && [_type isEqualToString:@"POST"]) {
        NSMutableString *str = [NSMutableString string];
        for (NSString *key in [_params allKeys]) {
            [str appendString:[NSString stringWithFormat:@"%@=%@&", key, [_params valueForKey:key]]];
        }
        NSData *reqData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        //        NSData *reqData = [NSJSONSerialization dataWithJSONObject:_params options:NSJSONWritingPrettyPrinted error:&error];
        [req setHTTPBody:(error)?nil:reqData];
    } else if (_params) {
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@?", _method];
        for (NSString *key in [_params allKeys]) {
            [str appendString:[NSString stringWithFormat:@"%@=%@&", key, [_params valueForKey:key]]];
        }
        req.URL = [NSURL URLWithString:GetBaseEncodedUrlWithPath(str)];
    }
    return req;
}

- (NSString*) makeDateRepresentationForAPICall:(NSDate*) _date {
    NSString *ret = [NSString stringWithFormat:@"%f", [_date timeIntervalSince1970]];
    if (ret) return ret;
    return @"";
}

NSString *  GetBaseEncodedUrlWithPath(NSString * path) {
    if (!APIURLLink)
        [NSException raise:NSInternalInconsistencyException format:@"API url link not set"];
    NSString *notEncoded = [NSString stringWithFormat:@"%@/%@", APIURLLink, path];
    notEncoded = [notEncoded stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [notEncoded stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
}
//-----------------------------------------------------------------------

// send the login request
- (NSDictionary*) sendTheLoginRequestWithName: (NSString*) name password: (NSString*) password {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"name", password, @"password", nil];
    
    NSMutableURLRequest *request = [self getRequestWithType:@"GET" headers:nil method:@"login" params:params];
    NSURLSessionDataTask *getDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        NSLog(@"%@", dictionaryFromResponse);
    }];
    
    [getDataTask resume];
    
    return nil;
}

// send the register reguest
- (void) sendTheRegisterRequestWithEmail: (NSString*) email
                                password: (NSString*) password
                                    name: (NSString*) name {
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:email, @"email", password, @"password", name, @"name", nil];
    NSMutableURLRequest *request = [self getRequestWithType:@"POST" headers:nil method:@"register" params:params];
    NSURLSessionDataTask *postDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        NSLog(@"%@", dictionaryFromResponse);
    }];
    
    [postDataTask resume];
}

// send the creator_id request
- (void) sendTheGetPartyRequestWithCreatorID: (NSString*) creator_id {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:creator_id, @"creator_id", nil];
    NSMutableURLRequest *request = [self getRequestWithType:@"GET" headers:nil method:@"party" params:params];
    NSURLSessionDataTask *getDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        NSLog(@"%@", dictionaryFromResponse);
    }];
    
    [getDataTask resume];
}

// send the addParty request
- (void) sendTheAddPartyRequestWithDictionary: (NSDictionary*) dictionary {
    NSMutableURLRequest *request = [self getRequestWithType:@"POST" headers:nil method:@"addParty" params:dictionary];
    NSURLSessionDataTask *postDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        NSLog(@"&%@", dictionaryFromResponse);
    }];
    
    [postDataTask resume];
}

// send the deleteParty request
- (void) sendTheDeletePartyRequestWithParty_id: (NSString*) party_id
                                    creator_id: (NSString*) creator_id {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:party_id, @"party_id", creator_id, @"creator_id", nil];
    NSMutableURLRequest *request = [self getRequestWithType:@"GET" headers:nil method:@"deleteParty" params:params];
    NSURLSessionDataTask *getDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        NSLog(@"%@", dictionaryFromResponse);
    }];
    
    [getDataTask resume];
}

// send the allUsers request
- (void) sendTheGetAllUsersRequest {
    NSMutableURLRequest *request = [self getRequestWithType:@"GET" headers:nil method:@"allUsers" params:nil];
    NSURLSessionDataTask *getDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        NSLog(@"%@", dictionaryFromResponse);
    }];
    
    [getDataTask resume];
}

// serialization
- (NSData*) serializationWithDictionary: (NSDictionary *) dictionary {
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    
    return postData;
}

// deserialization
- (NSDictionary*) deserializationWithData: (NSData *) data {
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:(NSData *)data options:NSJSONReadingAllowFragments error:&error];
    
    return dataDictionary;
}

// get singletone instance
+ (instancetype) sharedInstance {
    static HTTPManager *sharedeHTTPManager = nil;
    if (!sharedeHTTPManager) {
        sharedeHTTPManager = [[HTTPManager alloc] init];
        [sharedeHTTPManager makeSessionConfigurations];
    }
    
    return sharedeHTTPManager;
}


@end
