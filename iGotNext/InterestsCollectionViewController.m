//
//  InterestsCollectionViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/17/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "InterestsCollectionViewController.h"
#import "CustomCollectionViewCell.h"

#import <Parse/Parse.h>

@interface InterestsCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property NSMutableArray *sportsInterests;
@property NSMutableArray *selectedInterests;

@end

@implementation InterestsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sportsInterests = [[NSMutableArray alloc]initWithObjects:
                            [UIImage imageNamed:@"hockey"],
                            [UIImage imageNamed:@"football"],
                            [UIImage imageNamed:@"soccer"],
                            [UIImage imageNamed:@"volleyball"],
                            [UIImage imageNamed:@"basketball"],
                            [UIImage imageNamed:@"dodgeball"],
                            [UIImage imageNamed:@"ultimateFrisbee"],
                            [UIImage imageNamed:@"discGolf"],
                            [UIImage imageNamed:@"other"],
                            nil];
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
    
    cell.sportImageView.image = [self.sportsInterests objectAtIndex:indexPath.row];

    if (cell.selected == YES) {
        [cell setSelected:YES];
        [cell setTintColor:[UIColor blueColor]];
    } else {
        [cell setSelected:NO];
        [cell setTintColor:[UIColor clearColor]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if (cell.selected == YES) {

        [cell setSelected:YES];
        [cell setHighlighted:YES];
//        [cell setTintColor:[UIColor blueColor]];

        [self.selectedInterests addObject:cell.sportImageView.image];
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

        [self.selectedInterests removeObject:cell.sportImageView.image];
        [self saveInterests];
    } else {
        [cell setSelected:YES];
        [cell setHighlighted:YES];
//        [cell setTintColor:[UIColor blueColor]];
    }
}



@end
