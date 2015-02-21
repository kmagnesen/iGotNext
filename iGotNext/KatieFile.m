//
//  KatieFile.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/20/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "KatieFile.h"

//remember to import these frameworks
#import "Game.h"
#import <Parse/Parse.h>
#import "NewEventViewController.h"
#import "GameDetailViewController.h"
#import "PickUpGameTableViewCell.h"


@implementation KatieFile


#pragma ----- Creating Event Parse Object ------

-(void) confirmLocationAlert {
    UIAlertView *confirmationAlert = [[UIAlertView alloc] initWithTitle: @"Title"
                                                                message:@"Are you sure you want to create a new pick-up game here?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Yes", nil];
    [confirmationAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        ;
    }else{
 //       [self prepareForSegue:@"CreateNewPickUpGame" sender:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"CreateNewPickUpGame"]) {
        PFUser *currentUser = [PFUser currentUser];
        Game *game = [[Game alloc] initWithUser:currentUser andLocation:self.dummyLocation];
        [game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"New event saved, but this is a reminder to work on the event that the event does not save");
            } else {
                NSLog(@"New event never saved, work on notification that makes sense for user");
            }
        }];

        NewEventViewController *newEventVC = segue.destinationViewController;
        newEventVC.game = game;
    } if ([segue.identifier isEqualToString:@"EventDetailSegue"]) {
        GameDetailViewController *eventDetailVC = segue.destinationViewController;
        Game *game = [self.sortedGames objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        eventDetailVC.game = game;
    }
}

#pragma ----- TableView of Games Methods ------

//Call this method in viewDidLoad
-(void)loadGamesFeed {
    PFUser *currentUser = [PFUser currentUser];
    NSArray *currentUserInterests = [currentUser objectForKey:@"interests"];

    //Make sure to include "games" a global variable
    self.games = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"eventCategory" containedIn:currentUserInterests];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedGames, NSError *error) {

        if (!error) {
            for (Game *game in returnedGames) {
                [self.games addObject:game];
            }
            [self sortEvents];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedGames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Make sure you set the CellID in storyboard
    PickUpGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameFeedCell"];
    cell.game = [self.sortedGames objectAtIndex:indexPath.row];
    return cell;
}

-(void)sortEvents{
    self.sortedGames = [NSArray new];
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"eventStartTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    self.sortedGames = [self.games sortedArrayUsingDescriptors:sortDescriptors];
}

@end
