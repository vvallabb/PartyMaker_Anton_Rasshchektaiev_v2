//
//  LocationsShowViewController.m
//  Party Maker
//
//  Created by intern on 2/24/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "LocationsShowViewController.h"

@interface LocationsShowViewController ()

@end

@implementation LocationsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpBarButtonItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Bar Button Items
- (void)setUpBarButtonItems {
    UIBarButtonItem *selectFriendButton = [[UIBarButtonItem alloc] initWithTitle:@"Select friend" style:UIBarButtonItemStylePlain target:self action:@selector(onSelectFriendButtonClicked:)];
    
    self.navigationItem.leftBarButtonItem = selectFriendButton;
    
    UIBarButtonItem *resetButton = [[[UIBarButtonItem alloc] init] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(onResetButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = resetButton;
}

- (void)onSelectFriendButtonClicked:(UIBarButtonItem*) sender {
    [self performSegueWithIdentifier:@"SegueToUsersList" sender:self];
}

- (void)onResetButtonClicked:(UIBarButtonItem*) sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
