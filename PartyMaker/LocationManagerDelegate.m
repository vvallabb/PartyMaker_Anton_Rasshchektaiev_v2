//
//  LocationManagerDelegate.m
//  Party Maker
//
//  Created by intern on 2/14/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "LocationManagerDelegate.h"

@implementation LocationManagerDelegate

+(instancetype)sharedInstance {
    static LocationManagerDelegate *sharedLocationManagerDelegate = nil;
    if (!sharedLocationManagerDelegate) {
        sharedLocationManagerDelegate = [[LocationManagerDelegate alloc] init];
    }
    
    return sharedLocationManagerDelegate;

}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    
    NSLog(@"latitude %+.6f, longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
}

@end
