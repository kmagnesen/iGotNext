//
//  CategoryModalViewController.h
//  iGotNext
//
//  Created by Katelyn Schneider on 2/17/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CategoryVCDelegate

//required method where CategoryVCDelegate ensures category gets set
-(void)categorySetWith:(NSString *)sportCategory;

@end

@interface CategoryModalViewController : UIViewController

@property id<CategoryVCDelegate> delegate;

@end
