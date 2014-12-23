//
//  AllCardsTableViewController.h
//  CardOrganizer
//
//  Created by Jiang on 2014-09-23.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllCardsTableViewController : UITableViewController


@property (nonatomic,strong) NSMutableArray * cardPath;
@property (nonatomic,strong) NSMutableArray * cards;
@property (nonatomic,strong) NSMutableArray * searchResults; //delete card in search results table view

@end
