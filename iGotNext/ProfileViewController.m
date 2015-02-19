//
//  ProfileViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ProfileViewController.h"
#import "Event.h"
#import <Parse/Parse.h>

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

    self.currentUser = [PFUser new];
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

                self.usernameLabel.text = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:@"username"]];
                self.navigationItem.title = [NSString stringWithFormat:@"My Profile"];

                self.interestsTextView.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser]valueForKey:@"interests"]];

                    [self.usernameLabel reloadInputViews];

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

-(void)loadEventsCurrentUserIsAttending {
    self.interests = [NSMutableArray new];

    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedEvents, NSError *error) {

        if (!error) {
            for (Event *event in returnedEvents) {
                if([event.attendees containsObject:self.currentUser]) {
                    [self.interests addObject:event];
                } else {
                    ;
                }
            }
            [self.profileTableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark ----------- UITableView Delegate & Data Source -----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.interests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    Event *event = [self.interests objectAtIndex:indexPath.row];
    cell.textLabel.text = event.eventTitle;
    return cell;
}

@end
