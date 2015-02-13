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

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self loadUsers];
}

- (void) setAllUsers:(NSMutableArray *)allUsers {
    _allUsers = allUsers;
    [self.tableView reloadData];
}

- (void) loadUsers {

    self.allUsers = [NSMutableArray new];

    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query orderByDescending:@"updatedAt"];
    dispatch_queue_t feedQueue = dispatch_queue_create("feedQueue", NULL);

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {
//            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            dispatch_async(feedQueue, ^{

                for (PFObject *object in objects) {
                    [self.allUsers addObject:[object objectForKey:@"username"]];
                    NSLog(@"%@", [object objectForKey:@"username"]);
//                NSLog(@"%lu", (unsigned long)eventNames.count);
                }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                });
            });
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark ----------- UITableView Delegate & Data Source -----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    cell.textLabel.text = [self.allUsers objectAtIndex:indexPath.row];

    return cell;
}

@end
