//
//  CardTableViewCell.h
//  CardOrganizer
//
//  Created by Lei Peng on 2014-12-21.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLable;

@end
