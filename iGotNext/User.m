//
//  User.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/24/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize interests;

+(void)load {
    [self registerSubclass];
}

-(instancetype)initWithInterests:(NSArray *)newInterests completed:(void(^)(BOOL result, NSError *error))completionHandler {
    self = [super init];
    self.interests = newInterests;
    [self signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completionHandler(succeeded, error);
    }];
    return self;
}

@end
