//
//  HomeFeedTableViewCell.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import "PickUpGameTableViewCell.h"

@implementation PickUpGameTableViewCell


-(void)setGame:(Game *)game {
    _game = game;
    self.eventNameLabel.text = game.title;

    NSString *gameStartTime = [NSDateFormatter localizedStringFromDate:game.startTime
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];

    NSString *gameEndTime = [NSDateFormatter localizedStringFromDate:game.endTime
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];

    self.eventTimeLabel.text = [NSString stringWithFormat:@"Starts: %@ Ends: %@", gameStartTime, gameEndTime];
}


@end
