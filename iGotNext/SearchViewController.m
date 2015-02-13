//
//  SearchViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "SearchViewController.h"
#import <Parse/Parse.h>

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *allUsers;
@property (nonatomic)  NSMutableArray *allFilteredUsers;
@property BOOL isFiltered;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    self.searchBar.text = @"";
    [self loadUsers];
}

#pragma mark ----------- Loading Users -----------

- (void) loadUsers {
    self.allFilteredUsers = [NSMutableArray new];
    self.allUsers = [NSMutableArray new];

    //TODO: Make it so it only shows users in your area?
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedUsers, NSError *error) {
        if (!error) {
            for (PFUser *user in returnedUsers) {
                [self.allUsers addObject:user];
            }
            self.allFilteredUsers = self.allUsers;
            [self.tableView reloadData];
            if (self.allUsers.count == 0) {
                ;
                //Create an alert view that said no one is currently in your area?
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark ----------- UITableView Delegate & Data Source -----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allFilteredUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    PFUser *user = [self.allFilteredUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    return cell;
}

#pragma mark ----------- UISearchBar -----------

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    if(text.length == 0) {
        self.isFiltered = NO;
        self.allFilteredUsers = [NSMutableArray new];
        self.allFilteredUsers = self.allUsers;
    } else {
        self.isFiltered = YES;
        self.allFilteredUsers = [[NSMutableArray alloc] init];

        for (PFUser *user in self.allUsers) {
            NSRange userRange = [user.username rangeOfString:text options:NSCaseInsensitiveSearch];
            if(userRange.location != NSNotFound) {
                [self.allFilteredUsers addObject:user];
            }
        }
    }
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


@end
