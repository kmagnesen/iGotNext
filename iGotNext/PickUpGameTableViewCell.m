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
    self.nameLabel.text = game.title;

    self.gameImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Pin", [self.game.category stringByReplacingOccurrencesOfString:@" " withString:@""]]];
}


@end
