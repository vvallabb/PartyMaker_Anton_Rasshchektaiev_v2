//
//  BasePartyConfigVC.m
//  Party Maker
//
//  Created by intern on 2/22/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "BasePartyConfigVC.h"

@interface BasePartyConfigVC ()

@end

@implementation BasePartyConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTextFieldPartyName];
    [self setUpTextViewDescription];
    [self subscribeForKeyboardNotifications];
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"dd.MM.yyyy"];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setUpScrollViewLogo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)subscribeForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
}

-(void)keyboardWillHide:(NSNotification *)notification
{
}

#pragma mark - ButtonChooseDate handling
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
    [self.buttonChooseDate setTitle:[self.formatter stringFromDate:self.datePicker.date] forState:UIControlStateNormal];
    
    [self onDatePickerToolbarCancel: nil];
}

#pragma mark - Set up the TextFieldPartyName
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

#pragma mark - Set up the sliderStartTime action
- (IBAction)onStartSliderValueChanged:(UISlider *)sender {
    self.labelStartTime.text = [self getTimeStringForSliderLabel:self.sliderStartTime.value];
    
    if (self.sliderStartTime.value > (self.sliderEndTime.value - 30)) {
        [self.sliderEndTime setValue:self.sliderStartTime.value + 30];
        [self onEndSliderValueChanged:self.sliderEndTime];
    }
    
    [self moveFocusCircleOnY:sender.superview.center.y];
}

#pragma mark - Set up the sliderEndTime action
- (IBAction)onEndSliderValueChanged:(UISlider *)sender {
    self.labelEndTime.text = [self getTimeStringForSliderLabel:self.sliderEndTime.value];
    
    if (self.sliderEndTime.value < (self.sliderStartTime.value + 30)) {
        [self.sliderStartTime setValue:self.sliderEndTime.value - 30];
        [self onStartSliderValueChanged:self.sliderStartTime];
    }
    
    [self moveFocusCircleOnY:sender.superview.center.y];
}

#pragma mark - Set up the scrollViewLogo and pageControlLogo
- (void) setUpScrollViewLogo {
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    NSArray *imageNames = [self getImageNamesArray];
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

#pragma mark - set up the TextViewDescription action
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
    
    if ([self.textViewDescription isFirstResponder]) {
        self.constraintChooseDateButtonTopSpace.constant += self.view.frame.size.height / 3;
        self.constraintDescriptionViewContainerBottomSpace.constant -= self.view.frame.size.height / 3;
        
        [UIView animateWithDuration:0.25f animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
    return YES;
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

// supporting method to get an array of image names
- (NSArray *)getImageNamesArray {
    NSArray *imageNamesArray = @[@"No Alcohol-100.png", @"Coconut Cocktail-100.png", @"Christmas Tree-100.png", @"Champagne-100.png", @"Birthday Cake-100.png", @"Beer-100.png"];
    
    return imageNamesArray;
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
