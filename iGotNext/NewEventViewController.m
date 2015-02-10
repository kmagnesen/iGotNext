//
//  NewEventViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "NewEventViewController.h"
#import "HomeFeedViewController.h"
#import "Event.h"

@interface NewEventViewController ()
@property (strong, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sportsArray  = [[NSArray alloc] initWithObjects:@"Basketball",@"Soccer",@"Football",@"Volleyball",@"Baseball",@"Ultimate Frisbee", nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"BackToHomeFeed"]) {
        Event *event = [Event object];

        event.eventCreator = [PFUser currentUser];
        event.eventTitle = self.eventNameTextField.text;
        event.eventDescription = self.descriptionTextField.text;
        event.eventLocation = self.descriptionTextField.text;
        event.eventCategory = self.sportLabel.text;
        event.eventStartTime = self.startDatePicker.date;
        event.eventEndTime = self.endDatePicker.date;

        [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self newEventCreatedAlert];
            } else {
                NSLog(@"new event never saved");
            }
        }];
    }
}

//Alert View Controller that notifies the user that a new event has been created
-(void)newEventCreatedAlert {
    UIAlertController *newEventAlertController = [UIAlertController alertControllerWithTitle:@"Great, you've created a new event!"
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil];
    [newEventAlertController addAction:dismissAction];
    [self presentViewController:newEventAlertController animated:true completion:nil];
}


#pragma mark -------------- UIPickerView Delegate & Data Source --------------
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    return 6;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.sportsArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch(row) {
        case 0:
            self.sportLabel.text = @"Basketball";
            break;
        case 1:
            self.sportLabel.text = @"Soccer";
            break;
        case 2:
            self.sportLabel.text = @"Football";
            break;
        case 3:
            self.sportLabel.text = @"Volleyball";
            break;
        case 4:
            self.sportLabel.text = @"Baseball";
            break;
        case 5:
            self.sportLabel.text = @"Ultimate Frisbee";
            break;
    }
}

@end
