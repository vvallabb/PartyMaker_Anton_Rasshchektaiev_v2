//
//  LocationViewController.h
//  Party Maker
//
//  Created by intern on 2/14/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseLocationViewController.h"
#import "EditPartyViewController.h"

@interface LocationViewController : BaseLocationViewController

@property (nonatomic, strong) UIViewController *editPartyVC;

@end
