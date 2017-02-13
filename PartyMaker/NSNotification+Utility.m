//
//  NSNotification+Utility.m
//  Party Maker
//
//  Created by intern on 2/10/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "NSNotification+Utility.h"

@implementation NSNotification(Utility)

+ (void) setUpLocalNotifications {
    UIMutableUserNotificationAction *doneAction = [[UIMutableUserNotificationAction alloc] init];
    doneAction.identifier = @"doneActionIdentifier";
    doneAction.destructive = NO;
    doneAction.title = @"Mark done";
    doneAction.activationMode = UIUserNotificationActivationModeBackground; //UIUserNotificationActivationModeForeground
    doneAction.authenticationRequired = NO;
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"LocalNotificationDefaultCategory";
    [category setActions:@[doneAction] forContext:UIUserNotificationActionContextMinimal];
    [category setActions:@[doneAction] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [[NSSet alloc] initWithArray:@[category]];
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

+(void)createLocalNotification:(PMRParty *)party {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.alertBody = @"Party time!";
    localNotification.alertAction = [NSString stringWithFormat:@"%@ is about to begin!", party.name];
    localNotification.fireDate = [party.startDate dateByAddingTimeInterval:-3600];
    localNotification.userInfo = @{ @"party_id" : party.partyID };
    localNotification.soundName = @"soundName";
    localNotification.repeatInterval = 0; //NSCalendarUnitMonth
    localNotification.category = @"LocalNotificationDefaultCategory";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
