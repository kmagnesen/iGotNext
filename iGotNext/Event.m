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
@dynamic eventLocation;
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

-(instancetype)initWithUser:(PFUser *)currentUser Title:(UITextField *)title Description:(UITextField *)description Location:(MKMapItem *)location Category:(NSString *)category StartTime:(NSDate *)startTime EndTime:(NSDate *)endTime {

    self = [super init];

    if (self) {
        self.eventCreator = currentUser;
        self.eventTitle = title.text;
        self.eventDescription = description.text;
        self.eventLocation = location.name;
        self.eventCategory = category;
        self.eventStartTime = startTime;
        self.eventEndTime = endTime;
    }

    return self;
}

@end
