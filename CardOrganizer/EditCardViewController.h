//
//  EditCardViewController.h
//  CardOrganizer
//
//  Created by Jiang on 2014-10-14.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@interface EditCardViewController : UIViewController

@property(nonatomic, strong) NSMutableArray * cardPath;//for receiving file path when entering edit card veiw controller

@property (nonatomic,strong) NSMutableArray * cards;//path of all cards
@property(nonatomic) NSInteger rowNumer;//cell row in table view for delete
@property (nonatomic,strong) NSMutableArray * searchResults; //delete cards in search results table view


@end
