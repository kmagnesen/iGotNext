//
//  HomeParksViewController.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/11/15.
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

@interface HomeGamesViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UIAlertViewDelegate>

@property CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property NSArray *mapItems;
@property MKMapItem *selectedPark;
@property MKPointAnnotation *parksAnnotation;
@property MKPointAnnotation *droppedAnnotation;
@property (nonatomic)NSMutableArray *geofences;
@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;
@property NSMutableArray *games;
@property NSArray *sortedGames;
@property GameAnnotation *gameAnnotation;
@property Game *selectedGame;

@end

@implementation HomeGamesViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];

    [self.locationManager startUpdatingLocation];

    self.selectedPark = [MKMapItem new];
    self.parksAnnotation = [MKPointAnnotation new];
    self.droppedAnnotation = [MKPointAnnotation new];

    [self setUpLongTouchGesture];
    [self loadGamesFeed];

    self.tableView.hidden = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.mapView.showsUserLocation = YES;
}


#pragma mark ----- New Pin Methods -----

-(void)setUpLongTouchGesture {
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;

    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

//    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    self.droppedAnnotation.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:self.droppedAnnotation];
    [self confirmLocationAlert];
}


#pragma mark ----- New Pin AlertView -----

-(void) confirmLocationAlert {
    UIAlertView *confirmationAlert = [[UIAlertView alloc] initWithTitle: @"Title"
                                                                message:@"Are you sure you want to create a new pick-up game here?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Oops, wrong spot"
                                                      otherButtonTitles:@"Let's Boogie", nil];
    [confirmationAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //TODO: get so pin does not stay on map
        ;
    }else{
        NewGameViewController *newGameVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewGameVC"];
        PFUser *currentUser = [PFUser currentUser];

        //Creates a new game object that is passed using the recently dropped pin
        Game *newGame = [[Game alloc] initWithUser:currentUser andLocation:self.droppedAnnotation];
        newGameVC.game = newGame;
        [self presentViewController:newGameVC animated:YES completion:nil];
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
    }
}

- (IBAction)unwindToGameFeed:(UIStoryboardSegue *)unwindSegue {
    //TODO: reload the mapview with the new game that was just officially created
}


//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"%@", error);
//}
//
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    for (CLLocation *location in locations) {
//        if (location.horizontalAccuracy < 1000 && location.verticalAccuracy < 1000) {
//            [self.locationManager stopUpdatingLocation];
//            [self findParkNear:location];
//            break;
//        }
//    }
//}
//
//-(void)findParkNear:(CLLocation *)location {
////    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
////    request.naturalLanguageQuery = @"Sports";
////    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));
////
////    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
////    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
////        self.mapItems = response.mapItems;
//
//        for (MKMapItem *parkMapItem in self.mapItems) {
//            CLLocationCoordinate2D coordinate = parkMapItem.placemark.location.coordinate;
//
//            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
//            annotation.coordinate = coordinate;
//            //NSLog(@"%@", parkMapItem.placemark.name);
//            annotation.title = parkMapItem.placemark.name;
//            annotation.subtitle = parkMapItem.placemark.title;
//
//            [self.mapView addAnnotation:annotation];
//
//            MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:500];
//            [self.mapView addOverlay:circle];
//
//        }
//        [self.mapView showAnnotations:self.mapView.annotations animated:YES];
//        [self.tableView reloadData];
////    }];
//}


#pragma mark ----- Load Games -----

-(void)loadGamesFeed {
    PFUser *currentUser = [PFUser currentUser];

    //Make sure to include "games" a global variable
    self.games = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"category" containedIn:currentUser[@"interests"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedGames, NSError *error) {

        if (!error) {
            for (Game *game in returnedGames) {
                [self.games addObject:game];
            }
//            [self sortGames];
            [self.tableView reloadData];
            [self loadMap];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//-(void)sortGames{
//    self.sortedGames = [NSArray new];
//    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"eventStartTime" ascending:YES];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
//    self.sortedGames = [self.games sortedArrayUsingDescriptors:sortDescriptors];
//}


#pragma mark ----- TableView Methods -----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.games.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PickUpGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.game = [self.games objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


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
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;

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
    span.latitudeDelta = 0.069;
    span.longitudeDelta = 0.069;
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];
}


@end
