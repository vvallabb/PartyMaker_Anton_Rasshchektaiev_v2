//
//  RegisterScreenViewController.m
//  Party Maker
//
//  Created by intern on 2/23/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "RegisterScreenViewController.h"

@interface RegisterScreenViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UILabel *labelRegistration;
@property (weak, nonatomic) IBOutlet UILabel *labelEnterInfo;

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentViewTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentViewBottomSpace;

@end

@implementation RegisterScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainView.layer.borderWidth = 1;
    [self.mainView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self setUpTextFields];
    
    // add keyboard observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTextFields {
    UIColor *placeHolderColor = [[UIColor alloc] initWithRed:76/255.f green:82/255.f blue:92/255.f alpha:1.f];
    
    self.textFieldEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
    [self.textFieldEmail setReturnKeyType:UIReturnKeyDone];
    
    self.textFieldPassword.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Password" attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
    [self.textFieldPassword setReturnKeyType:UIReturnKeyDone];
    
    self.textFieldName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
    [self.textFieldName setReturnKeyType:UIReturnKeyDone];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.textFieldPassword) {
        self.constraintContentViewTopSpace.constant -= self.view.frame.size.height / 10;
        self.constraintContentViewBottomSpace.constant += self.view.frame.size.height / 10;
    }
    else if (textField == self.textFieldName) {
        self.constraintContentViewTopSpace.constant -= self.view.frame.size.height / 7;
        self.constraintContentViewBottomSpace.constant += self.view.frame.size.height / 7;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];

    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == self.textFieldPassword || textField == self.textFieldName) {
        self.constraintContentViewBottomSpace.constant = 0;
        self.constraintContentViewTopSpace.constant = 0;
    }
    
    [self.view endEditing:YES];
    return YES;
}

- (void)keyboardDidHide:(NSNotification*) notification {
    
}

- (void) keyboardDidShow:(NSNotification*) notification {
    
}

#pragma mark - Sign Up button action
- (IBAction)onSignUpButtonClicked:(UIButton *)sender {
    NSString *email = self.textFieldEmail.text;
    NSString *password = self.textFieldPassword.text;
    NSString *name = self.textFieldName.text;
    
    HTTPManager *httpManager = [HTTPManager sharedInstance];
    [httpManager setRegisterScreenVC:self];
    [httpManager sendRegisterRequestWithEmail:email password:password name:name];
}

#pragma mark - Back button anctio
- (IBAction)onBackButtonClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:@"SegueFromRegisterScreenToLoginScreen" sender:nil];
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
