//
//  HomeFeedViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ParkGameViewController.h"
#import "PickUpGameTableViewCell.h"
#import "Game.h"
#import "NewEventViewController.h"
#import "EventDetailViewController.h"

@interface ParkGameViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *events;
@property NSArray *sortedEvents;

@end

@implementation ParkGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.park.name;
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadEventsFeed];
}

//Loads events and adds them to an array
-(void)loadEventsFeed {
    PFUser *currentUser = [PFUser currentUser];
    NSArray *currentUserInterests = [currentUser objectForKey:@"interests"];

    self.events = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"eventLocation" containsString:self.navigationItem.title];
    [query whereKey:@"eventCategory" containedIn:currentUserInterests];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedEvents, NSError *error) {

        if (!error) {
            for (Game *event in returnedEvents) {
                [self.events addObject:event];
            }
            [self sortEvents];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PickUpGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFeedCell"];
    cell.game = [self.sortedEvents objectAtIndex:indexPath.row];
    return cell;
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}

-(void)sortEvents{
    self.sortedEvents = [NSMutableArray new];
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"eventStartTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    self.sortedEvents = [self.events sortedArrayUsingDescriptors:sortDescriptors];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewGameSegue"]) {
        NewEventViewController *newEventVC = segue.destinationViewController;
        newEventVC.park = self.park;
    } else if ([segue.identifier isEqualToString:@"EventDetailSegue"]) {
        EventDetailViewController *eventDetailVC = segue.destinationViewController;
        Game *game = [self.sortedEvents objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        eventDetailVC.game = game;
    }
}


@end
