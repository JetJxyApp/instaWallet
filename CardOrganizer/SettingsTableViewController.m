//
//  SettingsTableViewController.m
//  CardOrganizer
//
//  Created by Lei Peng on 2015-01-05.
//  Copyright (c) 2015 Jet&JXY. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Settings";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.29 green:0.65 blue:0.96 alpha:1.0];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



//set the row height of cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

/*
 *  User choose one of the settings
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"select %ld", indexPath.row);
    if (indexPath.row == 0) {
        NSString *iTunesLink = @"https://itunes.apple.com/ca/app/instawallet/id956331415?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
    else if (indexPath.row == 1)
    {
        NSString *text = @"How to add Facebook and Twitter sharing to an iOS app";
        NSURL *url = [NSURL URLWithString:@"http://roadfiresoftware.com/2014/02/how-to-add-facebook-and-twitter-sharing-to-an-ios-app/"];
        UIImage *image = [UIImage imageNamed:@"your_card.png"];
        
        UIActivityViewController *controller =[[UIActivityViewController alloc]initWithActivityItems:@[text, url, image]applicationActivities:nil];
        
        controller.excludedActivityTypes = @[UIActivityTypePrint,
                                             UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,
                                             UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypeAddToReadingList,
                                             UIActivityTypeAirDrop];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
    
}





@end
