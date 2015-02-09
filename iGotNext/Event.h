//
//  Event.h
//  iGotNext
//
//  Created by Katelyn Schneider on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface Event : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property NSString *eventTitle;
@property NSString *eventDescription;
@property NSString *eventLocation;
@property PFUser *eventCreator;
@property NSNumber *eventAttendance;
@property NSString *eventCategory;
@property NSDate *eventDate;

@end
