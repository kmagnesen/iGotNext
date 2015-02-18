//
//  Event.h
//  iGotNext
//
//  Created by Katelyn Schneider on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface Event : PFObject <PFSubclassing>

@property NSString *eventTitle;
@property NSString *eventDescription;
@property NSString *eventLocation;
@property PFUser *eventCreator;
@property NSNumber *eventAttendance;
@property NSString *eventCategory;
@property NSDate *eventStartTime;
@property NSDate *eventEndTime;
@property NSArray *attendees;

-(instancetype)initWithUser:(PFUser *)currentUser Title:(UITextField *)title Description:(UITextField *)description Location:(MKMapItem *)location Category:(NSString *)category StartTime:(NSDate *)startTime EndTime:(NSDate *)endTime ;

+ (NSString *)parseClassName;

@end
