//
//  GameAnnotation.m
//  iGotNext
//
//  Created by JP Skowron on 2/22/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "GameAnnotation.h"

@implementation GameAnnotation

-(instancetype)initWithGame:(Game *)game {

    self = [super init];

    if (self) {
        CLLocationCoordinate2D pinCoordinate;
        pinCoordinate.latitude = game.location.latitude;
        pinCoordinate.longitude = game.location.longitude;
        self.coordinate = pinCoordinate;

        self.game = game;
        
    }

    return self;
}

-(void)setGame:(Game *)game {
    _game = game;
    self.title = game.title;
}


@end
