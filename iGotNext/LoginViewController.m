//
//  ViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Parse/Parse.h>

#import "LoginViewController.h"
#import "SignUpModalViewController.h"
#import "InterestsViewController.h"
#import "PresentingAnimation.h"
#import "DismissingAnimation.h"
#import "User.h"

@interface LoginViewController () <UIAlertViewDelegate, UITextFieldDelegate, UIViewControllerTransitioningDelegate, SignUpMVCDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //tap anywhere and the keyboard goes away
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];

    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

-(void)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)signUp:(SignUpModalViewController *)vc {
    [vc dismissViewControllerAnimated:true completion:^{
        [self performSegueWithIdentifier:@"InterestSegue" sender:self];
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onLoginButtonTapped:(UIButton *)sender {
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password: self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"EntrySegue" sender:self];
        } else {
            [self loginErrorAlert];
        }
    }];
}

- (IBAction)onNewAccountButtonTapped:(UIButton *)sender {
    SignUpModalViewController *signUpMVC = [SignUpModalViewController new];

    signUpMVC.delegate = self;
    signUpMVC.transitioningDelegate = self;
    signUpMVC.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:signUpMVC animated:YES completion:NULL];
}

- (void)loginErrorAlert {
    UIAlertView *loginErrorAlert = [[UIAlertView alloc] initWithTitle:@"🚫 ERROR! 🚫" message:@"A Login Error Has Occured. Please Check Credentials & Retry Login." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    loginErrorAlert.tag = 1;
    [loginErrorAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        self.usernameTextField.text = @"";
        self.passwordTextField.text = @"";
        NSLog(@"Everything is working");
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return [PresentingAnimation new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [DismissingAnimation new];
}

@end
