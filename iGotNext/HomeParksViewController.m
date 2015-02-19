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
#import "ParkGameViewController.h"
#import "HomeParksTableViewCell.h"

@interface HomeParksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UISearchBarDelegate>

@property CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property NSArray *mapItems;
@property MKMapItem *selectedPark;
@property MKPointAnnotation *parksAnnotation;
@property (nonatomic)NSMutableArray *geofences;
@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;


@end

@implementation HomeParksViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];

    [self.locationManager startUpdatingLocation];

    self.selectedPark = [MKMapItem new];
    self.parksAnnotation = [MKPointAnnotation new];
    self.searchBar.delegate = self;

    [self setUpLongTouchGesture];

}

-(void)setUpLongTouchGesture {
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;

    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annot];
}
//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [searchBar resignFirstResponder];
//}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.mapView.showsUserLocation = YES;
}

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
    request.naturalLanguageQuery = @"Recreation";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.mapItems = response.mapItems;

        for (MKMapItem *parkMapItem in self.mapItems) {
            CLLocationCoordinate2D coordinate = parkMapItem.placemark.location.coordinate;

            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
            annotation.coordinate = coordinate;
            NSLog(@"%@", parkMapItem.placemark.name);
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


#pragma mark - Table View Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%li", self.mapItems.count);
    return self.mapItems.count;
//    return 3;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeParksTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellID"];
    MKMapItem *park = [self.mapItems objectAtIndex:indexPath.row];
    cell.park = park;

    return cell;
}
- (IBAction)segementedControlSwitched:(UISegmentedControl *)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;

    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        [self.tableView setHidden:NO];
        [self.mapView setHidden:YES];
    }
    else{
        //toggle the correct view to be visible
        [self.tableView setHidden:YES];
        [self.mapView setHidden:NO];
    }
}

#pragma mark - MK Map View Methods

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.selectedPark = [self.mapItems objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    ParkGameViewController *parkGameVC = segue.destinationViewController;
    parkGameVC.park = self.selectedPark;
}
-(void)startMonitoringForRegions{
    for (CLCircularRegion *geofence in self.geofences) {
        [self.locationManager startMonitoringForRegion:geofence];
    }
}

#pragma MapView Delegate

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

#pragma LocationManager Delegate


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
