//
//  MasterViewController.m
//  UW Menu
//
//  Created by alykhan.kanji on 07/04/13.
//  Copyright (c) 2013 Alykhan Kanji. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_locations;
}
- (void)retrieveData;
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self retrieveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Restaurant Name" forIndexPath:indexPath];
    NSDictionary *location = _locations[indexPath.row];
    cell.textLabel.text = [location objectForKey:@"outlet_name"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Restaurants";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = _locations[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (void)retrieveData {
    NSData *menuJson = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://uwmenu.com/foodmenu"]];
    NSError *parseError = nil;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:menuJson
                                                            options:kNilOptions
                                                              error:&parseError];
    NSArray *restaurants = [results objectForKey:@"outlets"];
    _locations = [NSMutableArray array];
    for (NSDictionary *restaurant in restaurants) {
        if ([restaurant isKindOfClass:[NSDictionary class]] && [restaurant objectForKey:@"menu"]) {
            [_locations addObject:restaurant];
        }
    }
}

@end
