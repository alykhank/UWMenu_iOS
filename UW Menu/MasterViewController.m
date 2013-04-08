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

- (void)awakeFromNib
{
    [super awakeFromNib];
}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *object = _locations[indexPath.row];
    cell.textLabel.text = [object objectForKey:@"Name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _locations[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (void)retrieveData {
    NSData *menuJson = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://gentle-harbor-2155.herokuapp.com/foodmenu"]];
    NSError *parseError = nil;
    
    NSDictionary *restaurants = [NSJSONSerialization JSONObjectWithData:menuJson
                                                                options:kNilOptions
                                                                  error:&parseError];
    
    NSDictionary *results = [restaurants objectForKey:@"Restaurants"];
    
    _locations = [[NSMutableArray alloc] init];
    for (NSDictionary *restaurant in [results allValues]) {
        if ([restaurant isKindOfClass:[NSDictionary class]]) {
            [_locations addObject:restaurant];
        }
    }
    
}

@end
