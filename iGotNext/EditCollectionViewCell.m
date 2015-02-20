//
//  EditCollectionViewCell.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/19/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "EditCollectionViewCell.h"

@implementation EditCollectionViewCell

- (void)setInterest:(Interest *)interest {
    _interest = interest;
    self.sportName.text = interest.sportName;
    self.sportImage.image = interest.sportImage;

}


@end
