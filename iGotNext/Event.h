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

@property NSString *eventTitle;
@property NSString *eventDescription;
@property NSString *eventLocation;
@property PFUser *eventCreator;
@property NSNumber *eventAttendance;
@property NSString *eventCategory;
@property NSDate *eventStartTime;
@property NSDate *eventEndTime;

-(instancetype)initWithUser:(PFUser *)currentUser Title:(UITextField *)title Description:(UITextField *)description Location:(UITextField *)location Category:(UILabel *)category StartTime:(UIDatePicker *)startTime EndTime:(UIDatePicker *)endTime;

+ (NSString *)parseClassName;

@end
