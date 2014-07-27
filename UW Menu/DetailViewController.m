//
//  DetailViewController.m
//  UW Menu
//
//  Created by alykhan.kanji on 07/04/13.
//  Copyright (c) 2013 Alykhan Kanji. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () {
    NSMutableArray *_restaurant;
    NSMutableDictionary *_meals;
}
- (void)configureView;
- (void)organizeMenuContents;

typedef enum MEAL {
    MONDAY_LUNCH,
    MONDAY_DINNER,
    TUESDAY_LUNCH,
    TUESDAY_DINNER,
    WEDNESDAY_LUNCH,
    WEDNESDAY_DINNER,
    THURSDAY_LUNCH,
    THURSDAY_DINNER,
    FRIDAY_LUNCH,
    FRIDAY_DINNER
} mealName;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;

        // Flatten meals into an array.
        [self organizeMenuContents];
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.navigationItem.title = [self.detailItem objectForKey:@"outlet_name"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.detailDescriptionTableView.delegate = self;
    self.detailDescriptionTableView.dataSource = self;
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections = 0;
    for (NSDictionary *day in [self.detailItem objectForKey:@"menu"]) {
        if ([[day objectForKey:@"meals"] objectForKey:@"lunch"]) {
            sections += 1;
        }
        if ([[day objectForKey:@"meals"] objectForKey:@"dinner"]) {
            sections += 1;
        }
    }
    return sections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_meals objectForKey:[NSNumber numberWithInteger:section]] objectForKey:@"mealName"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_meals objectForKey:[NSNumber numberWithInteger:section]]) {
        return [[[_meals objectForKey:[NSNumber numberWithInteger:section]] objectForKey:@"mealData"] count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Meal" forIndexPath:indexPath];
    NSArray *mealData = [[_meals objectForKey:[NSNumber numberWithInteger:indexPath.section]] objectForKey:@"mealData"];
    if ([mealData[indexPath.row] objectForKey:@"product_name"]) {
        cell.textLabel.text = [mealData[indexPath.row] objectForKey:@"product_name"];
    }
    NSString *dietType = [mealData[indexPath.row] objectForKey:@"diet_type"];
    if (dietType && ![dietType isKindOfClass:[NSNull class]]) {
        cell.detailTextLabel.text = dietType;
    } else {
        cell.detailTextLabel.text = nil;
    }
    return cell;
}

- (NSNumber *)computeDayValueWith:(NSString *)dayName andIsLunchMealType:(BOOL)isLunch
{
    NSNumber *mealNumber = nil;
    if (isLunch) {
        if ([dayName isEqualToString:@"Monday"]) {
            mealNumber = [NSNumber numberWithInt:MONDAY_LUNCH];
        } else if ([dayName isEqualToString:@"Tuesday"]) {
            mealNumber = [NSNumber numberWithInt:TUESDAY_LUNCH];
        } else if ([dayName isEqualToString:@"Wednesday"]) {
            mealNumber = [NSNumber numberWithInt:WEDNESDAY_LUNCH];
        } else if ([dayName isEqualToString:@"Thursday"]) {
            mealNumber = [NSNumber numberWithInt:THURSDAY_LUNCH];
        } else if ([dayName isEqualToString:@"Friday"]) {
            mealNumber = [NSNumber numberWithInt:FRIDAY_LUNCH];
        }
    } else {
        if ([dayName isEqualToString:@"Monday"]) {
            mealNumber = [NSNumber numberWithInt:MONDAY_DINNER];
        } else if ([dayName isEqualToString:@"Tuesday"]) {
            mealNumber = [NSNumber numberWithInt:TUESDAY_DINNER];
        } else if ([dayName isEqualToString:@"Wednesday"]) {
            mealNumber = [NSNumber numberWithInt:WEDNESDAY_DINNER];
        } else if ([dayName isEqualToString:@"Thursday"]) {
            mealNumber = [NSNumber numberWithInt:THURSDAY_DINNER];
        } else if ([dayName isEqualToString:@"Friday"]) {
            mealNumber = [NSNumber numberWithInt:FRIDAY_DINNER];
        }
    }
    return mealNumber;
}

- (void)organizeMenuContents
{
    _meals = [NSMutableDictionary dictionary];
    for (NSDictionary *day in [self.detailItem objectForKey:@"menu"]) {
        NSString *dayName = [day objectForKey:@"day"];
        NSArray *lunch = [[day objectForKey:@"meals"] objectForKey:@"lunch"];
        NSArray *dinner = [[day objectForKey:@"meals"] objectForKey:@"dinner"];
        if ([lunch count]) {
            NSMutableDictionary *mealValue = [NSMutableDictionary dictionary];
            [mealValue setValue:[NSString stringWithFormat:@"%@ Lunch", dayName] forKey:@"mealName"];
            [mealValue setValue:lunch forKey:@"mealData"];
            NSNumber *mealNumber;
            mealNumber = [self computeDayValueWith:dayName andIsLunchMealType:TRUE];
            [_meals setObject:mealValue forKey:mealNumber];
        }
        if ([dinner count]) {
            NSMutableDictionary *mealValue = [NSMutableDictionary dictionary];
            [mealValue setValue:[NSString stringWithFormat:@"%@ Dinner", dayName] forKey:@"mealName"];
            [mealValue setValue:dinner forKey:@"mealData"];
            NSNumber *mealNumber;
            mealNumber = [self computeDayValueWith:dayName andIsLunchMealType:FALSE];
            [_meals setObject:mealValue forKey:mealNumber];
        }
    }
}

@end
