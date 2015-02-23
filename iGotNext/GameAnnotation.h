//
//  GameAnnotation.h
//  iGotNext
//
//  Created by JP Skowron on 2/22/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Game.h"

@interface GameAnnotation : MKPointAnnotation

@property (nonatomic) Game *game;

-(instancetype)initWithGame:(Game *)game;

@end
