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

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];


}

- (IBAction)onLoginButtonTapped:(UIButton *)sender {
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password: self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if  (error) {
            [self errorAlert];
        }
        else if (!error)
        {
            [self performSegueWithIdentifier:@"LoginToInterestsSegue" sender:self];
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
            [self errorAlert];
        }
        else if (!error)
        {
            [self successAlert];
            [self performSegueWithIdentifier:@"SignupToInterestsSegue" sender:self];
        }
    }];
}

-(void)errorAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🚫 Error!!! 🚫" message:@"Credentials are incorrect or the username you've selected is taken. Correct above & try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];

    [alert show];
}

-(void)successAlert {
    UIAlertView *newAlert =[[UIAlertView alloc] initWithTitle:@"💥 Boom Shakalaka!!! 💥" message:@"You've Just Created A Profile For One Of The Most Badass Apps On the Planet!" delegate:self cancelButtonTitle:@"Enter!" otherButtonTitles: nil];

    [newAlert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        NSLog(@"Everything's Good!");
    }
}

@end
