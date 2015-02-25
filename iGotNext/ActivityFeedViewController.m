//
//  ActivityFeedViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <Parse/Parse.h>
#import "ActivityFeedViewController.h"
#import "Game.h"
#import "ActivityTableViewCell.h"
#import "GameDetailViewController.h"

@interface ActivityFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property NSMutableArray *gamesDisplayed;
@property PFUser *currentUser;

@end

@implementation ActivityFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [PFUser currentUser];

    [self.segmentedController setTitle:@"Events Created" forSegmentAtIndex:0];
    [self.segmentedController setTitle:@"Events Attending" forSegmentAtIndex:1];
}

-(void)viewWillAppear:(BOOL)animated {
    //To show changes in attendance count when come back to vc
    [self loadEventsCurrentUserCreated];
}

- (IBAction)onSegmentedControllerTapped:(UISegmentedControl *)sender {
    [self segmentedControllerLogic];
}

-(void)segmentedControllerLogic {
    //Segmentedcontroller dictates what shows in the tableview when it is tapped
    if (self.segmentedController.selectedSegmentIndex == 0) {
        [self loadEventsCurrentUserCreated];
        [self.tableView reloadData];
    } else if (self.segmentedController.selectedSegmentIndex == 1) {
        [self loadEventsCurrentUserIsAttending];
        [self.tableView reloadData];
    }
}

#pragma mark ----------- Pulling UITableView Content -----------
-(void)loadEventsCurrentUserCreated {
    self.gamesDisplayed = [NSMutableArray new];

    //Pulls events based on their eventCreator property
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"creator" equalTo:self.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedEvents, NSError *error) {

        if (!error) {
            for (Game *game in returnedEvents) {
                [self.gamesDisplayed addObject:game];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    //TODO: segemented controller also needs to be set to 0
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.segmentedController.selectedSegmentIndex = 0;
        Game *game = [self.gamesDisplayed objectAtIndex:indexPath.row];
        [self.gamesDisplayed removeObjectAtIndex:indexPath.row];
        [game deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
        }];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        NSLog(@"It didn't go as planned %ld", editingStyle);
    }


}

-(void)loadEventsCurrentUserIsAttending {
    self.gamesDisplayed = [NSMutableArray new];

    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedEvents, NSError *error) {

        if (!error) {
            for (Game *game in returnedEvents) {
                if([game.attendees containsObject:self.currentUser]) {
                    [self.gamesDisplayed addObject:game];
                } else {
                    ;
                }
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark ----------- UITableView Delegate & Data Source -----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gamesDisplayed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityTableViewCell *activityCell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    Game *game = [self.gamesDisplayed objectAtIndex:indexPath.row];
    activityCell.game = game;
    return activityCell;
}

#pragma mark ----------- Segue -----------
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GameDetailSegue"]) {
        GameDetailViewController *gameDetailVC = segue.destinationViewController;
        gameDetailVC.game = [self.gamesDisplayed objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}


@end
