//
//  EditCollectionViewCell.h
//  iGotNext
//
//  Created by Kyle Magnesen on 2/19/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interest.h"

@interface EditCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Interest *interest;

@property (strong, nonatomic) IBOutlet UIImageView *sportImage;
@property (strong, nonatomic) IBOutlet UILabel *sportName;

@end
