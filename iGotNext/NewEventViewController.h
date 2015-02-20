//
//  NewEventViewController.h
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "Event.h"

@interface NewEventViewController : UIViewController 

@property MKMapItem *park;

@property Event *event;

@end
