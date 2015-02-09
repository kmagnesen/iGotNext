//
//  Event.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <Parse/Parse.h>
#import "Event.h"

@implementation Event

@dynamic eventTitle;
@dynamic eventDescription;
@dynamic eventCreator;
@dynamic eventLocation;
@dynamic eventattendance;
@dynamic eventCategory;
@dynamic eventDate;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Event";
}

@end
