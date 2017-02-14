//
//  TestHTTPManager.m
//  Party Maker
//
//  Created by intern on 2/13/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "TestHTTPManager.h"

@implementation TestHTTPManager

- (void)testHTTP {
    HTTPManager *httpManager = [HTTPManager sharedInstance];
    //[httpManager sendTheGetAllUsersRequest];
    
    [httpManager sendTheLoginRequestWithName:@"anton1113" password:@"myPass"];
    
}

@end
