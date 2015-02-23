//
//  Interest.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/17/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "Interest.h"

@implementation Interest


-(instancetype)initWithImage:(UIImage *)image andSportName:(NSString *)name {
    self = [super init];
    self.sportImage = image;
    self.sportName = name;

    return self;
}

@end
