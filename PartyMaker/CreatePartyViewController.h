//
//  XIBViewController.h
//  TestUIKit
//
//  Created by intern on 1/30/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePartyConfigVC.h"
#import "PMRParty.h"
#import "PMRCoreDataManager.h"
#import "PMRCoreDataManager+Party.h"
#import "NSNotification+Utility.h"
#import "HTTPManager.h"

@interface XIBViewController : BasePartyConfigVC 

@property PMRParty *party;

- (void) setPartyLatitude:(float) latitude
       andLongtitude:(float) longtitude;

- (void) setChooseLocationButtonTitle:(NSString*) title;

@end
