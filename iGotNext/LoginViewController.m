//
//  ViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"%@", currentUser);

}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:YES];
//
//
//}

- (IBAction)onLoginButtonTapped:(UIButton *)sender {
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password: self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if  (error) {
            [self loginErrorAlert];
        }
        else
        {
            if (user[@"interests"] == Nil) {
            [self performSegueWithIdentifier:@"LoginToInterestsSegue" sender:self];
            } else {
                [self performSegueWithIdentifier:@"ByPassInterestsSegue" sender:self];
            }

        }
    }];
}

- (IBAction)onNewAccountButtonTapped:(UIButton *)sender {
    PFUser* user = [PFUser user];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            [self signupErrorAlert];
        }
        else
        {
            [self successAlert];
        }
    }];

}

- (void)loginErrorAlert {
    UIAlertView *loginErrorAlert = [[UIAlertView alloc] initWithTitle:@"🚫 ERROR! 🚫" message:@"A Login Error Has Occured. Please Check Credentials & Retry Login." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    loginErrorAlert.tag = 1;
    [loginErrorAlert show];
}

-(void)signupErrorAlert {
    UIAlertView *signupErrorAlert = [[UIAlertView alloc] initWithTitle:@"😬 UH OH! 😬" message:@"This username has already been claimed. Try Another Username." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    signupErrorAlert.tag = 2;
    [signupErrorAlert show];
}

-(void)successAlert {
    UIAlertView *successAlert =[[UIAlertView alloc] initWithTitle:@"💥 Boom Shakalaka!!! 💥" message:@"You've Just Created A Profile For One Of The Most Badass Apps On the Planet!" delegate:self cancelButtonTitle:@"Enter!" otherButtonTitles: nil];
    successAlert.tag = 3;
    [successAlert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [self viewDidLoad];
//        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginID"] animated:NO];
    }
    else if (alertView.tag == 2)
    {
        [self viewDidLoad];
    }
    else if (alertView.tag == 3)
    {
        [self performSegueWithIdentifier:@"SignupToInterestsSegue" sender:self];
    }
}

@end
