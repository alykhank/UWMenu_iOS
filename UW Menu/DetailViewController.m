//
//  DetailViewController.m
//  UW Menu
//
//  Created by alykhan.kanji on 07/04/13.
//  Copyright (c) 2013 Alykhan Kanji. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

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
        NSString *start = [self.detailItem objectForKey:@"Start"];
        NSString *end = [self.detailItem objectForKey:@"End"];
        NSDictionary *menu = [self.detailItem objectForKey:@"Menu"];
        NSString *menuContents = @"";
        for (NSString *day in menu) {
            menuContents = [menuContents stringByAppendingFormat:@"\n\n  %@:", day];
            for (NSString *meal in [menu objectForKey:day]) {
                menuContents = [menuContents stringByAppendingFormat:@"\n\t%@:", meal];
                id result = [[[[menu objectForKey:day] objectForKey:meal] objectForKey:@"Items"] objectForKey:@"result"];
                if ([result isKindOfClass:[NSString class]]) {
                    menuContents = [menuContents stringByAppendingFormat:@"\n\t%@", result];
                }
                else {
                    for (NSString *item in result) {
                        menuContents = [menuContents stringByAppendingFormat:@"\n\t%@", item];
                    }
                }
            }
        }
        self.detailDescriptionTextView.text = [NSString stringWithFormat:@"Start Date: %@\nEnd Date: %@\nMenu: %@", start, end, menuContents];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
