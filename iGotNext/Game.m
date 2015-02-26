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
@dynamic gameDescription;
@dynamic creator;
@dynamic location;
@dynamic category;
@dynamic startTime;
@dynamic attendees;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Game";
}

-(instancetype)initWithUser:(User *)currentUser andLocation:(MKPointAnnotation *)location {
    self = [super init];

    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude
                                               longitude:location.coordinate.longitude];

    if (self) {
        self.creator = currentUser;
        self.location = point;
        self.attendees = [NSArray new];
    }

    return self;
}
@end
