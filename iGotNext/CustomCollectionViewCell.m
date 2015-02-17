//
//  CustomCollectionViewCell.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/17/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (void)setSportNameLabel:(UILabel *)sportNameLabel {
    self.sportNameLabel.text = self.interest.sportName;
}

@end
