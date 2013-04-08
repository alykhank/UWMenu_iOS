//
//  DetailViewController.h
//  UW Menu
//
//  Created by alykhan.kanji on 07/04/13.
//  Copyright (c) 2013 Alykhan Kanji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
