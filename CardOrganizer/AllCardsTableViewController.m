//
//  AllCardsTableViewController.m
//  CardOrganizer
//
//  Created by Jiang on 2014-09-23.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import "AllCardsTableViewController.h"
#import "createNewCardViewController.h"
#import "CardInfoViewController.h"
#import "AppDelegate.h"
#import "UIImage_Thumbnail.h"
#import <QuartzCore/QuartzCore.h>

@interface AllCardsTableViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property NSInteger rowSwipeToDelete;
@property NSIndexPath *indexPathToDelete;
@end

@implementation AllCardsTableViewController

//refresh table view
- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    [self.refreshControl endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{

    //This pass data to App delegate for storing all card info when terminate our APP
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.Alldata = self.cards;
    
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    [delegate.delegateMutableArray removeAllObjects];

    for (NSMutableArray *card in self.cards)
    {
        [delegate.delegateMutableArray addObject:card];
        NSLog(@"card before path = %@", self.cards);
        NSLog(@"delegate before pass = %@", delegate.delegateMutableArray);
        
    }
    
    
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //This try to load our saved all card info from disk when relaunch our APP
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *path = [documentsPath stringByAppendingPathComponent:@"Alldata.plist"];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc]initWithContentsOfFile:path];
        self.cards = [tempArray objectAtIndex:0];
        
        //replace old path with new path
        for (NSMutableArray *array in self.cards)
        {
            NSString *newTextFilePath = [documentsPath stringByAppendingPathComponent:[[[array objectAtIndex:0]objectAtIndex:0] lastPathComponent]];
            NSString *newImageFilePath = [documentsPath stringByAppendingPathComponent:[[[array objectAtIndex:0]objectAtIndex:1] lastPathComponent]];

            
            [[array objectAtIndex:0] replaceObjectAtIndex:0 withObject:newTextFilePath];
            [[array objectAtIndex:0] replaceObjectAtIndex:1 withObject:newImageFilePath];
         

        }
        

    }
    
    //set initial row height in tableview, that 7 row in screen
    [self.tableView setRowHeight:80];
    



}

- (NSMutableArray *)cardPath
{
    if (!_cardPath) {
        _cardPath = [[NSMutableArray alloc]init];
    }
    return _cardPath;
}

//reconstruct table when go back

-(void)setcardPath:(NSMutableArray *)cardPath
{
    _cardPath = cardPath;
    [self.tableView reloadData];
}

-(NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

-(void)setcards:(NSMutableArray *)cards
{
    _cards = cards;
}


//pass the array which store all file path about a new card, including text and image file path
- (IBAction)createNewCardDone:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[createNewCardViewController class]]) {
        createNewCardViewController *cncVC = (createNewCardViewController *)segue.sourceViewController;
        self.cardPath = cncVC.cardFilePathArray;
        if (self.cardPath) {
            NSLog(@"success added card");
            [self.cards addObject:self.cardPath];
            NSLog(@"cards # = %ld", [self.cards count]);
            //log for card path store on disk
            for (NSString *str in self.cards) {
                if(str){
                    NSLog(@"after added new card str = %@", str);
                }
            }
            
        }else{
            NSLog(@"Failed to added new card");
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.cards count];
}

/*
//set the row height of cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  80;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Card Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
            
            //Information of Card name , card number
            NSString *cardTextPath = [[self.cards[indexPath.row] objectAtIndex:0] objectAtIndex:0];
            NSArray *data = [[NSArray alloc] initWithContentsOfFile:cardTextPath];
            cell.textLabel.text = [data objectAtIndex:0];
            cell.detailTextLabel.text = [data objectAtIndex:1];
            
            //Information of saved Iamge
            NSString *cardIamgePath = [[self.cards[indexPath.row] objectAtIndex:0] objectAtIndex:1];
            UIImage *cellImage = [UIImage imageWithContentsOfFile:cardIamgePath];
    
            //create thumbnail for card image and make rounded corner
            UIImage *thumbnail = [cellImage imageByScalingToSize:CGSizeMake(90, 60)];
            cell.imageView.layer.cornerRadius = 5;
            cell.imageView.clipsToBounds = YES;

            cell.imageView.image = thumbnail;


    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                        message:@"Do you really want to delete this card?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Delete card", nil];
        alert.tag = 0;
        [alert show];
        
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        self.rowSwipeToDelete = indexPath.row;
        self.indexPathToDelete = indexPath;
        
    }
}

-(NSString * )tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)prepareCardInfoViewController:(CardInfoViewController *)civc
                    toDisplayCardInfo:(NSMutableArray *)cardInfo
                         allCardsPath:(NSMutableArray *)cards
                             rowIndex:(NSInteger)rowIndex
{
    civc.cardPath = cardInfo;
    civc.rowNumer = rowIndex;
    civc.cards = cards;

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        // find out which row in which section we're seguing from
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            // found it ... are we doing the Display Photo segue?
            if ([segue.identifier isEqualToString:@"Display Card"]) {
                // yes ... is the destination an ImageViewController?
                if ([segue.destinationViewController isKindOfClass:[CardInfoViewController class]]) {
                    [self prepareCardInfoViewController:segue.destinationViewController
                                      toDisplayCardInfo:self.cards[indexPath.row]
                                           allCardsPath:self.cards
                                               rowIndex:indexPath.row];
                }
            }
        }
    }
    
}


//tableview swipe to delete
#pragma mark - Alerts
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    // Is this my Alert View?
    if (alertView.tag == 0) {
        //Yes
        
        
        // You need to compare 'buttonIndex' & 0 to other value(1,2,3) if u have more buttons.
        // Then u can check which button was pressed.
        if (buttonIndex == 0) {// 1st Other Button, that is cancel
            
            //[self alertView:alertView didDismissWithButtonIndex:buttonIndex];
            //AllCardsTableViewController *acTVC = [[AllCardsTableViewController alloc] init];
            //[self.navigationController popToRootViewControllerAnimated:YES];
            //[self.navigationController showViewController:AllcardsViewController sender:self];
            [self.tableView reloadData];
            
            
        }
        else if (buttonIndex == 1){// 2nd other button, that is delete card
            NSLog(@"ready to delete");
            // NSLog(@"delete card at row number = %ld", self.rowNumer);
            NSMutableArray * path = [self.cards objectAtIndex:self.rowSwipeToDelete];
            
            /*
             * delete text file and image file
             */
            NSString *textDataPathStr = [[path objectAtIndex:0] objectAtIndex:0];
            NSString *imageDataPathStr = [[path  objectAtIndex:0] objectAtIndex:1];
            
            NSError *error;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager isDeletableFileAtPath:textDataPathStr]) {
                BOOL fileDeleteSuccess = [[NSFileManager defaultManager] removeItemAtPath:textDataPathStr error:&error];
                if (!fileDeleteSuccess ) {
                    NSLog(@"Error removing text file at path: %@", error.localizedDescription);
                }
            }
            
            if ([fileManager isDeletableFileAtPath:imageDataPathStr]) {
                BOOL imageDeleteSuccess = [[NSFileManager defaultManager] removeItemAtPath:imageDataPathStr error:&error];
                if (!imageDeleteSuccess) {
                    NSLog(@"Error removing image file at path: %@", error.localizedDescription);
                }
            }
            
            
            //remove text file and image file pointer in NSMutableArray
            NSLog(@"Card to be delete file count in deletion = %ld", [[path objectAtIndex:0] count]);
            for (int i=0;i <[[path objectAtIndex:0] count]; i++)
            {
                [[path objectAtIndex:0] removeObjectAtIndex:i];
                i--;//here is for NSmutableArray because array shrink at every removeObjectAtIndex
                
            }
            
            
            [self.cards removeObjectAtIndex:self.rowSwipeToDelete];
            
            [self.tableView deleteRowsAtIndexPaths:@[self.indexPathToDelete] withRowAnimation:UITableViewRowAnimationAutomatic];

            
            //[self.tableView reloadData];
            
        }
        
        
    }
    else {
        //No
        // Other Alert View
        NSLog(@"did not properly enter alert view");
        
    }
}

@end
