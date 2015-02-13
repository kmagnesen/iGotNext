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

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Event";
}

-(instancetype)initWithUser:(PFUser *)currentUser Title:(UITextField *)title Description:(UITextView *)description Location:(MKMapItem *)location Category:(NSString *)category StartTime:(UIDatePicker *)startTime EndTime:(UIDatePicker *)endTime {

    self = [super init];

    if (self) {
        self.eventCreator = currentUser;
        self.eventTitle = title.text;
        self.eventDescription = description.text;
        self.eventLocation = location.name;
        self.eventCategory = category;
        self.eventStartTime = startTime.date;
        self.eventEndTime = endTime.date;
    }

    return self;
}

@end
