//
//  DetailViewController.m
//  UW Menu
//
//  Created by alykhan.kanji on 07/04/13.
//  Copyright (c) 2013 Alykhan Kanji. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (nonatomic, strong) NSMutableArray *menuItems;
- (void)configureView;
- (void)organizeMenuContents;
@end

@implementation DetailViewController

@synthesize menuItems = _menuItems;

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
    [self.detailDescriptionTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *object = self.menuItems[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (void)organizeMenuContents
{
    if (self.detailItem) {
        self.menuItems = [[NSMutableArray alloc] init];
        [self.menuItems addObject:[NSString stringWithFormat:@"Start: %@", [self.detailItem objectForKey:@"Start"]]];
        [self.menuItems addObject:[NSString stringWithFormat:@"End: %@", [self.detailItem objectForKey:@"End"]]];
        NSDictionary *menu = [self.detailItem objectForKey:@"Menu"];
        for (NSString *day in menu) {
            [self.menuItems addObject:day];
            for (NSString *meal in [menu objectForKey:day]) {
                [self.menuItems addObject:meal];
                id result = [[[[menu objectForKey:day] objectForKey:meal] objectForKey:@"Items"] objectForKey:@"result"];
                if ([result isKindOfClass:[NSString class]]) {
                    [self.menuItems addObject:result];
                }
                else {
                    for (NSString *item in result) {
                        [self.menuItems addObject:item];
                    }
                }
            }
        }
    }
}

@end
