//
//  NewEventViewController.h
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "Game.h"
@protocol NewGameDelegate

-(void)updateGames;

@end

@interface NewGameViewController : UIViewController 

@property Game *game;

@property id<NewGameDelegate> delegate;

@end
