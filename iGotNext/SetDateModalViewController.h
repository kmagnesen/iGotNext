//
//  SetDateModalViewController.h
//  iGotNext
//
//  Created by Kyle Magnesen on 2/24/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StartDateVCDelegate

-(void)startDateSetWith:(NSDate *)eventStartDate;

@end

@interface SetDateModalViewController : UIViewController

{
    UIDatePicker *_datePicker;
}

@property id<StartDateVCDelegate> delegate;

@end

