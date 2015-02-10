//
//  HomeFeedTableViewCell.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "HomeFeedTableViewCell.h"

@implementation HomeFeedTableViewCell

-(void)setEvent:(Event *)event {
    _event = event;
    self.eventNameLabel.text = event.eventTitle;
    self.eventLocationLabel.text = event.eventLocation;
    self.eventTimeLabel.text = [NSString stringWithFormat:@"When:%@", event.eventDate];

}

@end
