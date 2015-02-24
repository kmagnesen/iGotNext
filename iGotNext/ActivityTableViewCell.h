//
//  ActivityTableViewCell.h
//  iGotNext
//
//  Created by Katelyn Schneider on 2/24/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface ActivityTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *gameImageView;
@property (strong, nonatomic) IBOutlet UILabel *gameTitle;
@property (strong, nonatomic) IBOutlet UILabel *gameAttendance;

@property (nonatomic) Game *game;
@end
