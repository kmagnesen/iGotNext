//
//  ProfileTableViewCell.h
//  iGotNext
//
//  Created by Katelyn Schneider on 2/25/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interest.h"

@interface ProfileTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *sportImageView;
@property (strong, nonatomic) IBOutlet UILabel *sportLabel;

@property (nonatomic) Interest *interest;

@end
