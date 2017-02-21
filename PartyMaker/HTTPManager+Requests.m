//
//  HTTPManager+Requests.m
//  Party Maker
//
//  Created by intern on 2/21/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "HTTPManager+Requests.h"

@implementation HTTPManager(Requests)

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

# pragma mark - Add party
- (void)sendAddPartyRequestWithParty: (PMRParty*) party {
    NSMutableURLRequest *request = [self getRequestWithType:@"POST" headers:nil method:@"addParty" params:nil];
    NSURLSessionDataTask *postDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        NSLog(@"&%@", dictionaryFromResponse);
    }];
    
    [postDataTask resume];
}

// send the deleteParty request
- (void)sendTheDeletePartyRequestWithParty_id: (NSString*) party_id
                                    creator_id: (NSString*) creator_id {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:party_id, @"party_id", creator_id, @"creator_id", nil];
    NSMutableURLRequest *request = [self getRequestWithType:@"GET" headers:nil method:@"deleteParty" params:params];
    NSURLSessionDataTask *getDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
        NSLog(@"%@", dictionaryFromResponse);
    }];
    
    [getDataTask resume];
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
