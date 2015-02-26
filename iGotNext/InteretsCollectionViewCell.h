//
//  CustomCollectionViewCell.h
//  iGotNext
//
//  Created by Kyle Magnesen on 2/17/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interest.h"

@interface InteretsCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Interest *interest;

@property (strong, nonatomic) IBOutlet UIImageView *sportImageView;
@property (strong, nonatomic) IBOutlet UILabel *sportNameLabel;

@end
