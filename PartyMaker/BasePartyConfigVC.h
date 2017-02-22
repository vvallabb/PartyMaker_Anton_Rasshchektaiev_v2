//
//  BasePartyConfigVC.h
//  Party Maker
//
//  Created by intern on 2/22/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePartyConfigVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *focusCircle;

@property (weak, nonatomic) IBOutlet UIButton *buttonChooseDate;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPartyName;

@property (weak, nonatomic) IBOutlet UIButton *buttonChooseLocation;

#pragma mark - Sliders outlets
@property (weak, nonatomic) IBOutlet UILabel *labelStartTime;
@property (weak, nonatomic) IBOutlet UILabel *labelEndTime;

@property (weak, nonatomic) IBOutlet UISlider *sliderStartTime;
@property (weak, nonatomic) IBOutlet UISlider *sliderEndTime;

@property (weak, nonatomic) IBOutlet UIView *sliderStartView;
@property (weak, nonatomic) IBOutlet UIView *sliderEndView;

#pragma mark - ScrollView outlets
@property (weak, nonatomic) IBOutlet UIView *scrollViewContainer;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContent;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewLogo;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlLogo;


#pragma mark - DescriptionView outlets
@property (weak, nonatomic) IBOutlet UIView *textViewDescriptionContainer;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (strong, nonatomic) IBOutlet UIToolbar *keyboardForDescriptionToolbar;

#pragma mark - DatePicker outlets
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *datePickerToolbarButtonDone;

#pragma mark - Constraints outlets
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintChooseDateButtonTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDescriptionViewContainerBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFocusCircleTopSpace;

@property (weak, nonatomic) IBOutlet UIView *leftPanelView;

@property (strong, nonatomic) NSString *currDescriptionValue;

- (void)subscribeForKeyboardNotifications;
- (void) moveFocusCircleOnY: (NSInteger) y;
- (NSArray *)getImageNamesArray;

@end
