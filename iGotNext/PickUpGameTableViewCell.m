//
//  HomeFeedTableViewCell.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import "PickUpGameTableViewCell.h"

@implementation PickUpGameTableViewCell

-(void)setEvent:(Event *)event {
    _event = event;
    self.eventNameLabel.text = event.eventTitle;

    NSString *eventStartTime = [NSDateFormatter localizedStringFromDate:event.eventStartTime
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];

    NSString *eventEndTime = [NSDateFormatter localizedStringFromDate:event.eventEndTime
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];

    self.eventTimeLabel.text = [NSString stringWithFormat:@"Starts: %@ Ends: %@", eventStartTime, eventEndTime];
}


@end
