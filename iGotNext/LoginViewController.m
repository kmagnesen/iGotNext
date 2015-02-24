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
//    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password: self.passwordTextField.text block:^(PFUser *user, NSError *error) {
//        if (!error) {
//            [self performSegueWithIdentifier:@"EntrySegue" sender:self];
//        } else {
//            [self loginErrorAlert];
//        }
//    }];

    User *user = [[User alloc]initWithInterests:@[] completed:^(BOOL result, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"EntrySegue" sender:self];
        } else {
            [self loginErrorAlert];
            NSLog(@"%@", user);
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
        [self viewDidLoad];
        NSLog(@"Everything is working");
    }
}

//-(void)signupErrorAlert {
//    UIAlertView *signupErrorAlert = [[UIAlertView alloc] initWithTitle:@"😬 UH OH! 😬" message:@"This username has already been claimed. Try Another Username." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    signupErrorAlert.tag = 2;
//    [signupErrorAlert show];
//}

//-(void)successAlert {
//    UIAlertView *successAlert =[[UIAlertView alloc] initWithTitle:@"💥 Boom Shakalaka!!! 💥" message:@"You've Just Created A Profile For One Of The Most Badass Apps On the Planet!" delegate:self cancelButtonTitle:@"Enter!" otherButtonTitles: nil];
//    successAlert.tag = 3;
//    [successAlert show];
//}

//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (alertView.tag == 1) {
//        [self viewDidLoad];
//    } else if (alertView.tag == 2) {
//        [self viewDidLoad];
//    } else if (alertView.tag == 3) {
//        [self performSegueWithIdentifier:@"SignupToInterestsSegue" sender:self];
//    }
//}

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
