//
//  SignUpViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/22/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Parse/Parse.h>

#import "SignUpModalViewController.h"

@interface SignUpModalViewController () <UIAlertViewDelegate, UITextFieldDelegate>

- (void)addSignUpButtons;
- (void)setCredentials:(id)sender;
- (void)cancelSignup:(id)sender;

@property NSString *user;
@property NSString *password;

@end

@implementation SignUpModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [NSString new];
    self.password = [NSString new];

    self.view.layer.cornerRadius = 5.f;
//    self.view.backgroundColor = [UIColor colorWithRed:0.106 green:0.529 blue:0.722 alpha:1];
    self.view.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.99];
    [self addSignUpButtons];
    [self addTextFields];
}

- (void)addSignUpButtons {
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
    signUpButton.translatesAutoresizingMaskIntoConstraints = NO;
    signUpButton.tintColor = [UIColor whiteColor];
    signUpButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [signUpButton setTitle:@"Create Account" forState:UIControlStateNormal];
    [signUpButton addTarget:self action:@selector(setCredentials:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    cancelButton.tintColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [cancelButton.titleLabel setMinimumScaleFactor:.7f];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
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

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[signUpButton(20)]-[cancelButton]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewz]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton(16)]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewz]];
}

- (void)addTextFields{

    UILabel *userLabel = [UILabel new];
    UILabel *passLabel = [UILabel new];

    userLabel.translatesAutoresizingMaskIntoConstraints = NO;
    userLabel.backgroundColor = [UIColor darkGrayColor];
    userLabel.font = [UIFont fontWithName:@"Avenir" size:10];
    userLabel.text = @"Enter New Username:";
    userLabel.textAlignment = NSTextAlignmentCenter;
    userLabel.adjustsFontSizeToFitWidth = YES;
    [userLabel setMinimumScaleFactor:.7f];
    [userLabel setUserInteractionEnabled:NO];
    [self.view addSubview:userLabel];

    passLabel.translatesAutoresizingMaskIntoConstraints = NO;
    passLabel.backgroundColor = [UIColor darkGrayColor];
    passLabel.font = [UIFont fontWithName:@"Avenir" size:10];
    passLabel.text = @"Enter Password:";
    passLabel.textAlignment = NSTextAlignmentCenter;
    passLabel.adjustsFontSizeToFitWidth = YES;
    [passLabel setMinimumScaleFactor:.7f];
    [passLabel setUserInteractionEnabled:NO];
    [self.view addSubview:passLabel];

    UITextField *usernameTF = [UITextField new];
    UITextField *passwordTF = [UITextField new];

    usernameTF.translatesAutoresizingMaskIntoConstraints = NO;
    usernameTF.backgroundColor = [UIColor whiteColor];
    usernameTF.font = [UIFont fontWithName:@"Avenir" size:12];
    usernameTF.borderStyle = UITextBorderStyleRoundedRect;
    usernameTF.userInteractionEnabled = YES;
    [self.view addSubview:usernameTF];

    passwordTF.translatesAutoresizingMaskIntoConstraints = NO;
    passwordTF.backgroundColor = [UIColor whiteColor];
    passwordTF.secureTextEntry = YES;
    passwordTF.font = [UIFont fontWithName:@"Avenir" size:12];
    passwordTF.borderStyle = UITextBorderStyleRoundedRect;
    passwordTF.userInteractionEnabled = YES;
    [self.view addSubview:passwordTF];

    NSDictionary *views = NSDictionaryOfVariableBindings(userLabel, passLabel, usernameTF, passwordTF);

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[userLabel]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[userLabel(20)]-0-[usernameTF]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[usernameTF]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[usernameTF(20)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passLabel
//                                                          attribute:NSLayoutAttributeCenterX
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:usernameTF
//                                                          attribute:NSLayoutAttributeCenterX
//                                                         multiplier:1.f
//                                                           constant:0.f]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[passLabel]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[usernameTF]-[passLabel(20)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[passwordTF]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[passLabel]-[passwordTF(20)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

        self.user = [NSString stringWithFormat:@"%@", usernameTF.text];
        self.password = passwordTF.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self nextResponder];

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
//        [self viewDidLoad];
    }
    else if (alertView.tag == 2)
    {
        [self performSegueWithIdentifier:@"SignupToInterestsSegue" sender:self];
    }
}

- (void)setCredentials:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.user;
    user.password = self.password;
    NSLog(@"User: %@ and Pass:%@", self.user,self.password);

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            [self signupErrorAlert];
        }
        else
        {
            [self successAlert];
            [self.delegate signUp];
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }];
}

- (void)cancelSignup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
