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

//    [self addSportImageView];
}

//-(void)addSportImageView{
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.sportImage
//                                                                attribute:NSLayoutAttributeCenterX
//                                                                relatedBy:NSLayoutRelationEqual
//                                                                   toItem:self.contentView
//                                                                attribute:NSLayoutAttributeCenterX
//                                                               multiplier:1.f
//                                                                 constant:0.f]];
//
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[sportImage]-0-|"
//                                                                            options:0
//                                                                            metrics:nil
//                                                                              views:NSDictionaryOfVariableBindings(self.sportImage)]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sportImage]-0-|"
//                                                                            options:0
//                                                                            metrics:nil
//                                                                              views:NSDictionaryOfVariableBindings(self.sportImage)]];
//}

@end
