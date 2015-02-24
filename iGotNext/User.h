//
//  User.h
//  iGotNext
//
//  Created by Kyle Magnesen on 2/24/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing>

@property NSArray *interests;

-(instancetype)initWithInterests:(NSArray *)newInterests completed:(void(^)(BOOL result, NSError *error))completionHandler;
@end
