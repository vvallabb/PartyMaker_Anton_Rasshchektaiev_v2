//
//  EditPartyViewController.m
//  Party Maker
//
//  Created by intern on 2/22/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "EditPartyViewController.h"

@interface EditPartyViewController ()

@end

@implementation EditPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureScreen];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Save Button action
- (IBAction)onSaveButtonClicked:(UIBarButtonItem *)sender {
    NSString *logoImageName = [[self getImageNamesArray] objectAtIndex:self.pageControlLogo.currentPage];
        
    self.party = [[PMRParty alloc] initWithPartyID:self.party.partyID name:self.textFieldPartyName.text startDate:[self getDateWithSlider:self.sliderStartTime] endDate:[self getDateWithSlider:self.sliderEndTime] logoImageName:logoImageName descriptionText:self.textViewDescription.text creationDate:[[NSDate alloc] init] modificationDate:nil creatorID:self.buttonChooseLocation.titleLabel.text latitude:@"latitude" longtitude:@"longtitude"];
    
    [[HTTPManager sharedInstance] sendUpdatePartyRequestWith:self.party];
    
    PMRPartyManagedObject *currentParty = [PMRPartyManagedObject fetchPartyWithPartyID:self.party.partyID inContext:[[PMRCoreDataManager sharedStore] mainThreadContext]];
    
    [currentParty setName:self.party.name];
    [currentParty setStartDate:self.party.startDate];
    [currentParty setEndDate:self.party.endDate];
    [currentParty setLogoImageName:self.party.logoImageName];
    [currentParty setDescriptionText:self.party.descriptionText];
    [currentParty setLatitude:self.party.latitude];
    [currentParty setLongtitude:self.party.longtitude];

    [self performSegueWithIdentifier:@"SegueFromEditPartyToPartyList" sender:nil];
}

#pragma mark - Back Button Action
- (IBAction)onBackButtonClicked:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Configure Screen
- (void)configureScreen {
    [self.buttonChooseDate setTitle:[self.formatter stringFromDate:self.party.startDate] forState:UIControlStateNormal];
    
    [self.textFieldPartyName setText:self.party.name];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.party.startDate];
    NSInteger startTimeInMinutes = [components hour] * 60 + [components minute];
    [self.sliderStartTime setValue:startTimeInMinutes];
    [self.labelStartTime setText:[self getTimeStringForSliderLabel:startTimeInMinutes]];
    
    components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.party.endDate];
    NSInteger endTimeInMinutes = [components hour] * 60 + [components minute];
    [self.sliderEndTime setValue:endTimeInMinutes];
    [self.labelEndTime setText:[self getTimeStringForSliderLabel:endTimeInMinutes]];

    int logoID = 0;
    NSArray *imageLogoNames = @[@"No Alcohol-100.png", @"Coconut Cocktail-100.png", @"Christmas Tree-100.png",
                                @"Champagne-100.png", @"Birthday Cake-100.png", @"Beer-100.png"];
    
    for (int i = 0; i < imageLogoNames.count; i++) {
        if ([self.party.logoImageName isEqualToString:imageLogoNames[i]]) {
            logoID = i;
        }
    }
    
    [self.pageControlLogo setCurrentPage:logoID];
    
    [self.textViewDescription setText:self.party.descriptionText];
    [self.buttonChooseLocation setTitle:self.party.creatorID forState:UIControlStateNormal];
}

// separate configuration for scroll view
// because it should configure in viewDidAppear
- (void)configureScrollView {
    CGPoint contentOffset = CGPointMake(self.pageControlLogo.currentPage * self.scrollViewLogo.frame.size.width, 0);
    [self.scrollViewLogo setContentOffset:contentOffset animated:YES];
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
