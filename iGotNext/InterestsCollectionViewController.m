//
//  InterestsCollectionViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/17/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "InterestsCollectionViewController.h"
#import "CustomCollectionViewCell.h"
#import "Interest.h"

#import <Parse/Parse.h>

@interface InterestsCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property NSMutableArray *sportsInterests;
@property NSMutableArray *selectedInterests;

@end

@implementation InterestsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Interest *hockey = [[Interest alloc] initWithImage:[UIImage imageNamed:@"hockey"] andSportName:@"Hockey"];
    Interest *football = [[Interest alloc] initWithImage:[UIImage imageNamed:@"football"] andSportName:@"Football"];
    Interest *soccer = [[Interest alloc] initWithImage:[UIImage imageNamed:@"soccer"] andSportName:@"Soccer"];
    Interest *volleyball = [[Interest alloc] initWithImage:[UIImage imageNamed:@"volleyball"] andSportName:@"Volleyball"];
    Interest *basketball = [[Interest alloc] initWithImage:[UIImage imageNamed:@"basketball"] andSportName:@"Basketball"];
    Interest *dodgeball = [[Interest alloc] initWithImage:[UIImage imageNamed:@"dodgeball"] andSportName:@"Dodgeball"];
    Interest *ultimateFrisbee = [[Interest alloc] initWithImage:[UIImage imageNamed:@"ultimateFrisbee"] andSportName:@"Ultimate Frisbee"];
    Interest *discGolf = [[Interest alloc] initWithImage:[UIImage imageNamed:@"discGolf"] andSportName:@"Disc Golf"];
    Interest *other = [[Interest alloc] initWithImage:[UIImage imageNamed:@"other"] andSportName:@"Other"];

    self.sportsInterests = [[NSMutableArray alloc]initWithObjects:hockey, football, soccer, volleyball, basketball, dodgeball, ultimateFrisbee, discGolf, other, nil];

//Hockey (Street/Ice)", @"Football", @"Soccer", @"VolleyBall (Beach/Bar)", @"Basketball", @"Dodgeball", @"Ultimate Frisbee", @"Disc Golf", @"Yugigassen (Snowball Fighting)", @"All Other Sports"
    self.selectedInterests = [NSMutableArray new];

}

- (void) saveInterests {
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"interests"] = self.selectedInterests;
    [currentUser saveInBackground];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    return self.sportsInterests.count;

}

- (CustomCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.interest = [self.sportsInterests objectAtIndex:indexPath.row];

    if (cell.selected == YES) {
        [cell setSelected:YES];
        [cell setHighlighted:YES];
//        [cell setTintColor:[UIColor blueColor]];
    } else {
        [cell setSelected:NO];
        [cell setHighlighted:NO];
//        [cell setTintColor:[UIColor clearColor]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if (cell.selected == YES) {

        [cell setSelected:YES];
        [cell setHighlighted:YES];
//        [cell setTintColor:[UIColor blueColor]];

        [self.selectedInterests addObject:cell.interest.sportName];
        [self saveInterests];
    } else {
        [cell setSelected:NO];
        [cell setHighlighted:NO];
//        [cell setTintColor:[UIColor clearColor]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if (cell.selected == NO) {

        [cell setSelected:NO];
        [cell setHighlighted:NO];
//        [cell setTintColor:[UIColor clearColor]];

        [self.selectedInterests removeObject:cell.interest.sportName];
        [self saveInterests];
    } else {
        [cell setSelected:YES];
        [cell setHighlighted:YES];
//        [cell setTintColor:[UIColor blueColor]];
    }
}



@end
