//
//  ProfileViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UITextView *interestsTextView;
@property (strong, nonatomic) IBOutlet UITextView *statsAndReviewTextView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    [self loadProfile];
}

- (void)loadProfile {

    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {
        PFQuery *userQuery = [PFUser query];

        [userQuery getObjectInBackgroundWithId:currentUser.objectId block:^(PFObject *object, NSError *error) {

            if (!error) {

                PFFile *currentProfilePic = (PFFile *)[object objectForKey:@"profilePic"];

                [currentProfilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

                    UIImage *image = [UIImage imageWithData:data];
                    self.profileImageView.image = image;
                    self.usernameLabel.text = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:@"username"]];
                    self.navigationItem.title = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:@"username"]];

                    //                            [self.profilePic reloadInputViews];
                    [self.usernameLabel reloadInputViews];
                }];
            } else {

                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
                
            }
        }];
    }
}

- (IBAction)onLogOutButtonTapped:(UIBarButtonItem *)sender {

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"LogOutSegue"]) {

        [PFUser logOut];
        PFUser *currentUser = [PFUser currentUser];
        NSLog(@"%@", currentUser);
    }
}



@end
