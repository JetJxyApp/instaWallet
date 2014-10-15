//
//  EditCardViewController.h
//  CardOrganizer
//
//  Created by Jiang on 2014-10-14.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCardViewController : UIViewController

@property(nonatomic, strong) NSMutableArray * cardPath;//for receiving file path when entering edit card veiw controller
@property(nonatomic, strong) NSMutableArray *cardFilePathArray;//for stroing new edit card info when user press save button

@end
