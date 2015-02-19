//
//  ProfileViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <Parse/Parse.h>

#import "ProfileViewController.h"
#import "Interest.h"

#import "PresentingAnimation.h"
#import "DismissingAnimation.h"

@interface ProfileViewController () <UITableViewDataSource, UITabBarDelegate>

@property (strong, nonatomic) IBOutlet UITextView *interestsTextView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITableView *profileTableView;

@property NSMutableArray *interests;
@property PFUser *currentUser;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    self.currentUser = [PFUser new];
    [self loadProfile];
}

- (void)loadProfile {

    PFUser *currentUser = [PFUser currentUser];
    self.interests = [NSMutableArray new];

    if (currentUser) {
        PFQuery *userQuery = [PFUser query];

        [userQuery getObjectInBackgroundWithId:currentUser.objectId block:^(PFObject *object, NSError *error) {

            if (!error) {
                self.navigationItem.title = [NSString stringWithFormat:@"Profile"];

                self.usernameLabel.text = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:@"username"]];
                self.interests = [NSMutableArray arrayWithArray:[[PFUser currentUser]valueForKey:@"interests"]];

                [self.usernameLabel reloadInputViews];
                [self.profileTableView reloadData];
//                NSLog(@"%@", self.interests);

            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
        }];
    }
}

- (IBAction)onLogOutButtonTapped:(UIBarButtonItem *)sender {
// can delete
}
- (IBAction)onEditInterestsButtonTapped:(UIButton *)sender {
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"LogOutSegue"]) {

        [PFUser logOut];
        PFUser *currentUser = [PFUser currentUser];
        NSLog(@"%@", currentUser);
    }
}

#pragma mark ----------- UITableView Delegate & Data Source -----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.interests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
//    Interest *interest = [self.interests objectAtIndex:indexPath.row];
    cell.textLabel.text = [self.interests objectAtIndex:indexPath.row];
    return cell;
}

@end
