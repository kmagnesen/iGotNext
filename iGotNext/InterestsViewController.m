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

@property NSArray *sportsInterests;

@end

@implementation InterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sportsInterests = [[NSArray alloc]initWithObjects:@"Hockey (Street/Ice)", @"Football", @"Soccer", @"VolleyBall (Beach/Bar)", @"Basketball", @"Dodgeball", @"Ultimate Frisbee", @"Disc Golf", @"Yugigassen (Snowball Fighting)", @"All Other Sports", nil];

}

#pragma mark ----------- UITableView Delegate & Data Source -----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sportsInterests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InterestCell"];

    return cell;
}



@end
