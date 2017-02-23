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

#pragma mark - Login
- (void)sendLoginRequestWithEmail: (NSString*) email password: (NSString*) password {
    email = @"anton11131113@gmail.com";
    password = @"gg11131113";
    
    NSDictionary *parameters = @{ @"email": email,
                                  @"password": password};
    
    NSMutableURLRequest *request = [self getRequestWithType:@"POST" address:@"/user/login" params:parameters];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"%@", httpResponse);
            
            NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
            
            [self saveID:[dictionaryFromResponse objectForKey:@"id"] andAccessToken:[dictionaryFromResponse objectForKey:@"accessToken"]];
            
            BOOL isCorrectEmail = [[dictionaryFromResponse objectForKey:@"email"] isEqualToString:email];
            
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

#pragma mark - Register request
- (void)sendRegisterRequestWithEmail: (NSString*) email
                               password: (NSString*) password
                                   name: (NSString*) name {
    NSDictionary *parameters = @{ @"email": email,
                                  @"password": password,
                                  @"name": name};
    
    NSMutableURLRequest *request = [self getRequestWithType:@"POST" address:@"/user/signup" params:parameters];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"%@", httpResponse);
            NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
            
            BOOL isSuccessfullRegister = [email isEqualToString:[dictionaryFromResponse objectForKey:@"email"]];
            
            if (!isSuccessfullRegister) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Unable to register new user"
                                                                                   message:@"Please check the entered information"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alert addAction:defaultAction];
                    [self.registerScreenVC presentViewController:alert animated:YES completion:nil];
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    __weak UIViewController *weakRegisterScreenVC = self.registerScreenVC;
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thank you for registration!"
                                                                                   message:@"Please tap OK to contunue."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {[weakRegisterScreenVC performSegueWithIdentifier:@"SegueFromRegisterScreenToLoginScreen" sender:nil];}];
                    
                    [alert addAction:defaultAction];
                    [self.registerScreenVC presentViewController:alert animated:YES completion:nil];
                });
            }
            
            [self saveID:[dictionaryFromResponse objectForKey:@"id"] andAccessToken:[dictionaryFromResponse objectForKey:@"accessToken"]];
        }
    }];
    
    [dataTask resume];
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
                                                        NSDictionary *dictionaryFromResponse = [self deserializationWithData:data];
                                                        
                                                         NSLog(@"%@", httpResponse);
                                                        
                                                        XIBViewController *createPartyVC = (XIBViewController*) self.createPartyVC;
                                                        
                                                        [createPartyVC setParty:[self convertDictionaryToParty:dictionaryFromResponse]];
                                                        
                                                        [createPartyVC savePartyToCoreData];
                                                    }
                                                }];
    [dataTask resume];
}

#pragma mark - Delete party
- (void)sendDeletePartyRequestWith:(NSString *)partyID {
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"accesstoken": [self getAccessToken],
                               @"cache-control": @"no-cache" };
    NSString *completedURL = [APIURLLink stringByAppendingString:[@"/party/" stringByAppendingString:partyID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:completedURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"DELETE"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"Method completed!");
                                                        
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];}

#pragma mark - Update party
- (void)sendUpdatePartyRequestWith:(PMRParty *)party {
    
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"accesstoken": @"f3c5a8c4d0e27928906a262f0985b293",
                               @"cache-control": @"no-cache" };
    NSDictionary *parameters = [self convertPartyForRequest:party];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSString *completeURL = [[APIURLLink stringByAppendingString:@"/party/"] stringByAppendingString:party.partyID];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:completeURL]
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
                                                        
                                                        
                                                    }
                                                }];
    [dataTask resume];
}

# pragma mark - Get Request with parameters
- (NSMutableURLRequest*)getRequestWithType:(NSString*) type
                                   address:(NSString*) address
                                    params:(NSDictionary*) params {
    NSDictionary *headers = @{ @"content-type": @"application/json",
                               @"accesstoken": @"f3c5a8c4d0e27928906a262f0985b293",
                               @"cache-control": @"no-cache" };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    
    NSString *completeURL = [APIURLLink stringByAppendingString:address];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:completeURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:type];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];

    return request;
}

#pragma mark - Save Info to NSUserDefaults
- (void)saveID:(NSString*) id andAccessToken:(NSString*) accessToken {
    // save creator id to NSUserDefaults
    NSData *creator_idData = [NSKeyedArchiver archivedDataWithRootObject:id];
    [[NSUserDefaults standardUserDefaults] setObject:creator_idData forKey:@"id"];
    
    // save access token to NSUserDefaults
    NSData *accessTokenData = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
    [[NSUserDefaults standardUserDefaults] setObject:accessTokenData forKey:@"accessToken"];
}

#pragma mark - Get Info from NSUserDefaults
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

#pragma mark - Converting JSON

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

#pragma mark - Singletone
+ (instancetype) sharedInstance {
    static HTTPManager *sharedeHTTPManager = nil;
    if (!sharedeHTTPManager) {
        sharedeHTTPManager = [[HTTPManager alloc] init];
        [sharedeHTTPManager makeSessionConfigurations];
        sharedeHTTPManager.logoImageNamesArray = @[@"No Alcohol-100.png", @"Coconut Cocktail-100.png", @"Christmas Tree-100.png",@"Champagne-100.png", @"Birthday Cake-100.png", @"Beer-100.png"];
    }
    
    return sharedeHTTPManager;
}

@end
