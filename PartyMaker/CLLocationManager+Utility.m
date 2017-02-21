//
//  CLLocationManager+Utility.m
//  Party Maker
//
//  Created by intern on 2/14/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "CLLocationManager+Utility.h"

@implementation CLLocationManager(Utility)

+(instancetype)sharedLocationManager {
    static CLLocationManager *sharedeLocationManager = nil;
    if (!sharedeLocationManager) {
        sharedeLocationManager = [[CLLocationManager alloc] init];
    }
    
    if (!sharedeLocationManager.delegate) {
        sharedeLocationManager.delegate = [LocationManagerDelegate sharedInstance];
    }
    
    return sharedeLocationManager;
}

@end
