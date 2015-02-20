//
//  Event.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "Game.h"

@implementation Game

@dynamic title;
@dynamic description;
@dynamic creator;
@dynamic location;
@dynamic attendance;
@dynamic category;
@dynamic startTime;
@dynamic endTime;
@dynamic attendees;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Game";
}

-(instancetype)initWithUser:(PFUser *)currentUser andLocation:(MKPointAnnotation *)location {
    self = [super init];

    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude
                                               longitude:location.coordinate.longitude];

    if (self) {
        self.creator = currentUser;
        self.location = point;
    }

    return self;
}
@end
