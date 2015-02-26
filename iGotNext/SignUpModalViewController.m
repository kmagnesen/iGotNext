//
//  SignUpViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/22/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

#import "SignUpModalViewController.h"

@interface SignUpModalViewController () <UIAlertViewDelegate, UITextFieldDelegate>

- (void)addSignUpButtons;
- (void)setCredentials:(id)sender;
- (void)cancelSignup:(id)sender;
- (void)dismissKeyboard:(id)sender;

@property NSString *user;
@property NSString *password;

@end

@implementation SignUpModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];

    self.user = [NSString new];
    self.password = [NSString new];

    self.view.layer.cornerRadius = 5.f;
    self.view.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.99];
    [self addSignUpButtons];
    [self addTextFields];
}

- (void)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)addSignUpButtons {
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpButton.translatesAutoresizingMaskIntoConstraints = NO;
    signUpButton.tintColor = [UIColor whiteColor];
    signUpButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Bold" size:26];
    signUpButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [signUpButton.titleLabel setMinimumScaleFactor:.7f];
    [signUpButton.layer setBorderColor: [UIColor colorWithRed:0 green:0.722 blue:0.851 alpha:1].CGColor];
    signUpButton.layer.cornerRadius = 4.0f;
    [[signUpButton layer] setBorderWidth:1.0f];
    [signUpButton setTitle:@" Create New Account " forState:UIControlStateNormal];
    [signUpButton addTarget:self action:@selector(setCredentials:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    cancelButton.tintColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:14];
    cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [cancelButton.titleLabel setMinimumScaleFactor:.7f];
    [cancelButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    cancelButton.layer.cornerRadius = 4.0f;
    [[cancelButton layer] setBorderWidth:1.0f];
    [cancelButton setTitle:@"  Cancel  " forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelSignup:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];

    NSDictionary *viewz = NSDictionaryOfVariableBindings(signUpButton, cancelButton);

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:signUpButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:cancelButton
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[signUpButton(20)]-15-[cancelButton]-45-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewz]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton(20)]-45-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewz]];
}

- (void)addTextFields{

    usernameTF = [UITextField new];
    passwordTF = [UITextField new];

    usernameTF.translatesAutoresizingMaskIntoConstraints = NO;
    usernameTF.backgroundColor = [UIColor whiteColor];
    usernameTF.font = [UIFont fontWithName:@"Avenir" size:12];
    usernameTF.borderStyle = UITextBorderStyleRoundedRect;
    usernameTF.userInteractionEnabled = YES;
    usernameTF.placeholder = @"Enter Desired Username";
    usernameTF.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameTF.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:usernameTF];

    passwordTF.translatesAutoresizingMaskIntoConstraints = NO;
    passwordTF.backgroundColor = [UIColor whiteColor];
    passwordTF.secureTextEntry = YES;
    passwordTF.font = [UIFont fontWithName:@"Avenir" size:12];
    passwordTF.borderStyle = UITextBorderStyleRoundedRect;
    passwordTF.userInteractionEnabled = YES;
    passwordTF.placeholder = @"Enter A Password";
    passwordTF.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordTF.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:passwordTF];

    NSDictionary *views = NSDictionaryOfVariableBindings(usernameTF, passwordTF);

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:usernameTF
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordTF
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:usernameTF
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[usernameTF]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-65-[usernameTF(30)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[passwordTF]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-65-[usernameTF]-[passwordTF(30)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self nextResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self resignFirstResponder];
}

- (void)signupErrorAlert {
    UIAlertView *signupErrorAlert = [[UIAlertView alloc] initWithTitle:@"😬 UH OH! 😬" message:@"This username has already been claimed. Please Try Another." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    signupErrorAlert.tag = 1;
    [signupErrorAlert show];
}

- (void)successAlert {
    UIAlertView *successAlert =[[UIAlertView alloc] initWithTitle:@"💥 Boom Shakalaka!!! 💥" message:@"You've Just Created A Profile For One Of The Best Apps On the Planet!" delegate:self cancelButtonTitle:@"Enter!" otherButtonTitles: nil];
    successAlert.tag = 2;
    [successAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        ;
    } else if (alertView.tag == 2) {
        [self.delegate signUp:self];
    }
}

- (void)setCredentials:(id)sender {
    PFUser *user = [PFUser user];
    user.username = [NSString stringWithFormat:@"%@", usernameTF.text];
    user.password = [NSString stringWithFormat:@"%@", passwordTF.text];
    NSLog(@"User: %@ and Pass:%@", usernameTF.text, passwordTF.text);

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [self signupErrorAlert];
        } else {
            [self successAlert];
            [self.delegate signUp:self];
        }
    }];
}

- (void)cancelSignup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
