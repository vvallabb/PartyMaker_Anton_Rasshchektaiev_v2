//
//  BaseLocationViewController.h
//  Party Maker
//
//  Created by intern on 2/20/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BaseLocationViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

- (void) setUpLocationManager;

@end
