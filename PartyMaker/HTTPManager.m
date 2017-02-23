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

@property (nonatomic, strong) NSArray *logoImageNamesArray;

@end

@implementation HTTPManager

#pragma mark - Make configurations for the session
- (void) makeSessionConfigurations {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.defaultSession = [NSURLSession sessionWithConfiguration:sessionConfig];
    APIURLLink = @"https://partymaker-softheme.herokuapp.com";
}

#pragma mark - Request configurators
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
//    if (_params) {
//        NSData *data = [NSJSONSerialization dataWithJSONObject:_params options:0 error:nil];
//        [req setHTTPBody:data];
//    }
    
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

#pragma mark - Supporting methods
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
        sharedeHTTPManager.logoImageNamesArray = @[@"No Alcohol-100.png", @"Coconut Cocktail-100.png", @"Christmas Tree-100.png",@"Champagne-100.png", @"Birthday Cake-100.png", @"Beer-100.png"];
    }
    
    return sharedeHTTPManager;
}

// get access token from User Defaults
- (NSString*)getAccessToken {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return accessToken;
}

// get creator_id from User Defaults
- (NSString*)getCreatorID {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    NSString *creatorID = [NSString stringWithFormat:@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    return creatorID;
}

#pragma mark - Party Convertion

// convert PMRParty instance to NSDictionary for requests param
- (NSDictionary*)convertPartyForRequest:(PMRParty *)party {
    double startDateTimeInterval = [party.startDate timeIntervalSince1970];
    NSNumber *numberStartDate = [NSNumber numberWithDouble:startDateTimeInterval];
    
    double endDateTimeInterval = [party.endDate timeIntervalSince1970];
    NSNumber *numberEndDate = [NSNumber numberWithDouble:endDateTimeInterval];
    
    double latitude = [party.latitude doubleValue];
    NSNumber *numberLatitude = [NSNumber numberWithDouble:latitude];
    
    double longtitude = [party.longtitude doubleValue];
    NSNumber *numberLongtitude = [NSNumber numberWithDouble:longtitude];
    
    int logoID = 0;
    
    for (int i = 0; i < self.logoImageNamesArray.count; i++) {
        if ([party.logoImageName isEqualToString:self.logoImageNamesArray[i]]) {
            logoID = i;
        }
    }
    
    NSNumber *numberLogoID = [NSNumber numberWithInt:logoID];
    
    NSDictionary *convertedParty = @{ @"name": party.name,
                                      @"start_time": numberStartDate,
                                      @"end_time": numberEndDate,
                                      @"logo_id": numberLogoID,
                                      @"comment": party.descriptionText,
                                      @"latitude": numberLatitude,
                                      @"longitude": numberLongtitude };
    return convertedParty;
}

// convert NSDictionary from server response to PMRParty instance
- (PMRParty*)convertDictionaryToParty:(NSDictionary*)dictionary {
    NSString *partyName = [dictionary objectForKey:@"name"];
    
    NSNumber *numberStartDate = [dictionary objectForKey:@"start_time"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[numberStartDate doubleValue]];
    
    NSNumber *numberEndDate = [dictionary objectForKey:@"end_time"];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[numberEndDate doubleValue]];
    
    NSNumber *numberLogoID = [dictionary objectForKey:@"logo_id"];
    NSString *logoImageName = [self.logoImageNamesArray objectAtIndex:[numberLogoID integerValue]];
    
    NSString *descriptionText = [dictionary objectForKey:@"comment"];
    
    NSString *latitude = [NSString stringWithFormat:@"%f", [[dictionary objectForKey:@"latitude"] doubleValue]];
    
    NSString *longtitude = [NSString stringWithFormat:@"%f", [[dictionary objectForKey:@"longtitude"] doubleValue]];
    
    NSString *partyID = [NSString stringWithFormat:@"%li", [[dictionary objectForKey:@"id"] integerValue]];
    
    PMRParty *party = [[PMRParty alloc] initWithPartyID:partyID name:partyName startDate:startDate endDate:endDate logoImageName:logoImageName descriptionText:descriptionText creationDate:nil modificationDate:nil creatorID:[self getCreatorID] latitude:latitude longtitude:longtitude];
    
    return party;
}

#pragma mark - Requests

#pragma mark - Login
- (void)sendLoginRequestWithEmail: (NSString*) email password: (NSString*) password {
//    email = @"anton11131113@gmail.com";
//    password = @"gg11131113";
//    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:email, @"email", password, @"password", nil];
//    
//    NSMutableURLRequest *request = [self getRequestWithType:@"POST" headers:nil method:@"user/login" params:params];
//    
//    NSURLSessionDataTask *postDataTask = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
//        
//        BOOL isCorrectEmail = [[dictionaryFromResponse objectForKey:@"email"] isEqualToString:[params objectForKey:@"email"]];
//        
//        // save access token to NSUserDefaults
//        NSData *accessTokenData = [NSKeyedArchiver archivedDataWithRootObject:[dictionaryFromResponse objectForKey:@"accessToken"]];
//        [[NSUserDefaults standardUserDefaults] setObject:accessTokenData forKey:@"accessToken"];
//        
//        // save creator id to NSUserDefaults
//        NSData *creator_idData = [NSKeyedArchiver archivedDataWithRootObject:[dictionaryFromResponse objectForKey:@"id"]];
//        [[NSUserDefaults standardUserDefaults] setObject:creator_idData forKey:@"id"];
//        
//        // perform a segue in LoginScreenVC in case of success request
//        if (isCorrectEmail) {
//            dispatch_async(dispatch_get_main_queue(), ^(void){
//                [self.loginScreenVC performSegueWithIdentifier:@"SegueFromLoginScreen" sender:self];
//            });
//        }
//    }];
//    
//    [postDataTask resume];
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"cache-control": @"no-cache"};
    NSDictionary *parameters = @{ @"email": email,
                                  @"password": password};
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://partymaker-softheme.herokuapp.com/user/login"]
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
                                                        
                                                        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
                                                        
                                                                BOOL isCorrectEmail = [[dictionaryFromResponse objectForKey:@"email"] isEqualToString:email];
                                                        
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
                                                    }
                                                }];
    [dataTask resume];
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

//////////////////////
/// get request //////
//////////////////////
- (NSMutableURLRequest*)getRequestWithType:(NSString*) type
                                   headers:(NSDictionary*) headers
                                   address:(NSString*) address
                                    params:(NSDictionary*) params {
    return nil;
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
