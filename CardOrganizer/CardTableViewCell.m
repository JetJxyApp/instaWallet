//
//  CardTableViewCell.m
//  CardOrganizer
//
//  Created by Lei Peng on 2014-12-21.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import "CardTableViewCell.h"

@implementation CardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
