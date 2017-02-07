//
//  AppDelegate.m
//  TestUIKit
//
//  Created by intern on 1/27/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "AppDelegate.h"
#import "HTTPManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBarTintColor:[[UIColor alloc] initWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1.f]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //[[UINavigationBar appearance] setTranslucent:NO];
    
    // HTTP homework testing
    //-----------------------------------------------------------------------------------------------------------------
    HTTPManager *httpManager = [HTTPManager sharedInstance];
    [httpManager sendTheRegisterRequestWithEmail:@"anton11131113gmail.com" password:@"myPass" name:@"anton1113"];
    [httpManager sendTheLoginRequestWithName:@"anton1113" password:@"myPass"];
    
    NSArray *keys = @[@"party_id", @"name", @"start_time", @"end_time", @"logo_id", @"comment", @"creator_id", @"latitude", @"longitude"];
    NSArray *objects = @[@"1113", @"partyhard", @"13 00", @"04 00", @"1", @"no comments", @"422", @"nil", @"anotherNil"];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    [httpManager sendTheAddPartyRequestWithDictionary:dict];
    
    [httpManager sendTheGetPartyRequestWithCreatorID:@"426"];
    [httpManager sendTheDeletePartyRequestWithParty_id:@"1113" creator_id:@"422"];
    [httpManager sendTheGetAllUsersRequest];
    //------------------------------------------------------------------------------------------------------------------
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
