//
//  NewEventViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "NewEventViewController.h"
#import "ParkGameViewController.h"
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
}

//On Post button pressed, segue back saves newly created event
//TODO: segue needs to be changed to appropriate VC
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"BackToHomeFeed"]) {
        PFUser *currentUser = [PFUser currentUser];

        Event *event = [[Event alloc] initWithUser:currentUser
                                             Title:self.eventNameTextField
                                       Description:self.descriptionTextField
                                          Location:self.descriptionTextField
                                          Category:self.sportLabel
                                         StartTime:self.startDatePicker
                                           EndTime:self.endDatePicker];

        [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"New event saved, but this is a reminder to work on the event that the event does not save");
            } else {
                NSLog(@"New event never saved, work on notification that makes sense for user");
            }
        }];
    }
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
