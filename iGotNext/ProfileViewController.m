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
#import "EditInterestsModalViewController.h"
#import "ProfileTableViewCell.h"

#import "PresentingAnimation.h"
#import "DismissingAnimation.h"
#import "LoginViewController.h"

@interface ProfileViewController () <UIViewControllerTransitioningDelegate, UITableViewDataSource, UITabBarDelegate, UpdateInterestTVCDelegate>

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITableView *profileTableView;

@property NSMutableArray *interests;
//@property PFUser *currentUser;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.currentUser = [PFUser new];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self loadProfile];
}

- (void)updateInterests{
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
    [PFUser logOut];
    LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginID"];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (IBAction)onEditInterestsButtonTapped:(UIButton *)sender {
    EditInterestsModalViewController *interestViewController = [EditInterestsModalViewController new];
    interestViewController.delegate = self;
    interestViewController.transitioningDelegate = self;
    interestViewController.modalPresentationStyle = UIModalPresentationCustom;

    [self.navigationController presentViewController:interestViewController
                                            animated:YES
                                          completion:NULL];
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

#pragma mark ----------- UITableView Delegate & Data Source -----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.interests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    NSString *interest = [self.interests objectAtIndex:indexPath.row];
    cell.sportLabel.text = interest;
    cell.sportImageView.image = [UIImage imageNamed:interest];
    return cell;
}

@end
