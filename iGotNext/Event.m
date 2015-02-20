//
//  Event.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "Event.h"

@implementation Event

@dynamic eventTitle;
@dynamic eventDescription;
@dynamic eventCreator;
@dynamic location;
@dynamic eventAttendance;
@dynamic eventCategory;
@dynamic eventStartTime;
@dynamic eventEndTime;
@dynamic attendees;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Event";
}

-(instancetype)initWithUser:(PFUser *)currentUser andLocation:(MKPointAnnotation *)location {
    self = [super init];

    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude
                                               longitude:location.coordinate.longitude];

    if (self) {
        self.eventCreator = currentUser;
        self.location = point;
    }

    return self;
}
@end
