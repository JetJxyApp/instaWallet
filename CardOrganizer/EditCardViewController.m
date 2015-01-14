//
//  EditCardViewController.m
//  CardOrganizer
//
//  Created by Jiang on 2014-10-14.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import "EditCardViewController.h"
#import "AllCardsTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImage_Thumbnail.h"
#import "GKImagePicker.h"
#import "PECropViewController.h"


@interface EditCardViewController () <UITextFieldDelegate,UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,GKImagePickerDelegate,GKImagePickerDelegate,UIActionSheetDelegate, PECropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cardNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *barcodeNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *barcodeTypeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property( nonatomic,strong) NSMutableArray * cardAllInfoArray;

@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

@end

@implementation EditCardViewController

@synthesize popoverController;
@synthesize imagePicker;

- (void)setImage:(UIImage *)image
{
    
    self.imageView.image = image;
}

-(UIImage *)image
{
    return self.imageView.image;
}

- (void)setcardPath:(NSMutableArray *)cardPath
{
    _cardPath = cardPath;
}

-(NSMutableArray *)cardPath
{
    if (!_cardPath) {
        _cardPath = [[NSMutableArray alloc]init];
    }
    return _cardPath;
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

-(NSMutableArray *)searchResults
{
    if (!_searchResults) {
        _searchResults = [[NSMutableArray alloc]init];
    }
    return _searchResults;
}

//take new poto for card

- (void)takePhoto:(UITapGestureRecognizer *)recognizer
{
        
    /*
     
     This is apple builid-in image picker
     UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
     uiipc.delegate = self;
     uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
     uiipc.sourceType = UIImagePickerControllerSourceTypeCamera;
     uiipc.allowsEditing = YES;
     [self presentViewController:uiipc animated:YES completion:NULL];
     */
    
    /*
     
     This is old third party image editor
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(250, 150);
    self.imagePicker.delegate = self;
    self.imagePicker.resizeableCropArea = YES;
    
    
    
    // [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:NULL];
     */
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Photo Album", nil), nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Camera", nil)];
    }
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    
    
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

#pragma mark - PECropViewControllerDelegate methods


- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    self.imageView.image = croppedImage;
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIActionSheetDelegate methods

/*
 Open camera or photo album.
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Photo Album", nil)]) {
        [self openPhotoAlbum];
    } else if ([buttonTitle isEqualToString:NSLocalizedString(@"Camera", nil)]) {
        [self showCamera];
        
        
    }
}

#pragma mark - Private methods

- (void)showCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    [self presentViewController:controller animated:YES completion:NULL];
    
}

- (void)openPhotoAlbum
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    [self presentViewController:controller animated:YES completion:NULL];
    
}

#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:^{[self openEditor];}];
    
}

#pragma mark - Action methods

- (void)openEditor
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = self.imageView.image;
    
    UIImage *image = self.imageView.image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}
/*
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    
    self.image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}
 */

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

/*
- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    self.imageView.image = image;
    [self hideImagePicker];
}

- (void)hideImagePicker{
    
    
    [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    
}
*/



-(void)viewWillAppear:(BOOL)animated
{
    
    //deal with the issue that statu bar disappear when user finish taking/editing image and pop back
    //to previous view controller
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.barcodeTypeTextField setHidden:YES];

    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    //resign or remove keyboard when user press scan barcode button
    //fix the bug of textfield move up/down
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yourNotificationHandler:)
                                                 name:@"ScanBarcode Dismiss" object:nil];
    

    //Display all card info for editing
    NSString *textDataPathStr = [[self.cardPath objectAtIndex:0] objectAtIndex:0];
    NSString *imageDataPathStr = [[self.cardPath  objectAtIndex:0] objectAtIndex:1];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:textDataPathStr] || [fileManager fileExistsAtPath:imageDataPathStr]) {
        
        
        NSArray *data = [[NSArray alloc] initWithContentsOfFile:textDataPathStr];
        
        self.cardNameTextField.text = [data objectAtIndex:0];
        self.cardNumberTextField.text = [data objectAtIndex:1];
        self.barcodeNumberTextField.text = [data objectAtIndex:2];
        self.barcodeTypeTextField.text = [data objectAtIndex:3];
        
        UIImage *customImage = [UIImage imageWithContentsOfFile:imageDataPathStr];
        self.imageView.layer.cornerRadius = 5;
        self.imageView.clipsToBounds = YES;
        self.imageView.image = customImage;
        
        
    }else{
        NSLog(@"Did not found corresponding file");
    }
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(takePhoto:)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:singleFingerTap];
}

// --> Now create method in parent class as;
// Now create yourNotificationHandler: like this in parent class
-(void)yourNotificationHandler:(NSNotification *)notice
{
    
    NSString *barcodeNumber = [[notice object] objectAtIndex:0];
    NSString *barcodeType = [[notice object] objectAtIndex:1];
    
    NSLog(@"Inside parent view!!!!!!!!!!!!!\n%@ \n %@", barcodeNumber, barcodeType);
    //pass the scaned value into barcode text field
    self.barcodeNumberTextField.text = barcodeNumber;
    self.barcodeTypeTextField.text = barcodeType;
}

//modal view cancel button
- (IBAction)cancel
{
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}





#pragma mark - Navigation

#define UNWIND_SEGUE_IDENTIFIER_EDIT_CARD @"Do edit card"

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER_EDIT_CARD])
    {
        NSLog(@"enger segue in edit card");
        //Display all card info for editing
        NSString *textDataPathStr = [[self.cardPath objectAtIndex:0] objectAtIndex:0];
        NSString *imageDataPathStr = [[self.cardPath  objectAtIndex:0] objectAtIndex:1];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        /*
         * change the old path name with new path name
         */
        NSLog(@"in edite card, textDataPathStr = %@", textDataPathStr);

        
        //append new date
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM,dd,yyyy HH:mm:ss"];
        NSDate *now = [NSDate date];
        NSString *nsstr = [format stringFromDate:now];
        
        //last component of  new file path
        NSString *lastComponentNewTextPath = [[self.cardNameTextField.text stringByAppendingString:nsstr] stringByAppendingString:@".plist"];
        NSString *lastComponentNewImagePath = [[self.cardNameTextField.text stringByAppendingString:nsstr] stringByAppendingString:@".jpeg"];
        
        NSString *newTextPath = [[textDataPathStr stringByDeletingLastPathComponent] stringByAppendingPathComponent:lastComponentNewTextPath];
        NSString *newImagePath = [[imageDataPathStr stringByDeletingLastPathComponent] stringByAppendingPathComponent:lastComponentNewImagePath];

        NSError *error = nil;
        [[NSFileManager defaultManager] moveItemAtPath:textDataPathStr toPath:newTextPath error:&error];
        [[NSFileManager defaultManager] moveItemAtPath:imageDataPathStr toPath:newImagePath error:&error];

        
        if ([fileManager fileExistsAtPath:newTextPath] || [fileManager fileExistsAtPath:newImagePath])
        {
            /*
             *store card text field
             */
            NSMutableArray *data = [[NSMutableArray alloc]init];
            [data addObject:self.cardNameTextField.text];
            [data addObject:self.cardNumberTextField.text];
            [data addObject:self.barcodeNumberTextField.text];
            [data addObject:self.barcodeTypeTextField.text];
            
            [data writeToFile:newTextPath atomically:YES];
            //[self addFilePath:textDataPathStr];
            NSLog(@"successful edit card text info path = %@", newTextPath);

            /*
             *store image
             */
            NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
            [imageData writeToFile:newImagePath atomically:YES];
            //[self addFilePath:imageDataPathStr];
            NSLog(@"successful edit image data path = %@", newImagePath);
            
            /*
             *  code below is for replacing old file path to the new file path
             */
            [[self.cardPath objectAtIndex:0] removeAllObjects];
            [[self.cardPath objectAtIndex:0] addObject:newTextPath];
            [[self.cardPath objectAtIndex:0] addObject:newImagePath];
            
        }else
        {
            NSLog(@"Did not found corresponding file in Edit Card View Controller");
        }
    }
    else{
        NSLog(@"Does not entery prepare segue in Edit card");
    }
}


/*
//add card all related info to an array
-(void)addFilePath:(NSString *)pathString
{
    [self.cardAllInfoArray addObject:pathString];
}
*/

//deal with case that user want ot delete a card wand pop up a delete view
- (IBAction)deleteCard
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                    message:@"Do you really want to delete this card?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete card", nil];
    
    // Set the tag to alert unique among the other alerts.
    // So that you can find out later, which alert we are handling
    alert.tag = 0;
    [alert show];
}

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
            
        }
        else if (buttonIndex == 1){// 2nd other button, that is delete card
            NSLog(@"ready to delete");
            NSLog(@"delete card at row number = %ld", self.rowNumer);
            NSInteger indexDeleteInSearchResult = self.rowNumer;
            
            NSString *textDataPathStr = [[self.cardPath objectAtIndex:0] objectAtIndex:0];
            NSString *imageDataPathStr = [[self.cardPath  objectAtIndex:0] objectAtIndex:1];
            

            /*
             * determine the index in the cards to delete
             */
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
                        self.rowNumer = counter;
                    }
                    
                }
                counter ++;
            }
            
            /*
             * delete text file and image file
             */
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
            NSLog(@"Toal Card count in deletion = %ld", [[self.cardPath objectAtIndex:0] count]);
            for (int i=0;i <[[self.cardPath objectAtIndex:0] count]; i++)
            {
                    [[self.cardPath objectAtIndex:0] removeObjectAtIndex:i];
                    i--;//here is for NSmutableArray because array shrink at every removeObjectAtIndex

            }
            
            
            [self.cards removeObjectAtIndex:self.rowNumer];
            if ([self.searchResults count] != 0) {
                [self.searchResults removeObjectAtIndex:indexDeleteInSearchResult];
            }
            
            //log for card path store on disk
            /*for (NSString *str in self.cards) {
                if(str){
                    NSLog(@"remaining card info after delete card = %@", str);
                }
            }*/
            

            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }

        
    }
    else {
        //No
        // Other Alert View
        NSLog(@"did not properly enter alert view");
        
    }
}

/*//user press cancel button
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self cancel];
}*/

//alert view when user want to delete card

- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Delete Card"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Delete card", nil] show];
}


//deal with keyboard go away
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
 * Below deal with issue of keyboard cover textfield
 */

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 190; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
