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
    
    cell.textLabel.text = [location objectForKey:@"Name"];
    
//    NSString *start = [object objectForKey:@"Start"];
//    start = [[start substringToIndex:[start length]-5] stringByReplacingOccurrencesOfString:@"-" withString:@" "];
//    NSString *end = [object objectForKey:@"End"];
//    end = [[end substringToIndex:[end length]-5] stringByReplacingOccurrencesOfString:@"-" withString:@" "];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", start, end];
    
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
    NSData *menuJson = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://gentle-harbor-2155.herokuapp.com/foodmenu"]];
    NSError *parseError = nil;
    
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:menuJson
                                                                options:kNilOptions
                                                                  error:&parseError];
    
    NSLog(@"Response: %@", results);
    NSDictionary *restaurants = [results objectForKey:@"Restaurants"];
    
    _locations = [[NSMutableArray alloc] init];
    for (NSDictionary *restaurant in [restaurants allValues]) {
        if ([restaurant isKindOfClass:[NSDictionary class]] && [restaurant objectForKey:@"Menu"]) {
            [_locations addObject:restaurant];
        }
    }
    
}

@end
