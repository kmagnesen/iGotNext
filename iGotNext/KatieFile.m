//
//  KatieFile.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/20/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "KatieFile.h"

//remember to import these frameworks
#import "Event.h"
#import <Parse/Parse.h>
#import "NewEventViewController.h"


@implementation KatieFile


#pragma ----- Creating Event Parse Object ------

-(void) confirmLocationAlert {
    UIAlertView *confirmationAlert = [[UIAlertView alloc] initWithTitle: @"Title"
                                                                message:@"Are you sure you want to create a new pick-up game here?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Yes", nil];
    [confirmationAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        ;
    }else{
 //       [self prepareForSegue:@"CreateNewPickUpGame" sender:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"CreateNewPickUpGame"]) {
        PFUser *currentUser = [PFUser currentUser];
        Event *event = [[Event alloc] initWithUser:currentUser andLocation:self.dummyLocation];
        [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"New event saved, but this is a reminder to work on the event that the event does not save");
            } else {
                NSLog(@"New event never saved, work on notification that makes sense for user");
            }
        }];

        NewEventViewController *newEventVC = segue.destinationViewController;
        newEventVC.event = event;

    }
}

#pragma ----- TableView Methods ------

@end
