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

@interface NewEventViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
//@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
//@property (strong, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (strong, nonatomic) IBOutlet UILabel *sportLabel;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurredView;
@property (strong, nonatomic) NSArray *sportsArray;
@property NSString *category;

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.category = [NSString new];

    self.navigationItem.title = self.park.name;

    self.sportsArray = @[@"Basketball", @"Disc Golf", @"Dodgeball", @"Football", @"Hockey (Street/Ice)", @"Soccer", @"Ultimate Frisbee", @"VolleyBall (Beach/Bar)", @"Yugigassen (Snowball Fighting)", @"All Other Sports"];
}

//On Post button pressed, segue back saves newly created event
//TODO: segue needs to be changed to appropriate VC
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"BackToHomeFeed"]) {
        PFUser *currentUser = [PFUser currentUser];

        Event *event = [[Event alloc] initWithUser:currentUser
                                             Title:self.eventNameTextField
                                       Description:self.descriptionTextView
                                          Location:self.park
                                          Category:self.category
                                         StartTime:nil
                                           EndTime:nil];

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
    return self.sportsArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.sportsArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    switch(row) {
        case 0:
            self.sportLabel.text = @"Sport Chosen: Basketball";
            self.category = @"Basketball";
            break;
        case 1:
            self.sportLabel.text = @"Sport Chosen: Disc Golf";
            self.category = @"Disc Golf";
            break;
        case 2:
            self.sportLabel.text = @"Sport Chosen: Dodgeball";
            self.category = @"Dodgeball";
            break;
        case 3:
            self.sportLabel.text = @"Sport Chosen: Football";
            self.category = @"Football";
            break;
        case 4:
            self.sportLabel.text = @"Sport Chosen: Hockey (Street/Ice)";
            self.category = @"Hockey (Street/Ice)";
            break;
        case 5:
            self.sportLabel.text = @"Sport Chosen: Soccer";
            self.category = @"Soccer";
            break;
        case 6:
            self.sportLabel.text = @"Sport Chosen: Ultimate Frisbee";
            self.category = @"Ultimate Frisbee";
            break;
        case 7:
            self.sportLabel.text = @"Sport Chosen: VolleyBall (Beach/Bar)";
            self.category = @"VolleyBall (Beach/Bar)";
            break;
        case 8:
            self.sportLabel.text = @"Sport Chosen: Yugigassen (Snowball Fighting)";
            self.category = @"Yugigassen (Snowball Fighting)";
            break;
        case 9:
            self.sportLabel.text = @"Sport Chosen: All Other Sports";
            self.category = @"All Other Sports";
            break;
    }
}

//SetStartTimeSegue
//SetEndTimeSegue
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {

}



@end
