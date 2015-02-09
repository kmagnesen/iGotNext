//
//  NewEventViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "NewEventViewController.h"

@interface NewEventViewController ()

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sportsArray  = [[NSArray alloc] initWithObjects:@"Basketball",@"Soccer",@"Football",@"Volleyball",@"Baseball",@"Ultimate Frisbee" , nil];
}

- (IBAction)onPostButtonTapped:(UIBarButtonItem *)sender {
    
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

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component {
    return [self.sportsArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component {
    NSLog(@"Selected Row %ld", (long)row);
    switch(row)
    {

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
