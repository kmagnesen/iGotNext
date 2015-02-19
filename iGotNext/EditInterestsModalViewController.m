//
//  EditInterestsModalViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/19/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Parse/Parse.h>

#import "EditInterestsModalViewController.h"
#import "Interest.h"

@interface EditInterestsModalViewController ()
- (void)addEditInterestsButton;
- (void)setSport:(id)sender;

@property NSMutableArray *selections;
@property NSMutableArray *interests;
@property (nonatomic) UIEdgeInsets itemInsets;

@end

@implementation EditInterestsModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.layer.cornerRadius = 5.f;
    self.view.backgroundColor = [UIColor colorWithRed:0.106 green:0.529 blue:0.722 alpha:1];
    [self addEditInterestsButton];
    [self createSportsInterestsArray];
    [self addCollectionView];
    self.selections = [NSMutableArray new];
}
-(void)createSportsInterestsArray {

    Interest *hockey = [[Interest alloc] initWithImage:[UIImage imageNamed:@"hockey"]
                                          andSportName:@"Hockey"];

    Interest *football = [[Interest alloc] initWithImage:[UIImage imageNamed:@"football"]
                                            andSportName:@"Football"];

    Interest *soccer = [[Interest alloc] initWithImage:[UIImage imageNamed:@"soccer"]
                                          andSportName:@"Soccer"];

    Interest *volleyball = [[Interest alloc] initWithImage:[UIImage imageNamed:@"volleyball"]
                                              andSportName:@"Volleyball"];

    Interest *basketball = [[Interest alloc] initWithImage:[UIImage imageNamed:@"basketball"]
                                              andSportName:@"Basketball"];

    Interest *dodgeball = [[Interest alloc] initWithImage:[UIImage imageNamed:@"dodgeball"]
                                             andSportName:@"Dodgeball"];

    Interest *ultimateFrisbee = [[Interest alloc] initWithImage:[UIImage imageNamed:@"ultimateFrisbee"]
                                                   andSportName:@"Ultimate Frisbee"];

    Interest *discGolf = [[Interest alloc] initWithImage:[UIImage imageNamed:@"discGolf"]
                                            andSportName:@"Disc Golf"];

    Interest *other = [[Interest alloc] initWithImage:[UIImage imageNamed:@"other"]
                                         andSportName:@"Other"];

    self.interests = [[NSMutableArray alloc]initWithObjects:hockey, football, soccer, volleyball, basketball, dodgeball, ultimateFrisbee, discGolf, other, nil];
}
- (void)setSport:(id)sender {
//    [self categoryPicked];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)addEditInterestsButton {
    UIButton *setSportButton = [UIButton buttonWithType:UIButtonTypeSystem];
    setSportButton.translatesAutoresizingMaskIntoConstraints = NO;
    setSportButton.tintColor = [UIColor whiteColor];
    setSportButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [setSportButton setTitle:@"Update Interests" forState:UIControlStateNormal];
    [setSportButton addTarget:self action:@selector(setSport:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setSportButton];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:setSportButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[setSportButton]-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(setSportButton)]];
}

- (void) saveInterests {
    PFUser *currentUser  = [PFUser currentUser];
    currentUser[@"interests"] = self.selections;
    [currentUser saveInBackground];
}

-(void)addCollectionView {
    self.itemInsets = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setItemSize:CGSizeMake(self.view.frame.size.width / 5, self.view.frame.size.width / 5)];

    [layout setSectionInset:self.itemInsets];
    [layout setMinimumInteritemSpacing:0.f];
    [layout setMinimumLineSpacing:5.0f];

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setBounces:YES];
    [_collectionView setUserInteractionEnabled:YES];

    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];

    [self.view addSubview:_collectionView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_collectionView]-32-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionView)]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_collectionView]-8-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_collectionView)]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.interests.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor blueColor];
    return cell;
}


@end
