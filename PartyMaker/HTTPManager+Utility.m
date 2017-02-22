//
//  HTTPManager+Utility.m
//  Party Maker
//
//  Created by intern on 2/21/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "HTTPManager+Utility.h"

@implementation HTTPManager(Utility)

#pragma mark - Login
- (void)sendLoginRequestWithEmail: (NSString*) email password: (NSString*) password {
    email = @"anton11131113@gmail.com";
    password = @"gg11131113";
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:email, @"email", password, @"password", nil];
    
    NSMutableURLRequest *request = [self getRequestWithType:@"POST" headers:nil method:@"user/login" params:params];
    
    NSURLSessionDataTask *postDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        
        BOOL isCorrectEmail = [[dictionaryFromResponse objectForKey:@"email"] isEqualToString:[params objectForKey:@"email"]];
        
        // save access token to NSUserDefaults
        NSData *accessTokenData = [NSKeyedArchiver archivedDataWithRootObject:[dictionaryFromResponse objectForKey:@"accessToken"]];
        [[NSUserDefaults standardUserDefaults] setObject:accessTokenData forKey:@"accessToken"];
        
        // save creator id to NSUserDefaults
        NSData *creator_idData = [NSKeyedArchiver archivedDataWithRootObject:[dictionaryFromResponse objectForKey:@"id"]];
        [[NSUserDefaults standardUserDefaults] setObject:creator_idData forKey:@"id"];
        
        // perform a segue in LoginScreenVC in case of success request
        if (isCorrectEmail) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.loginScreenVC performSegueWithIdentifier:@"SegueFromLoginScreen" sender:self];
            });
        }
    }];
    
    [postDataTask resume];
}

// send the register reguest
- (void)sendTheRegisterRequestWithEmail: (NSString*) email
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
- (void)sendTheGetPartyRequestWithCreatorID: (NSString*) creator_id {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:creator_id, @"creator_id", nil];
    NSMutableURLRequest *request = [self getRequestWithType:@"GET" headers:nil method:@"party" params:params];
    NSURLSessionDataTask *getDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        NSLog(@"%@", dictionaryFromResponse);
    }];
    
    [getDataTask resume];
}

#pragma mark - Add party
- (void)sendAddPartyRequestWithParty: (PMRParty*) party {
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"accesstoken": @"f3c5a8c4d0e27928906a262f0985b293",
                               @"cache-control": @"no-cache" };
    NSDictionary *parameters = [self convertPartyForRequest:party];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://partymaker-softheme.herokuapp.com/party"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        if ([self.createPartyVC isKindOfClass:[XIBViewController class]]) {
                                                        }
                                                    }
                                                }];
    [dataTask resume];
}

#pragma mark - Delete party
- (void)sendDeletePartyRequestWith:(NSString *)partyID {
    NSString *method = [@"party/" stringByAppendingString:partyID];
    
    NSMutableURLRequest *request = [self getRequestWithType:@"DELETE" headers:nil method:method params:nil];
    [request setValue:[self getAccessToken] forHTTPHeaderField:@"accessToken"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *deleteDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        NSLog(@"%@", dictionaryFromResponse);
    }];
    
    [deleteDataTask resume];
}

#pragma mark - Update party
- (void)sendUpdatePartyRequestWith:(PMRParty *)party {
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"accesstoken": @"f3c5a8c4d0e27928906a262f0985b293",
                               @"cache-control": @"no-cache" };
    NSDictionary *parameters = [self convertPartyForRequest:party];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://partymaker-softheme.herokuapp.com/party/234"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"PATCH"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
                                                        NSLog(@"%@", dictionaryFromResponse);
                                                    }
                                                }];
    [dataTask resume];
}

#pragma mark - Get user
- (void)sendGetUserRequestWith:(NSString*) userID {
    if (!userID) {
        userID = @"";
    }
    NSString *method = [@"user" stringByAppendingString:userID];
    
    NSMutableURLRequest *request = [self getRequestWithType:@"GET" headers:nil method:method params:nil];
    [request setValue:[self getAccessToken] forHTTPHeaderField:@"accessToken"];
    
    NSURLSessionDataTask *getDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        NSLog(@"%@", dictionaryFromResponse);
    }];
    
    [getDataTask resume];
}

#pragma mark - Get all users
- (void)sendGetAllUsersRequest {
    NSMutableURLRequest *request = [self getRequestWithType:@"GET" headers:nil method:@"user" params:nil];
    [request setValue:[self getAccessToken] forHTTPHeaderField:@"accessToken"];
    
    NSURLSessionDataTask *getDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        NSLog(@"%@", dictionaryFromResponse);
    }];
    
    [getDataTask resume];
}


@end
