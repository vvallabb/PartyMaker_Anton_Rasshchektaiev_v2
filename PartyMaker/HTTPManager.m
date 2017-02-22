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


@end
