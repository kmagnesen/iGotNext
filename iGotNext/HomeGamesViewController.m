 //
//  HomeParksViewController.m
//  iGotNext
//
//  Created by JP Skowron on 2/11/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PickUpGameTableViewCell.h"
#import "NewGameViewController.h"
#import "HomeGamesViewController.h"
#import "Game.h"
#import "GameDetailViewController.h"
#import "GameAnnotation.h"
#import "User.h"

@interface HomeGamesViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UIAlertViewDelegate, NewGameDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *hintButton;
@property CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property NSArray *mapItems;
@property GameAnnotation *droppedAnnotation;
@property (nonatomic)NSMutableArray *geofences;
@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;
@property NSMutableArray *games;
@property GameAnnotation *gameAnnotation;
@property Game *selectedGame;

@property MKUserLocation *userLocation;

@end

@implementation HomeGamesViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];

    [self.locationManager startUpdatingLocation];

    self.droppedAnnotation = [GameAnnotation new];

    [self setUpLongTouchGesture];

    self.tableView.hidden = YES;

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

//    if ([PFUser currentUser]) {
//        [self loadGamesFeed];
//    }
    self.mapView.showsUserLocation = YES;
}

- (IBAction)onAddButtonTapped:(UIBarButtonItem *)sender {
    [self createGameHintAlert];
}

-(void)createGameHintAlert{
    UIAlertController *inputAlert = [UIAlertController alertControllerWithTitle:@"Create New Game:" message:@"Press & Hold On Map To Create A New Pick-Up Game At That Location" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];

    [inputAlert addAction:dismissAction];

    [self presentViewController:inputAlert animated:true completion:nil];
}

#pragma mark ----- New Pin Methods -----

-(void)setUpLongTouchGesture {
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;

    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

    self.droppedAnnotation.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:self.droppedAnnotation];
    [self confirmLocationAlert];
}


#pragma mark ----- New Pin AlertView -----

-(void) confirmLocationAlert {
    UIAlertView *confirmationAlert = [[UIAlertView alloc] initWithTitle: @"New Game Location"
                                                                message:@"Are you sure you want to create a new pick-up game here?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Oops, wrong spot"
                                                      otherButtonTitles:@"Let's Boogie", nil];
    [confirmationAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]){
        //TODO: get so pin does not stay on map
        ;
    }else{
        [self performSegueWithIdentifier:@"NewGameSegue" sender:self];
    }
}


#pragma mark ----- Segue -----

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"GameDetailSegue"]) {
        GameDetailViewController *gameDetailVC = segue.destinationViewController;
        if (self.tableView.hidden == NO) {
            self.selectedGame = [self.games objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        }else{
            ;
        }
        gameDetailVC.game = self.selectedGame;

    } if([[segue identifier] isEqualToString:@"NewGameSegue"]) {
        NewGameViewController *newGameVC = segue.destinationViewController;
        User *currentUser = [User currentUser];

        //Creates a new game object that is passed using the recently dropped pin
        Game *newGame = [[Game alloc] initWithUser:currentUser andLocation:self.droppedAnnotation];
        newGameVC.game = newGame;

        newGameVC.delegate = self;
    }
}



- (IBAction)unwindToGameFeed:(UIStoryboardSegue *)unwindSegue {
    [self loadGamesFeed];
}

#pragma mark ----- Load Games -----

-(void)loadGamesFeed {
    User *currentUser = [User currentUser];
    // User's location
    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLatitude:self.userLocation.coordinate.latitude longitude:self.userLocation.coordinate.longitude];
    //Make sure to include "games" a global variable
    self.games = [NSMutableArray new];

    // Create a query for places
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];

    // Only find live events
    [query whereKey:@"startTime" greaterThanOrEqualTo:[NSDate date]];

    // Only find games relevant to user's interests
    [query whereKey:@"category" containedIn:currentUser.interests];

    // Interested in locations near user.
    [query whereKey:@"location" nearGeoPoint:userGeoPoint];


    // Limit what could be a lot of points.
    query.limit = 100;

    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedGames, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (Game *game in returnedGames) {
                    for (PFObject *user in game[@"attendees"]) {
                         [user fetchIfNeeded];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.games = [[returnedGames sortedArrayUsingComparator:^NSComparisonResult(Game *game1, Game *game2) {
                        CLLocation *game1Location = [[CLLocation alloc] initWithLatitude:game1.location.latitude longitude:game1.location.longitude];
                        CLLocation *game2Location = [[CLLocation alloc] initWithLatitude:game2.location.latitude longitude:game2.location.longitude];
                        CLLocationDistance d1 = [self.userLocation.location distanceFromLocation:game1Location];
                        CLLocationDistance d2 = [self.userLocation.location distanceFromLocation:game2Location];
                        return d1 - d2;
                    }] mutableCopy];

                    [self.tableView reloadData];
                    [self loadMap];
                });
            });
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


#pragma mark ----- Delegate -----

-(void)updateGames {
    [self loadGamesFeed];
}

#pragma mark ----- TableView Methods -----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.games.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PickUpGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    PFGeoPoint *userLocation = [PFGeoPoint geoPointWithLocation:self.userLocation.location];
    cell.game = [self.games objectAtIndex:indexPath.row];
    float distance = [cell.game.location distanceInMilesTo:userLocation];
    if (distance < 1) {
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.2f miles away", distance];
    } else if (distance < 10) {
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f miles away", distance];
    } else {
        cell.distanceLabel.text = [NSString stringWithFormat:@"%@ miles away", [@(round(distance)) descriptionWithLocale:[NSLocale currentLocale]]];
    }
    return cell;
}


#pragma mark ----- Segmented Controller -----

- (IBAction)segementedControlSwitched:(UISegmentedControl *)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;

    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        [self.tableView setHidden:YES];
        [self.mapView setHidden:NO];
    } else {
        //toggle the correct view to be visible
        [self.tableView setHidden:NO];
        [self.mapView setHidden:YES];
    }
}


#pragma mark ----- MKMapView Methods -----

-(void)loadMap {
    for (Game *game in self.games) {
        GameAnnotation *gameAnnotation = [[GameAnnotation alloc]initWithGame:game];
        [self.mapView addAnnotation:gameAnnotation];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }

    GameAnnotation *gameAnnotation = annotation;
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:gameAnnotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    //TODO: refactor to enum
    pin.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Pin", [gameAnnotation.game.category stringByReplacingOccurrencesOfString:@" " withString:@""]]];

    [self.mapView addAnnotation:annotation];


    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    self.gameAnnotation = view.annotation;
    self.selectedGame = self.gameAnnotation.game;
    [self performSegueWithIdentifier:@"GameDetailSegue" sender:view];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.017;
    span.longitudeDelta = 0.017;
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];

    self.userLocation = userLocation;

    //new user location first
    [self loadGamesFeed];
}


@end
