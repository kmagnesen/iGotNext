//
//  GameDetailViewController.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/13/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "GameDetailViewController.h"
#import "GameDetailTableViewCell.h"
#import "User.h"

@interface GameDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *gameTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *gameCategoryImageView;
@property (strong, nonatomic) IBOutlet UILabel *gameTimeLabel;
@property (strong, nonatomic) IBOutlet UITextView *eventDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *attendButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property User *currentUser;
@property NSMutableArray *currentAttendees;


@end

@implementation GameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];
    [self clearCurrentAttendees];

    self.gameCategoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.game.category]];
    self.gameTitleLabel.text = self.game.title;
    self.gameTimeLabel.text = [NSString stringWithFormat:@"%@ Start: %@ Ends: %@", self.game.startDate, self.game.startTime, self.game.endTime];
    self.eventDescriptionTextView.text = self.game.gameDescription;

    [self buttonAttendanceLogic];
}

-(void)viewWillAppear:(BOOL)animated {
    [self clearCurrentAttendees];
    [self buttonAttendanceLogic];
}

-(void)clearCurrentAttendees {
    self.currentAttendees = [NSMutableArray new];
    self.currentAttendees = [NSMutableArray arrayWithArray:self.game.attendees];
}

-(void)saveUpdatedGame {
    //Method that updates the event parse object being referred to
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];

    [query getObjectInBackgroundWithId:self.game.objectId block:^(PFObject *game, NSError *error) {
        game[@"attendees"] = self.currentAttendees;
        [game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self.tableView reloadData];
            }
        }];
    }];
}


#pragma mark ----- Button Logic -----

- (IBAction)onAttendButtonTapped:(UIButton *)sender {
    //Changes the number of people attending on the button and saves the changes to the parse object
    if ([self.game.attendees containsObject:self.currentUser]) {
        [self.currentAttendees removeObject:self.currentUser];
        [self buttonAttend];
        [self saveUpdatedGame];
    } else {
        [self.currentAttendees addObject:self.currentUser];
        [self buttonAttending];
        [self saveUpdatedGame];
    }
}

-(void)buttonAttendanceLogic {
    if ([self.game.attendees containsObject:self.currentUser]) {
        [self buttonAttending];
    } else {
        [self buttonAttend];
    }
}

#pragma mark ----- Button Appearance -----

-(void)buttonAttend{
    [self.attendButton setTitle:@"Attend" forState:UIControlStateNormal];
    [self.attendButton setTitleColor:[UIColor colorWithRed:0.106 green:0.529 blue:0.722 alpha:1] forState:UIControlStateNormal];
    [self.attendButton setBackgroundColor:[UIColor clearColor]];
    [[self.attendButton layer] setBorderWidth:2.0f];
    [[self.attendButton layer] setBorderColor:[UIColor colorWithRed:0.106 green:0.529 blue:0.722 alpha:1].CGColor];
}

-(void)buttonAttending{
    [self.attendButton setTitle:@"Attending" forState:UIControlStateNormal];
    [self.attendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.attendButton setBackgroundColor:[UIColor colorWithRed:0.106 green:0.529 blue:0.722 alpha:1]];
}

#pragma mark ----- TableView -----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.game.attendees.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.user = [self.game.attendees objectAtIndex:indexPath.row];
    return  cell;
}

@end
