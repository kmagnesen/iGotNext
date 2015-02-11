//
//  InterestsViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "InterestsViewController.h"
#import <Parse/Parse.h>

@interface InterestsViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *sportsInterests;
@property NSMutableArray *selectedInterests;

@end

@implementation InterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sportsInterests = [[NSMutableArray alloc]initWithObjects:@"Hockey (Street/Ice)", @"Football", @"Soccer", @"VolleyBall (Beach/Bar)", @"Basketball", @"Dodgeball", @"Ultimate Frisbee", @"Disc Golf", @"Yugigassen (Snowball Fighting)", @"All Other Sports", nil];
    self.selectedInterests = [NSMutableArray new];

}

- (IBAction)onSaveButtonTapped:(UIBarButtonItem *)sender {
    [self saveInterests];
}

- (void) saveInterests {
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"interests"] = self.selectedInterests;
    [currentUser saveInBackground];
}


#pragma mark ----------- UITableView Delegate & Data Source -----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sportsInterests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InterestCell"];
    cell.textLabel.text = [self.sportsInterests objectAtIndex:indexPath.row];

    if (cell.selected == YES) {
        [cell setSelected:YES animated:YES];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setSelected:NO animated:NO];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.selected == YES) {

        [cell setSelected:YES animated:YES];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];

        [self.selectedInterests addObject:cell.textLabel.text];
        [self saveInterests];
    } else {
        [cell setSelected:NO animated:NO];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.selected == NO) {

        [cell setSelected:NO animated:YES];
        [cell setAccessoryType:UITableViewCellAccessoryNone];

        [self.selectedInterests removeObject:cell.textLabel.text];
        [self saveInterests];
    } else {
        [cell setSelected:YES animated:NO];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}

@end
