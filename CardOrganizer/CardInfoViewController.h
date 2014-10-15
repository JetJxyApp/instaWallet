//
//  CardInfoViewController.h
//  CardOrganizer
//
//  Created by Jiang on 2014-09-23.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardInfoViewController : UIViewController

@property(nonatomic, strong) NSMutableArray * cardPath;
@property (nonatomic,strong) NSMutableArray * cards;
@property(nonatomic) NSInteger rowNumer;

@end
