//
//  CustomTabBarController.m
//  CardOrganizer
//
//  Created by Jiang on 2014-10-14.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     * below code change the image of selected or unselected controll bar item
     */
    UITabBarItem *folder = [self.tabBar.items objectAtIndex:0];
    folder.image = [UIImage imageNamed:@"folder-50.png"];
    folder.selectedImage = [UIImage imageNamed:@"folder_filled-50.png"];
    //[folder setImage: [[UIImage imageNamed:@"folder-50.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
    /*
    [folder setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIFont fontWithName:@"AmericanTypewriter" size:20.0f], UITextAttributeFont,
                                             [UIColor blackColor], UITextAttributeTextColor,
                                             [UIColor grayColor], UITextAttributeTextShadowColor,
                                             [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
                                             nil] forState:UIControlStateApplication];
     */
    
    /*
    UITabBarItem *scanner = [self.tabBar.items objectAtIndex:1];
    scanner.image = [UIImage imageNamed:@"barcode_scanner-50.png"];
    scanner.selectedImage = [UIImage imageNamed:@"idea_filled-50.png"];
    */
    
    UITabBarItem *settings = [self.tabBar.items objectAtIndex:1];
    settings.image = [UIImage imageNamed:@"settings-50.png"];
    settings.selectedImage = [UIImage imageNamed:@"settings_filled-50.png"];
    
    //paint the color for all tab bar item
    self.tabBar.tintColor = [UIColor colorWithRed:0.29 green:0.65 blue:0.96 alpha:1.0];
    
    //change the font of tab bar item
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:12.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    

}


-(UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender
{
    return [self.selectedViewController viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
}

@end
