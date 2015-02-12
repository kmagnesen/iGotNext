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

@interface HomeParksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UISearchBarDelegate>

@property CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property NSArray *mapItems;
@property MKMapItem *selectedPark;



@end

@implementation HomeParksViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];

    [self.locationManager startUpdatingLocation];
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
    request.naturalLanguageQuery = @"Park";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.mapItems = response.mapItems;

        for (MKMapItem *mapItem in self.mapItems) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
            annotation.coordinate = mapItem.placemark.location.coordinate;
            [self.mapView addAnnotation:annotation];
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellID"];
    MKMapItem *park = [self.mapItems objectAtIndex:indexPath.row];
    cell.textLabel.text = park.name;

    NSLog(@"Hey it's me ben: %@", self.mapItems);
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ParkGameViewController *parkGameVC = segue.destinationViewController;
    parkGameVC.park = self.selectedPark;
}


@end
