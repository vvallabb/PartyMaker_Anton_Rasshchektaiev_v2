//
//  XIBViewController.m
//  TestUIKit
//
//  Created by intern on 1/30/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "CreatePartyViewController.h"
#import "HTTPManager.h"

@interface XIBViewController ()


@end

@implementation XIBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.party = [[PMRParty alloc] init];
    
    [[HTTPManager sharedInstance] setCreatePartyVC:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Set up the Save Button action
- (IBAction)onSaveButtonClicked:(UIBarButtonItem *)sender {
    BOOL dateIsSelected = ![self.buttonChooseDate.titleLabel.text isEqualToString:@"CHOOSE DATE"];
    BOOL nameIsSelected = ![self.textFieldPartyName.text isEqualToString:@""];
    
    if (dateIsSelected && nameIsSelected) {
        [self doTheSaveAction];
    }
    else {
        [self invokeAlertBox];
    }
}

- (void) invokeAlertBox {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Unable to save the party"
                                                                   message:@"Please enter the name and choose the date."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) doTheSaveAction {
    NSString *logoImageName = [[self getImageNamesArray] objectAtIndex:self.pageControlLogo.currentPage];
    
    self.party = [[PMRParty alloc] initWithPartyID:@"234" name:self.textFieldPartyName.text startDate:[self getDateWithSlider:self.sliderStartTime] endDate:[self getDateWithSlider:self.sliderEndTime] logoImageName:logoImageName descriptionText:self.textViewDescription.text creationDate:[[NSDate alloc] init] modificationDate:nil creatorID:self.buttonChooseLocation.titleLabel.text latitude:@"latitude" longtitude:@"longtitude"];
    
    [[HTTPManager sharedInstance] sendAddPartyRequestWithParty:self.party];
    
    
    [NSNotification createLocalNotification:self.party];

    [self performSegueWithIdentifier:@"segueToPartyList" sender:self];
}

- (void) savePartyToCoreData {
    PMRCoreDataManager *coreDataManager = [PMRCoreDataManager sharedStore];
    [coreDataManager addNewParty:self.party completion:^(BOOL success) {
        
    }];
}

# pragma mark - Set up the Choose Location Button action
- (IBAction)onButtonChooseLocationClicked:(UIButton *)sender {
    [self moveFocusCircleOnY:sender.center.y];
    [self performSegueWithIdentifier:@"SequeFromCreatePartyToLocation" sender:self];
}


-(void)setPartyLatitude:(float)latitude andLongtitude:(float)longtitude {
    self.party.latitude = [NSString stringWithFormat:@"%f", latitude];
    self.party.longtitude = [NSString stringWithFormat:@"%f", longtitude];;
}

- (void) setChooseLocationButtonTitle:(NSString *)title {
    [self.buttonChooseLocation setTitle:title forState:UIControlStateNormal];
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
