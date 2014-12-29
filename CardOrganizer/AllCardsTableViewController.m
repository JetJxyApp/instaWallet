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
#import "CardTableViewCell.h"

@interface AllCardsTableViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property (strong, nonatomic) IBOutlet UIView *hintToUser;
@property (strong, nonatomic) IBOutlet UILabel *hintLabel;
@property UIView *hintView;
@property UILabel *label;
@property NSInteger rowSwipeToDelete;
@property NSIndexPath *indexPathToDelete;
@property NSInteger searchToDelete;
@property NSInteger cancelPressedSearchBar; //determine is cancel button of search bar pressed for showing of hint bar
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
        
       // [self.hintToUser setHidden:YES];
        //[self.searchDisplayController.searchBar setHidden:NO];
        //[self.searchDisplayController.searchBar setFrame:CGRectMake(0, 0, 320, 44)];
        
        [self.searchDisplayController.searchBar setHidden:NO];
        [self.hintView setHidden:YES];
        

    }
    else if ([self.cards count] == 0 && self.cancelPressedSearchBar == 1)
    {
        //[self.hintToUser setHidden:NO];
        //[self.searchDisplayController.searchBar setHidden:YES];
        //[self.searchDisplayController.searchBar setFrame:CGRectMake(0, 0, 320, 0)];
        

        
        //hide the search bar
        [self.searchDisplayController.searchBar setHidden:YES];
        [self.hintView setHidden:NO];
        

        
        
        /*
         * below snipped is the animation of hint bar
         */
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.5f];
        //self.hintView.frame = CGRectOffset(self.hintView.frame, 0, -50);
        //[UIView commitAnimations];
        

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
        //NSLog(@"card before path = %@", self.cards);
        //NSLog(@"delegate before pass = %@", delegate.delegateMutableArray);
        
    }
    
    //print out all cards info
    for (NSString *str in self.cards) {
        if(str){
            NSLog(@"In all cards table view, display all cards path= %@", str);
        }
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.searchDisplayController.searchResultsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

    

    /*
     *  below deal with the color of back button of navigation contorller
     */
    //set back button color
   // [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    

    
    
    
    //change tableview background image
    /*
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"b1.png"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
     */
    
    //dismiss search bar result
    //[self.searchDisplayController setActive:NO animated:NO];
    
    /*
     *  save the path to all cards, in the case of the app did not enter background or terminated
     */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *path = [documentsPath stringByAppendingPathComponent:@"Alldata.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        [dataArray addObject:self.cards];
        [dataArray writeToFile:path atomically:YES];
        
        
    }
    else
    {
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        [dataArray addObject:self.cards];
        [dataArray writeToFile:path atomically:YES];
        NSLog(@"find path to save all info in viewWillAppear of AllcardTableViewController");
        
    }
    
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
        
        /*
         * Replace old path with new path, bacause the file path change each time when app reopen
         * So need to replace the old path to the new path
         */
        for (NSMutableArray *array in self.cards)
        {
            NSString *newTextFilePath = [documentsPath stringByAppendingPathComponent:[[[array objectAtIndex:0]objectAtIndex:0] lastPathComponent]];
            NSString *newImageFilePath = [documentsPath stringByAppendingPathComponent:[[[array objectAtIndex:0]objectAtIndex:1] lastPathComponent]];

            
            [[array objectAtIndex:0] replaceObjectAtIndex:0 withObject:newTextFilePath];
            [[array objectAtIndex:0] replaceObjectAtIndex:1 withObject:newImageFilePath];
         

        }
        

    }
    
    //set initial row height in tableview, that 7 row in screen
    //[self.tableView setRowHeight:75];
    
    //change background color
    //self.tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.93];
    
    //chage navigation controller color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.29 green:0.65 blue:0.96 alpha:1.0];
    
    //set navigation bar back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //tableview cell long press gesture
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    
    //init search results
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.cards count]];
    
    
    /*
     *  code below deal with the welcom/hint uiview to user
     */
    CGRect bounds = CGRectMake( 0, 0, self.view.frame.size.width, 115 );
    self.hintView = [[UIView alloc] initWithFrame: bounds];
    [self.hintView setBackgroundColor:  [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.2]];
    [self.view addSubview: self.hintView];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [self.label setText: @"Welcome!\n Tap + to create a new card \u2191"];
    [self.label setTextColor: [UIColor colorWithRed:0.29 green:0.53 blue:0.91 alpha:1.0]];
    [self.label setFont:[UIFont fontWithName:@"Chalkduster" size:18.0]];
    self.label.center = CGPointMake(self.view.frame.size.width/2.0, self.hintView.bounds.size.height/2.0);
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 0;
    [self.hintView addSubview: self.label];
    
    //hidder the search bar when first load the app
    [self.searchDisplayController.searchBar setHidden:YES];

    
    
    /*
     * code below deal with the button color of create new card
     * The new change is that creating custem button, ctrl + drag from instaWallet of storyboard to create, and perform segue
     * I overide the old Add button that ctrl + drag, selet push
     */
    /*
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(createCard:)];
    
    
    [addButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = addButton;
     */
    
    /*
     *  Make the hint bar tappable when user first time open our app to create new card
     */
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.hintView addGestureRecognizer:singleFingerTap];
    
    
}
//user tap the hint view to create new card
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [self performSegueWithIdentifier:@"create" sender:self];
}
//custom create new card button, and perfrom push
- (void)createCard:(id)sender
{
    [self performSegueWithIdentifier:@"create" sender:self];
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
            /*for (NSString *str in self.cards) {
                if(str){
                    NSLog(@"after added new card str = %@", str);
                }
            }*/
            
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
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        //return the number of search result in tableview
        return [self.searchResults count];
    }
    else{
        // Return the number of rows in the section.
        return [self.cards count];
    }

}


//set the row height of cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"Card Cell";
    
    //change this due to search function
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
    //                                                        forIndexPath:indexPath];
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CardTableViewCell *cell =(CardTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[CardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImage *cellImage = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        //Information of Card name , card number
        NSString *cardTextPath = [[[self.searchResults objectAtIndex:indexPath.row] objectAtIndex:0] objectAtIndex:0];
        NSArray *data = [[NSArray alloc] initWithContentsOfFile:cardTextPath];
        cell.cardNameLable.text = [data objectAtIndex:0];
        //cell.detailTextLabel.text = [data objectAtIndex:1];
        
        //Information of saved Iamge
        NSString *cardIamgePath = [[[self.searchResults objectAtIndex:indexPath.row] objectAtIndex:0] objectAtIndex:1];
        cellImage = [UIImage imageWithContentsOfFile:cardIamgePath];
        
        self.cancelPressedSearchBar = 0;
    }
    else{
        //Information of Card name , card number
        NSString *cardTextPath = [[self.cards[indexPath.row] objectAtIndex:0] objectAtIndex:0];
        NSArray *data = [[NSArray alloc] initWithContentsOfFile:cardTextPath];
        cell.cardNameLable.text = [data objectAtIndex:0];
        //cell.detailTextLabel.text = [data objectAtIndex:1];
        
        //Information of saved Iamge
        NSString *cardIamgePath = [[self.cards[indexPath.row] objectAtIndex:0] objectAtIndex:1];
        cellImage = [UIImage imageWithContentsOfFile:cardIamgePath];
        
        self.cancelPressedSearchBar = 1;

    }

    
    //move text lable of cell to right
    //cell.indentationWidth = 55;
    //cell.indentationLevel = 2;
    
    //make rounded corner
    cell.thumbnailImageView.layer.cornerRadius = 5;
    cell.thumbnailImageView.clipsToBounds = YES;
    
    //create thumbnail for card image and make rounded corner
    //UIImage *thumbnail = [cellImage imageByScalingToSize:CGSizeMake(81, 54)];
    //cell.imageView.image = cellImage;
    //cell.imageView.contentMode = UIViewContentModeScaleAspectFill;

    /*
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.contentMode = UIViewContentModeScaleAspectFill;
    recipeImageView.clipsToBounds = YES;
    recipeImageView.layer.cornerRadius = 5;
    recipeImageView.image = cellImage;
     */
    cell.thumbnailImageView.image = cellImage;
    
    /*
    UIImageView *thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 85.6, 54)];
    thumbnail.backgroundColor = [UIColor blackColor];
    thumbnail.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:thumbnail];
    
    //cell.imageView.frame = CGRectMake(100, 200, 80, 54);
    thumbnail.clipsToBounds = YES;
    thumbnail.layer.cornerRadius = 5;
    thumbnail.image = cellImage;
    */

    
    
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor =[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0];
    
    //set the font of cell
    cell.cardNameLable.font = [UIFont fontWithName:@"Helvetica-Light" size:18.0];
    //cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0];

    
    /*
     * Deal with cell separator line
     */
    // We have to use the borderColor/Width as opposed to just setting the
    // backgroundColor else the view becomes transparent and disappears during
    // the cell's selected/highlighted animation
    
    /*
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(20, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width+20, 0.6)];
    //separatorView.layer.borderColor = [UIColor blackColor].CGColor;
    separatorView.layer.borderWidth = 0.1;
    separatorView.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0];
    [cell.contentView addSubview:separatorView];
     */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            /*
             * determine the index in the cards to delete
             */
            NSString *textDataPathStr = [[self.searchResults[indexPath.row] objectAtIndex:0]objectAtIndex:0];
            NSString *searchText =  [[textDataPathStr lastPathComponent]stringByDeletingPathExtension];
            NSLog(@"searchText = %@", searchText);
            
            NSInteger counter = 0;
            for (NSArray *ary1 in self.cards) {
                //extract one card from all cards
                for (NSArray *ary2 in ary1) {
                    //extract file and image path from this specific card
                    //NSLog(@"last component %@", [[[ary2 objectAtIndex:0] lastPathComponent]stringByDeletingPathExtension]);
                    NSString * fileName =[[[ary2 objectAtIndex:0] lastPathComponent]stringByDeletingPathExtension];//enough only search file name, b/c image name the same
                    NSLog(@"looping file name = %@", fileName);
                    if ([fileName isEqualToString:searchText]) {
                        //this means found a matched filename
                        NSLog(@"Find matched file!!!");
                        self.rowSwipeToDelete = counter;
                        
                    }
                    
                }
                counter ++;
            }
            self.searchToDelete = indexPath.row;//delete the cell just deleted in search table view

        }
        else
        {
            //remove the deleted object from your data source.
            //If your data source is an NSMutableArray, do this
            self.rowSwipeToDelete = indexPath.row;
            self.indexPathToDelete = indexPath;

            
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                        message:@"Do you really want to delete this card?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Delete card", nil];
        alert.tag = 0;
        [alert show];

        
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
                        searchResults:(NSMutableArray *)searchResults
                             rowIndex:(NSInteger)rowIndex
{
    civc.cardPath = cardInfo;
    civc.rowNumer = rowIndex;
    civc.cards = cards;
    civc.searchResults = searchResults;

}

#pragma Search Methods

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.searchResults removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchText];
    
    for (NSArray *ary1 in self.cards) {
        //extract one card from all cards
        for (NSArray *ary2 in ary1) {
            //extract file and image path from this specific card
            NSLog(@"last component %@", [[[ary2 objectAtIndex:0] lastPathComponent]stringByDeletingPathExtension]);
            NSString * fileName =[[[ary2 objectAtIndex:0] lastPathComponent]stringByDeletingPathExtension];//enough only search file name, b/c image name the same
            NSArray *arryForSearch = [[NSArray alloc] initWithObjects:fileName, nil];//must construct array for filter
            NSLog(@"arryForSearch %@", arryForSearch);
            
            NSArray *match = [arryForSearch filteredArrayUsingPredicate:predicate];
            NSLog(@" match result = %@", match);
            if ([match count] != 0) {
                //this means found a matched filename
                [self.searchResults addObject:ary1];
                NSLog(@"search result array = %@", self.searchResults);
            }

        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString.length > 0) {
        [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    }

    return YES;
}

//clear all search results in seart table view when user press cancel button of search bar
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchResults removeAllObjects];
    self.cancelPressedSearchBar = 1;
    [self viewWillAppear:YES];
}


#pragma mark - Navigation
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to candy detail
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"Display Card" sender:tableView];
    }
}*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
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
    */
    
    if ([segue.identifier isEqualToString:@"Display Card"]) {

        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath)
        {
            
            if ([segue.destinationViewController isKindOfClass:[CardInfoViewController class]]) {
                NSLog(@"index path %ld", (long)indexPath.row);
                [self prepareCardInfoViewController:segue.destinationViewController
                                  toDisplayCardInfo:self.cards[indexPath.row]
                                       allCardsPath:self.cards
                                      searchResults:nil
                                           rowIndex:indexPath.row];
            }
            
        }
        else//search table view
        {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            if (indexPath)
            {
                if ([segue.destinationViewController isKindOfClass:[CardInfoViewController class]]) {
                    NSLog(@"index path %ld", indexPath.row);
                    NSLog(@"search result %@", self.searchResults);

                    [self prepareCardInfoViewController:segue.destinationViewController
                                      toDisplayCardInfo:self.searchResults[indexPath.row]
                                           allCardsPath:self.cards
                                          searchResults:self.searchResults
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
            [self.searchDisplayController.searchResultsTableView reloadData];
            
            
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
            //[self.tableView deleteRowsAtIndexPaths:@[self.indexPathToDelete] withRowAnimation:UITableViewRowAnimationAutomatic];
            if ([self.searchResults count] != 0) {
                [self.searchResults removeObjectAtIndex:self.searchToDelete];
            }
            
            
            [self viewWillAppear:YES];
        }
        
        
    }
    else {
        //No
        // Other Alert View
        NSLog(@"did not properly enter alert view");
        
    }
}


- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.0 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.cards exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.0 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end
