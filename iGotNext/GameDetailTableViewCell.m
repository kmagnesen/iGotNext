//
//  GameDetailTableViewCell.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/24/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "GameDetailTableViewCell.h"

@implementation GameDetailTableViewCell

-(void)setUser:(User *)user {
    _user = user;
    self.userNameLabel.text = user.username;
}

@end
