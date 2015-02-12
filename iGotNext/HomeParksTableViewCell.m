//
//  HomeParksTableViewCell.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/12/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import "HomeParksTableViewCell.h"

@implementation HomeParksTableViewCell

-(void)setPark:(MKMapItem *)park {
    _park = park;

    self.textLabel.text = self.park.name;
}

@end
