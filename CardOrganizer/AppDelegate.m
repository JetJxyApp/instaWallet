//
//  AppDelegate.m
//  CardOrganizer
//
//  Created by Jiang on 2014-09-22.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import "AppDelegate.h"
#import "AllCardsTableViewController.h"
#import "CustomTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    /////////////////////FIX ME///////////////////////////////
    delegate.delegateMutableArray = [[NSMutableArray alloc]init];
    // Override point for customization after application launch.
    
    
    //set carrier, clock, battary to white
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    
    return YES;
     
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *path = [documentsPath stringByAppendingPathComponent:@"Alldata.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        [dataArray addObject:self.Alldata];
        [dataArray writeToFile:path atomically:YES];
        
    }
    else
    {
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        [dataArray addObject:self.Alldata];
        [dataArray writeToFile:path atomically:YES];
        NSLog(@"find path to save all info when in background APP");

    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //I want to save the NSMustable Array, which store all cards info
    //for future use when relaunch APP
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *path = [documentsPath stringByAppendingPathComponent:@"Alldata.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        [dataArray addObject:self.Alldata];
        [dataArray writeToFile:path atomically:YES];
        

    }
    else
    {
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        [dataArray addObject:self.Alldata];
        [dataArray writeToFile:path atomically:YES];
        NSLog(@"find path to save all info when terminating APP");

    }
}

@end
