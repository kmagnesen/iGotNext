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

@interface Game : PFObject <PFSubclassing>

@property NSString *title;
@property NSString *description;
@property PFGeoPoint *location;
@property PFUser *creator;
@property NSNumber *attendance;
@property NSString *category;
@property NSDate *startDate;
@property NSDate *startTime;
@property NSDate *endTime;
@property NSArray *attendees;

-(instancetype)initWithUser:(PFUser *)currentUser andLocation:(MKPointAnnotation *)location;

+ (NSString *)parseClassName;

@end
