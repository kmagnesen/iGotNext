//
//  HomeFeedViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ParkGameViewController.h"
#import "ParkGameTableViewCell.h"
#import "Event.h"

@interface ParkGameViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *events;
@property NSArray *sortedEvents;

@end

@implementation ParkGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [query whereKey:@"eventCategory" containedIn:currentUserInterests];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedEvents, NSError *error) {

        if (!error) {
            for (Event *event in returnedEvents) {
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
    ParkGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFeedCell"];
    cell.event = [self.sortedEvents objectAtIndex:indexPath.row];
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


@end
