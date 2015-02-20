//
//  EditInterestsModalViewController.h
//  iGotNext
//
//  Created by Kyle Magnesen on 2/19/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpdateInterestTVCDelegate

-(void)updateInterests;

@end

@interface EditInterestsModalViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

{
UICollectionView *_collectionView;
}

@property id<UpdateInterestTVCDelegate> delegate;

@end




