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
#import "User.h"

@interface Game : PFObject <PFSubclassing>

@property NSString *title;
@property NSString *gameDescription;
@property PFGeoPoint *location;
@property User *creator;
@property NSString *category;
@property NSDate *startTime;
@property NSArray *attendees;

-(instancetype)initWithUser:(User *)currentUser andLocation:(MKPointAnnotation *)location;

+ (NSString *)parseClassName;

@end
