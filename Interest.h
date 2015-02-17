//
//  Interest.h
//  iGotNext
//
//  Created by Kyle Magnesen on 2/17/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Interest : NSObject

-(instancetype)initWithImage:(UIImage *)image andSportName:(NSString *)name;

@property UIImage *sportImage;
@property NSString *sportName;

@end
