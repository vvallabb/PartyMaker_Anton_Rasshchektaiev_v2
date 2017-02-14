//
//  CLLocationManager+Utility.h
//  Party Maker
//
//  Created by intern on 2/14/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "LocationManagerDelegate.h"

@interface CLLocationManager(Utility)

+(instancetype) sharedLocationManager;

@end