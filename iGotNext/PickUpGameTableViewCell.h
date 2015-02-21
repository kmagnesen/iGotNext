//
//  HomeFeedTableViewCell.h
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface PickUpGameTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *attendingLabel;
@property (nonatomic) Game *game;
@end
