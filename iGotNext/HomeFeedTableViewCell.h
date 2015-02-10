//
//  HomeFeedTableViewCell.h
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface HomeFeedTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventAttendingLabel;
@property (nonatomic) Event *event;
@end
