//
//  CustomCollectionViewCell.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/17/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "InteretsCollectionViewCell.h"

@implementation InteretsCollectionViewCell

- (void)setInterest:(Interest *)interest {
    _interest = interest;
    self.sportNameLabel.text = interest.sportName;
    self.sportImageView.image = interest.sportImage;
}

@end
