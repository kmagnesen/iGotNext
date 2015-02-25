//
//  GameDetailTableViewCell.h
//  iGotNext
//
//  Created by Katelyn Schneider on 2/24/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface GameDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@property (nonatomic) User *user;

@end
