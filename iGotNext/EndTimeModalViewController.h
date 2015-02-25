//
//  EndTimeModalViewController.h
//  iGotNext
//
//  Created by Katelyn Schneider on 2/18/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EndTimeVCDelegate

-(void)endTimeSetWith:(NSDate *)eventEndDate;

@end

@interface EndTimeModalViewController : UIViewController
{
    UIDatePicker *_endDatePicker;
}

@property id<EndTimeVCDelegate> delegate;

@end
