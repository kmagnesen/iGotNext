//
//  ActivityTableViewCell.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/24/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ActivityTableViewCell.h"

@implementation ActivityTableViewCell

-(void)setGame:(Game *)game {
    _game = game;

    self.gameTitle.text = game.title;
    self.gameAttendance.text = [NSString stringWithFormat:@"Attendance: %lu people", (unsigned long)game.attendees.count];
    self.gameImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", game.category]];
}

@end
