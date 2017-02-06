//
//  LoginScreenViewController.m
//  TestUIKit
//
//  Created by intern on 2/6/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "LoginScreenViewController.h"

@interface LoginScreenViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelHello;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLogin;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@end

@implementation LoginScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpTextFieldLogin];
    [self setUpTextFieldPassword];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTextFieldLogin {
    UIColor *placeHolderColor = [[UIColor alloc] initWithRed:76/266.f green:82/255.f blue:92/255.f alpha:1.f];
    self.textFieldLogin.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Login" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    [self.textFieldLogin setReturnKeyType:UIReturnKeyDone];
}

- (void)setUpTextFieldPassword {
    UIColor *placeHolderColor = [[UIColor alloc] initWithRed:76/266.f green:82/255.f blue:92/255.f alpha:1.f];
    self.textFieldPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    [self.textFieldPassword setReturnKeyType:UIReturnKeyDone];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    
    if (textField == self.textFieldPassword) {
        [UIView animateWithDuration:0.3f animations:^{
            [self.view setFrame:CGRectMake(0,-20,self.view.frame.size.width, self.view.frame.size.height)];
        }];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    if (textField == self.textFieldPassword) {
        [UIView animateWithDuration:0.3f animations:^{
            [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        }];
    }
    
    [self.view endEditing:YES];
    return YES;
}

- (void)keyboardDidHide:(NSNotification*) notification {
    
}

- (void) keyboardDidShow:(NSNotification*) notification {
    
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
