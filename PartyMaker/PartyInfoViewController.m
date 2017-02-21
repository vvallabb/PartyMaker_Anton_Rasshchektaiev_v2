//
//  PartyInfoViewController.m
//  Party Maker
//
//  Created by intern on 2/20/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "PartyInfoViewController.h"
#import "NSString+Utility.h"

@interface PartyInfoViewController ()

# pragma mark - Labels outlets
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelStartTime;
@property (weak, nonatomic) IBOutlet UILabel *labelEndTime;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;

# pragma mark - Related to Logo properies
@property (weak, nonatomic) IBOutlet UIView *viewCircle;
@property (strong, nonatomic) UIImageView *imageViewLogo;

# pragma mark - Constraints outlets
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopSpaceToAddPhoto;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintAddPhotoHeight;

@end

@implementation PartyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBackButton];
    
    // set text to labels
    [self setUpLabels];
    
    
    self.imageViewLogo = [[UIImageView alloc] init];
    [self.viewCircle addSubview:self.imageViewLogo];
    
    // special spaces and button heights for iPhone5 case
    [self configureSizeForSmallScreen];
}

// set up the circle
- (void)viewDidLayoutSubviews {
    self.viewCircle.layer.cornerRadius = self.viewCircle.frame.size.height / 2;
    self.viewCircle.layer.borderWidth = 3;
    
    UIColor *borderColor = [[UIColor alloc] initWithRed:31/255.f green:34/255.f blue:39/255.f alpha:1.f];
    [self.viewCircle.layer setBorderColor:(borderColor).CGColor];
    [self setUpImageLogo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// configure size for iPhone 5 case
- (void)configureSizeForSmallScreen {
    double screenHeight = self.view.frame.size.height;
    
    if (screenHeight < 600) {
        self.constraintAddPhotoHeight.constant = 32;
        self.constraintTopSpaceToAddPhoto.constant = 11;
    }
}

// set up back button
- (void)setUpBackButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButtonClicked)];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)onBackButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Set up labels
// set up labels
- (void)setUpLabels {
    [self setUpNameLabel];
    [self setUpDescriptionLabel];
    [self setUpDateLabel];
    [self setUpStartTimeLabel];
    [self setUpEndTimeLabel];
}

// set up name label
- (void)setUpNameLabel {
    [self.labelName setText:self.party.name];
}

// set up description label
- (void)setUpDescriptionLabel {
    NSString *descriptionText = self.party.descriptionText;
    
    [self.labelDescription setText:descriptionText];
}

// set up date label
- (void)setUpDateLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    NSInteger startDateSecondsAmount = [self.party.startDate integerValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startDateSecondsAmount];
    
    NSString *stringFromDate = [formatter stringFromDate:startDate];
    [self.labelDate setText:stringFromDate];
}

// set up start time label
- (void)setUpStartTimeLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    
    NSInteger startDateSecondsAmount = [self.party.startDate integerValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startDateSecondsAmount];
    
    NSString *stringFromDate = [formatter stringFromDate:startDate];
    [self.labelStartTime setText:stringFromDate];
}

// set up end time label
- (void)setUpEndTimeLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    
    NSInteger endDateSecondsAmount = [self.party.endDate integerValue];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endDateSecondsAmount];
    
    NSString *stringFromDate = [formatter stringFromDate:endDate];
    [self.labelEndTime setText:stringFromDate];
}

#pragma mark - Set up image logo

//////////////////////////////////
// change later! contains crutch//
//////////////////////////////////
- (void) setUpImageLogo {
    // separate handling no alcohol and coconut cocktail images
    
    NSString *imageName = [NSString getLogoImageNameWithNumber:self.party.logoImageNumber];
    double extraValue = 0;
    
    if ([imageName isEqualToString:@"No Alcohol-100.png"] || [imageName isEqualToString:@"Coconut Cocktail-100.png"]) {
        extraValue = 1;
    }
    
    double xValue = self.viewCircle.frame.size.height / 5.5f;
    double yValue = self.viewCircle.frame.size.height / (7 - extraValue * 2);
    double width = self.viewCircle.frame.size.width / (1.5f + (extraValue / 7));
    double height = self.viewCircle.frame.size.height / (1.5f + (extraValue / 7));
    
    [self.imageViewLogo setImage:[UIImage imageNamed:imageName]];
    [self.imageViewLogo setFrame:CGRectMake(xValue, yValue, width, height)];
}

# pragma mark - Handle buttons actions
- (IBAction)onLocationButtonClicked:(UIButton *)sender {
}

- (IBAction)onEditButtonClicked:(UIButton *)sender {
}

- (IBAction)onDeleteButtonClicked:(UIButton *)sender {
}

#pragma mark - Set up segue to Map
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShowLocationViewController *showLocationVC = segue.destinationViewController;
    showLocationVC.partiesArray = [[NSMutableArray alloc] init];
    [showLocationVC.partiesArray addObject:self.party];
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
