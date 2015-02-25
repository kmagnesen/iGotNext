//
//  InterestsViewController.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/23/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <Parse/Parse.h>

#import "InterestsViewController.h"
#import "InteretsCollectionViewCell.h"
#import "Interest.h"

@interface InterestsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property NSMutableArray *sportsInterests;
@property NSMutableArray *selectedInterests;

@end

@implementation InterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createSportsInterestsArray];

    self.selectedInterests = [NSMutableArray new];
}

-(void)createSportsInterestsArray {
    Interest *hockey = [[Interest alloc] initWithImage:[UIImage imageNamed:@"Hockey"]
                                          andSportName:@"Hockey"];

    Interest *football = [[Interest alloc] initWithImage:[UIImage imageNamed:@"Football"]
                                            andSportName:@"Football"];

    Interest *soccer = [[Interest alloc] initWithImage:[UIImage imageNamed:@"Soccer"]
                                          andSportName:@"Soccer"];

    Interest *volleyball = [[Interest alloc] initWithImage:[UIImage imageNamed:@"Volleyball"]
                                              andSportName:@"Volleyball"];

    Interest *basketball = [[Interest alloc] initWithImage:[UIImage imageNamed:@"Basketball"]
                                              andSportName:@"Basketball"];

    Interest *dodgeball = [[Interest alloc] initWithImage:[UIImage imageNamed:@"Dodgeball"]
                                             andSportName:@"Dodgeball"];

    Interest *baseball = [[Interest alloc] initWithImage:[UIImage imageNamed:@"Baseball"]
                                                   andSportName:@"Baseball"];

    Interest *tennis = [[Interest alloc] initWithImage:[UIImage imageNamed:@"Tennis"]
                                            andSportName:@"Tennis"];

    Interest *other = [[Interest alloc] initWithImage:[UIImage imageNamed:@"Other"]
                                         andSportName:@"Other"];

    self.sportsInterests = [[NSMutableArray alloc]initWithObjects:hockey, football, soccer, volleyball, basketball, dodgeball, baseball, tennis, other, nil];
}

- (IBAction)onSaveButtonTapped:(UIBarButtonItem *)sender {
}

- (void) saveInterests {
    PFUser *currentUser  = [PFUser currentUser];
    currentUser[@"interests"] = self.selectedInterests;
    [currentUser saveInBackground];
}

#pragma mark ----- UICollectionView -----

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sportsInterests.count;
}

- (InteretsCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InteretsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.interest = [self.sportsInterests objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    InteretsCollectionViewCell *cell = (InteretsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.selectedInterests containsObject:cell.interest.sportName]) {
        [self.selectedInterests removeObject:cell.interest.sportName];
        cell.backgroundColor = [UIColor clearColor];
        [self saveInterests];
    } else {
        [self.selectedInterests addObject:cell.interest.sportName];
//        cell.backgroundColor = [UIColor ]
        cell.backgroundColor = [UIColor colorWithRed:0 green:0.467 blue:0.553 alpha:1];
        [self saveInterests];
    }
}

@end