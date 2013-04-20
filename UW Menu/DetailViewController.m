//
//  DetailViewController.m
//  UW Menu
//
//  Created by alykhan.kanji on 07/04/13.
//  Copyright (c) 2013 Alykhan Kanji. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (nonatomic, strong) NSMutableArray *restaurant;
- (void)configureView;
- (void)organizeMenuContents;
@end

@implementation DetailViewController

@synthesize restaurant = _restaurant;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.navigationItem.title = [self.detailItem objectForKey:@"Name"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.detailDescriptionTableView.delegate = self;
    self.detailDescriptionTableView.dataSource = self;
    [self organizeMenuContents];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    switch (section) {
        case 0:
            title = @"Monday";
            break;
        case 1:
            title = @"Tuesday";
            break;
        case 2:
            title = @"Wednesday";
            break;
        case 3:
            title = @"Thursday";
            break;
        case 4:
            title = @"Friday";
            break;
        default:
            break;
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSDictionary *) self.restaurant[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Meal" forIndexPath:indexPath];
    
    NSDictionary *object;
    if (indexPath.row == 0) {
        object = [self.restaurant[indexPath.section] objectForKey:@"Lunch"];
        cell.textLabel.text = @"Lunch";
    }
    else {
        object = [self.restaurant[indexPath.section] objectForKey:@"Dinner"];
        cell.textLabel.text = @"Dinner";
    }
    cell.detailTextLabel.text = [[object objectForKey:@"Items"] objectForKey:@"result"];
    return cell;
}

- (void)organizeMenuContents
{
    if (self.detailItem) {
        self.restaurant = [NSMutableArray arrayWithCapacity:5];
        self.restaurant[0] = [[self.detailItem objectForKey:@"Menu"] objectForKey:@"Monday"];
        self.restaurant[1] = [[self.detailItem objectForKey:@"Menu"] objectForKey:@"Tuesday"];
        self.restaurant[2] = [[self.detailItem objectForKey:@"Menu"] objectForKey:@"Wednesday"];
        self.restaurant[3] = [[self.detailItem objectForKey:@"Menu"] objectForKey:@"Thursday"];
        self.restaurant[4] = [[self.detailItem objectForKey:@"Menu"] objectForKey:@"Friday"];
    }
}

@end
