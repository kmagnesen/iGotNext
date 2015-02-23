//
//  SignUpViewController.h
//  iGotNext
//
//  Created by Kyle Magnesen on 2/22/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignUpMVCDelegate

-(void)signUp;

@end

@interface SignUpModalViewController : UIViewController

{
    UITextField *usernameTF;
    UITextField *passwordTF;
}

@property id<SignUpMVCDelegate> delegate;

@end
