//
//  NSNotification+Utility.h
//  Party Maker
//
//  Created by intern on 2/10/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PMRParty.h"

@interface NSNotification(Utility)

+ (void) setUpLocalNotifications;
+ (void) createLocalNotification: (PMRParty*) party;

@end
