//
//  XIBViewController.m
//  TestUIKit
//
//  Created by intern on 1/30/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "CreatePartyViewController.h"

@interface XIBViewController ()

@property (weak, nonatomic) IBOutlet UIView *focusCircle;

@property (weak, nonatomic) IBOutlet UIButton *buttonChooseDate;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPartyName;

// outlets related to sliders
@property (weak, nonatomic) IBOutlet UILabel *labelStartTime;
@property (weak, nonatomic) IBOutlet UILabel *labelEndTime;

@property (weak, nonatomic) IBOutlet UISlider *sliderStartTime;
@property (weak, nonatomic) IBOutlet UISlider *sliderEndTime;

@property (weak, nonatomic) IBOutlet UIView *sliderStartView;
@property (weak, nonatomic) IBOutlet UIView *sliderEndView;

// outlets related to scroll view
@property (weak, nonatomic) IBOutlet UIView *scrollViewContainer;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContent;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewLogo;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlLogo;


// outlets related to text view description
@property (weak, nonatomic) IBOutlet UIView *textViewDescriptionContainer;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (strong, nonatomic) IBOutlet UIToolbar *keyboardForDescriptionToolbar;

// outlets related to date picker
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *datePickerToolbarButtonDone;

// outlets related to constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintChooseDateButtonTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDescriptionViewContainerBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFocusCircleTopSpace;

@property (weak, nonatomic) IBOutlet UIView *leftPanelView;

@property (strong, nonatomic) NSString *currDescriptionValue;

@end

@implementation XIBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTextFieldPartyName];
    [self setUpTextViewDescription];
    [self subscribeForKeyboardNotifications];
}

- (void)subscribeForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setUpScrollViewLogo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// set up the buttonChooseDateAction
- (IBAction)onButtonChooseDateClick:(UIButton *)sender {
    self.datePickerView.hidden = NO;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.datePickerView.frame = (CGRect){0, self.view.frame.size.height - self.datePickerView.frame.size.height, self.datePickerView.frame.size.width, self.datePickerView.frame.size.height};
    }];
    
    [self moveFocusCircleOnY:sender.center.y];
}

- (IBAction)onDatePickerToolbarCancel:(id)sender {
    [UIView animateWithDuration:0.3f animations:^{
        self.datePickerView.frame = (CGRect){0, self.view.frame.size.height, self.datePickerView.frame.size.width, self.datePickerView.frame.size.height};
        self.datePickerView.hidden = YES;
    }];
    
    self.buttonChooseDate.userInteractionEnabled = YES;
}

- (IBAction)onDatePickerToolBarDone:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:self.datePicker.date];

    [self.buttonChooseDate setTitle:stringFromDate forState:UIControlStateNormal];
    
    [self onDatePickerToolbarCancel: nil];
}

// set up the textFieldPartyName
- (void) setUpTextFieldPartyName {
    UIColor *placeHolderColor = [[UIColor alloc] initWithRed:68/266.f green:72/255.f blue:82/255.f alpha:1.f];
    self.textFieldPartyName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your party name" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    [self.textFieldPartyName setReturnKeyType:UIReturnKeyDone];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self moveFocusCircleOnY:textField.center.y];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

// set up the sliderStartTime action
- (IBAction)onStartSliderValueChanged:(UISlider *)sender {
    self.labelStartTime.text = [self getTimeStringForSliderLabel:self.sliderStartTime.value];
    
    if (self.sliderStartTime.value > (self.sliderEndTime.value - 30)) {
        [self.sliderEndTime setValue:self.sliderStartTime.value + 30];
        [self onEndSliderValueChanged:self.sliderEndTime];
    }
    
    [self moveFocusCircleOnY:sender.superview.center.y];
}

// set up the sliderEndTime action
- (IBAction)onEndSliderValueChanged:(UISlider *)sender {
    self.labelEndTime.text = [self getTimeStringForSliderLabel:self.sliderEndTime.value];
    
    if (self.sliderEndTime.value < (self.sliderStartTime.value + 30)) {
        [self.sliderStartTime setValue:self.sliderEndTime.value - 30];
        [self onStartSliderValueChanged:self.sliderStartTime];
    }
    
    [self moveFocusCircleOnY:sender.superview.center.y];
}

// set up the scrollViewLogo and pageControlLogo
- (void) setUpScrollViewLogo {
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    NSArray *imageNames = [Party getImageNamesArray];
    CGRect frame = self.scrollViewContainer.frame;
    
    for (int i = 0; i < imageNames.count; i++) {
        UIImageView *imageViewTemp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
        imageViewTemp.frame = (CGRectMake(frame.size.width / 3 + frame.size.width * i, frame.size.height / 5, frame.size.width / 3.5f, frame.size.height / 2));
        
        [imageViews addObject:imageViewTemp];
        [self.scrollViewContent addSubview: [imageViews objectAtIndex:i]];
    }
}

- (IBAction)pageControlLogoValueChanged:(id)sender {
    CGPoint contentOffset = CGPointMake(self.pageControlLogo.currentPage * self.scrollViewLogo.frame.size.width, 0);
    [self.scrollViewLogo setContentOffset:contentOffset animated:YES];
    
    [self moveFocusCircleOnY:self.scrollViewContainer.center.y];
}

- (void) scrollViewDidEndDecelerating: (UIScrollView*) scrollView {
    NSInteger currentPage = scrollView.contentOffset.x / self.scrollViewLogo.frame.size.width;
    [self.pageControlLogo setCurrentPage:currentPage];
    
    [self moveFocusCircleOnY:self.scrollViewContainer.center.y];
}

// set up the textViewDescriptionAction
- (void) setUpTextViewDescription {
    self.textViewDescription.inputAccessoryView = self.keyboardForDescriptionToolbar;
}
- (IBAction)onTextViewDescriptionToolbarCancel:(id)sender {
    [self textViewShouldEndEditing:self.textViewDescription];
    
    [self.textViewDescription setText:self.currDescriptionValue];
}
- (IBAction)onTextViewDescriptionToolbarDone:(id)sender {
    [self textViewShouldEndEditing:self.textViewDescription];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.currDescriptionValue = self.textViewDescription.text;
    
    
    self.constraintChooseDateButtonTopSpace.constant -= self.view.frame.size.height / 3;
    self.constraintDescriptionViewContainerBottomSpace.constant += self.view.frame.size.height / 3;
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];

    [self moveFocusCircleOnY: textView.superview.center.y + self.view.frame.size.height / 3];
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self.view endEditing:YES];
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    if ([self.textViewDescription isFirstResponder]) {
        self.constraintChooseDateButtonTopSpace.constant += self.view.frame.size.height / 3;
        self.constraintDescriptionViewContainerBottomSpace.constant -= self.view.frame.size.height / 3;
    
        [UIView animateWithDuration:0.25f animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

// sut up the Save button action
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
    NSMutableArray *partyList = [Party deserializePartyList];
    
    Party *currentParty = [[Party alloc] initWithPartyDate:[self.datePicker date]
                                                 partyName:[self.textFieldPartyName text]
                                            partyStartTime:[self.labelStartTime text]
                                           partyLogoNumber:[self.pageControlLogo currentPage]];
    
    [partyList addObject:currentParty];
    [Party serializePartyList:partyList];
    
    [self performSegueWithIdentifier:@"segueToPartyList" sender:self];
}

// moving focus circle on left panel
- (void) moveFocusCircleOnY: (NSInteger) y {
    NSInteger navigationBarTotalHeight = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    
    self.constraintFocusCircleTopSpace.constant = y - self.focusCircle.frame.size.height / 2 - navigationBarTotalHeight;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

// supproting method to set labels related to the slider views
- (NSString*) getTimeStringForSliderLabel: (float) sliderValue {
    int hours = 0;
    int minutes = sliderValue;
    
    while (minutes > 59) {
        hours++;
        minutes -=60;
    }
    
    NSString *stringHours = [NSString stringWithFormat:@"%02i", hours];
    NSString *stringMinutes = [NSString stringWithFormat:@"%02i", minutes];
    
    NSString *time = [NSString stringWithFormat:@"%@:%@", stringHours, stringMinutes];
    
    return time;
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
