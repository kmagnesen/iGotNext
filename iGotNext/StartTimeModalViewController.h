//
//  StartTimeModalViewController.h
//  iGotNext
//
//  Created by Katelyn Schneider on 2/18/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StartTimeVCDelegate

-(void)startTimeSetWith:(NSDate *)eventStartDate;

@end

@interface StartTimeModalViewController : UIViewController
{
    UIDatePicker *_datePicker;
}

@property id<StartTimeVCDelegate> delegate;

@end

