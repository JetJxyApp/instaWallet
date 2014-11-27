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
@property (strong, nonatomic) IBOutlet UIView *hintToUser;
@property (strong, nonatomic) IBOutlet UILabel *hintLabel;
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
    if ([self.cards count] != 0) {
        
        [self.hintToUser setHidden:YES];

    }
    else if ([self.cards count] == 0)
    {
        [self.hintToUser setHidden:NO];

    }
    self.hintLabel.text = @"Welcome!\n          Tap + to create a new card      \u2191";

    

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
    
    
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    

    /*
     *  below deal with the color of back button of navigation contorller
     */
    //set back button color
   // [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    
    //change tableview background image
    /*
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"b1.png"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
     */
    
}

//This short methos is for the backgound color of cellview to be transparent
/*
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
 */

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
    [self.tableView setRowHeight:75];
    
    //change background color
    self.tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.93];
    
    //chage navigation controller color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.29 green:0.65 blue:0.96 alpha:1.0];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
    
    //move text lable of cell to right
    cell.indentationWidth = 55;
    cell.indentationLevel = 2;
    
    //make rounded corner
    cell.imageView.layer.cornerRadius = 5;
    cell.imageView.clipsToBounds = YES;
    
    //create thumbnail for card image and make rounded corner
    //UIImage *thumbnail = [cellImage imageByScalingToSize:CGSizeMake(81, 54)];
    //cell.imageView.contentMode = UIViewContentModeScaleAspectFill;


   //UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    
    UIImageView *thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 85.6, 54)];
    thumbnail.backgroundColor = [UIColor blackColor];
    thumbnail.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:thumbnail];
    
    //cell.imageView.frame = CGRectMake(100, 200, 80, 54);
    thumbnail.clipsToBounds = YES;
    thumbnail.layer.cornerRadius = 5;
    thumbnail.image = cellImage;

    
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //set the font of cell
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0];

    
    /*
     * Deal with cell separator line
     */
    // We have to use the borderColor/Width as opposed to just setting the
    // backgroundColor else the view becomes transparent and disappears during
    // the cell's selected/highlighted animation
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(20, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width+20, 0.6)];
    //separatorView.layer.borderColor = [UIColor blackColor].CGColor;
    separatorView.layer.borderWidth = 0.1;
    separatorView.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0];
    [cell.contentView addSubview:separatorView];

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

            
            [self viewWillAppear:YES];
        }
        
        
    }
    else {
        //No
        // Other Alert View
        NSLog(@"did not properly enter alert view");
        
    }
}

@end
