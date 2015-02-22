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
                                                      cancelButtonTitle:@"Nah, I fucked up"
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
        //TODO: impliment steps for if users taps on annotation or a game in the tableview
    }
}

- (IBAction)unwindToGameFeed:(UIStoryboardSegue *)unwindSegue {
    //TODO: reload the mapview with the new game that was just officially created
}


#pragma mark ----- CLLocation -----

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 1000 && location.verticalAccuracy < 1000) {
            [self.locationManager stopUpdatingLocation];
            [self findParkNear:location];
            break;
        }
    }
}

-(void)findParkNear:(CLLocation *)location {
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.naturalLanguageQuery = @"Sports";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.mapItems = response.mapItems;

        for (MKMapItem *parkMapItem in self.mapItems) {
            CLLocationCoordinate2D coordinate = parkMapItem.placemark.location.coordinate;

            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
            annotation.coordinate = coordinate;
            //NSLog(@"%@", parkMapItem.placemark.name);
            annotation.title = parkMapItem.placemark.name;
            annotation.subtitle = parkMapItem.placemark.title;

            [self.mapView addAnnotation:annotation];

            MKCircle *circle = [MKCircle circleWithCenterCoordinate:coordinate radius:500];
            [self.mapView addOverlay:circle];

        }
        [self.mapView showAnnotations:self.mapView.annotations animated:YES];
        [self.tableView reloadData];
    }];
}


#pragma mark ----- Load Games -----

-(void)loadGamesFeed {
    PFUser *currentUser = [PFUser currentUser];
    NSArray *currentUserInterests = [currentUser objectForKey:@"interests"];

    //Make sure to include "games" a global variable
    self.games = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"eventCategory" containedIn:currentUserInterests];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedGames, NSError *error) {

        if (!error) {
            for (Game *game in returnedGames) {
                [self.games addObject:game];
            }
            [self sortGames];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)sortGames{
    self.sortedGames = [NSArray new];
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"eventStartTime" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    self.sortedGames = [self.games sortedArrayUsingDescriptors:sortDescriptors];
}


#pragma mark ----- TableView Methods -----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedGames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Make sure you set the CellID in storyboard
    PickUpGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameFeedCell"];
    cell.game = [self.sortedGames objectAtIndex:indexPath.row];
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

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {


    if (annotation == mapView.userLocation) {
        return nil;
    }
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];

    pin.canShowCallout = YES;
//    else if (annotation != mapView.userLocation) {
//    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    }
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    CLLocationCoordinate2D centerCoordinate = view.annotation.coordinate;

    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = span;

    [self.mapView setRegion:region animated:YES];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    self.selectedPark = [self.mapItems objectAtIndex:self.tableView.indexPathForSelectedRow.row];
//    ParkGameViewController *parkGameVC = segue.destinationViewController;
//    parkGameVC.park = self.selectedPark;
//}
-(void)startMonitoringForRegions{
    for (CLCircularRegion *geofence in self.geofences) {
        [self.locationManager startMonitoringForRegion:geofence];
    }
}


#pragma mark ----- MapView Delegate -----

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc]initWithCircle:(MKCircle *)overlay];
        renderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        renderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth = 3.0;
        return renderer;
    }
    return nil;
}


#pragma mark ----- LocationManager Delegate -----

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"Entered region %@", region.identifier);

}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"Exited region %@", region.identifier);

}

-(NSMutableArray *)geofences {
    if (!_geofences){
        _geofences = [NSMutableArray array];
    }
    return _geofences;
}


@end
