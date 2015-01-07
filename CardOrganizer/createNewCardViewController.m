//
//  createNewCardViewController.m
//  CardOrganizer
//
//  Created by Jiang on 2014-09-22.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import "createNewCardViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImage_Thumbnail.h"
#import "GKImagePicker.h"
#import "PECropViewController.h"



@interface createNewCardViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,GKImagePickerDelegate,UIActionSheetDelegate, PECropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *cardNameTextField;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *barcodeNumberTextField;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *barcodeTypeTextField;
@property (strong, nonatomic) UIImage *image;
@property( nonatomic,strong) NSMutableArray * cardAllInfoArray;

@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;

@property UILabel *cardImageLabel1;
@property UILabel *cardImageLabel2;
@property UILabel *cardImageLabel3;

@end

@implementation createNewCardViewController

@synthesize popoverController;
@synthesize imagePicker;



#pragma mark - take photo

- (void)takePhoto:(UITapGestureRecognizer *)recognizer
{
    /*
     This is apple build-in image picker
     
    UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
    uiipc.delegate = self;
    uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
    uiipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    uiipc.allowsEditing = YES;
    [self presentViewController:uiipc animated:YES completion:NULL];
    */
    
    /*
     This is old card image editor
     
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
 * below is the old card image editor
 */
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

- (void)hideImagePicker
{

    [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
 
}
*/
# pragma mark -
# pragma mark UIImagePickerDelegate Methods
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    self.imageView.image = image;
 
    [picker dismissViewControllerAnimated:YES completion:nil];
 
}

*/





//deal with keyboard go away
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)setImage:(UIImage *)image
{
    self.imageView.layer.cornerRadius = 10;
    self.imageView.clipsToBounds = YES;
    self.imageView.image = image;
}

-(UIImage *)image
{
    return self.imageView.image;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // get register to fetch notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yourNotificationHandler:)
                                                 name:@"ScanBarcode Dismiss" object:nil];
    
    //set initial card imageView
    //self.image = [UIImage imageNamed:@"your_card.png"];
    self.image = nil;
    [self.imageView.layer setBorderColor: [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0] CGColor]];
    [self.imageView.layer setBorderWidth: 0.5];
    self.imageView.layer.cornerRadius = 10;

    
    
    /*
     *  Make the card image view tappable when user create new card
     */
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(takePhoto:)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:singleFingerTap];

    /*
     *  Add label to card initial image to hint user take photo
     */
    self.cardImageLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [self.cardImageLabel1 setText: @"Card"];
    [self.cardImageLabel1 setTextColor: [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
    [self.cardImageLabel1 setFont:[UIFont fontWithName:@"Helvetica-Light" size:40.0]];
    self.cardImageLabel1.center = CGPointMake(self.imageView.frame.size.width/2.0, self.imageView.bounds.size.height/2.0 - 30.0);
    self.cardImageLabel1.textAlignment = NSTextAlignmentCenter;
    self.cardImageLabel1.numberOfLines = 0;
    [self.imageView addSubview: self.cardImageLabel1];
    
    self.cardImageLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [self.cardImageLabel2 setText: @"Take photo"];
    [self.cardImageLabel2 setTextColor: [UIColor colorWithRed:0.29 green:0.65 blue:0.96 alpha:1.0]];
    [self.cardImageLabel2 setFont:[UIFont fontWithName:@"Helvetica-Light" size:20.0]];
    self.cardImageLabel2.center = CGPointMake(self.imageView.frame.size.width/2.0, self.imageView.bounds.size.height/2.0 + 50.0);
    self.cardImageLabel2.textAlignment = NSTextAlignmentCenter;
    self.cardImageLabel2.numberOfLines = 0;
    [self.imageView addSubview: self.cardImageLabel2];
    
    self.cardImageLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [self.cardImageLabel3 setText: @"0123 456 789"];
    [self.cardImageLabel3 setTextColor: [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
    [self.cardImageLabel3 setFont:[UIFont fontWithName:@"Helvetica-Light" size:20.0]];
    self.cardImageLabel3.center = CGPointMake(self.imageView.frame.size.width/2.0, self.imageView.bounds.size.height/2.0 + 20.0);
    self.cardImageLabel3.textAlignment = NSTextAlignmentCenter;
    self.cardImageLabel3.numberOfLines = 0;
    [self.imageView addSubview: self.cardImageLabel3];
    
    //self.cardNameTextField.layer.borderColor=[[UIColor clearColor] CGColor];
    //self.cardNameTextField.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    //[self.cardNameTextField setBorderStyle:UITextBorderStyleNone];
    //[self.cardNumberTextField setBorderStyle:UITextBorderStyleNone];
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    //resign or remove keyboard when user press scan barcode button
    //fix the bug of textfield move up/down
    [self.view endEditing:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{

    self.cardNameTextField.placeholder = NSLocalizedString(@"Required",);
    self.cardNumberTextField.placeholder = NSLocalizedString(@"Optional",);
    self.barcodeNumberTextField.placeholder = NSLocalizedString(@"Optional - Please Scan ->",);
    //self.barcodeTypeTextField.placeholder = NSLocalizedString(@"Required - Please Scan",);
    
    [self.barcodeTypeTextField setHidden:YES];
    
    //deal with the issue that statu bar disappear when user finish taking/editing image and pop back
    //to previous view controller
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    //show the bottom tabbar controller
    self.tabBarController.tabBar.hidden = NO ;
    
    if (self.imageView.image != nil) {
        [self.cardImageLabel1 setHidden:YES];
        [self.cardImageLabel2 setHidden:YES];
        [self.cardImageLabel3 setHidden:YES];
        [self.imageView.layer setBorderColor: [[UIColor clearColor] CGColor]];
        self.imageView.layer.cornerRadius = 10;
        
    }
    
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



#pragma mark - Navigation

#define UNWIND_SEGUE_IDENTIFIER @"Do create new card"

//store card Info
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER])
    {
        /*
         *store card text field
         */
        
        //Below snippet used for differentiate duplicated/same card name
        //I use specific date/time to distinguish card with same name
        //the same method applied for card image file path
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM,dd,yyyy HH:mm:ss"];
        NSDate *now = [NSDate date];
        NSString *nsstr = [format stringFromDate:now];

        NSString *textDataPathStr = [[self class] cardInfoFilePath:self.cardNameTextField.text
                                                        cardNumber:nsstr
                                                        imageOrNot:NO];
        if (textDataPathStr == nil)
        {
            NSLog(@"no textDataPathStr");
        }else
        {
            
            NSMutableArray *data = [[NSMutableArray alloc]init];
            [data addObject:self.cardNameTextField.text];
            [data addObject:self.cardNumberTextField.text];
            [data addObject:self.barcodeNumberTextField.text];
            [data addObject:self.barcodeTypeTextField.text];

            [data writeToFile:textDataPathStr atomically:YES];
            [self addFilePath:textDataPathStr];
            NSLog(@"successful save card text info path = %@", textDataPathStr);
        }
        
        
        /*
         *store image
         */
        if (self.imageView.image == nil) {
            self.imageView.image = [UIImage imageNamed:@"your_card.png"];
        }
        
        NSString *imageDataPathStr = [[self class] cardInfoFilePath:self.cardNameTextField.text
                                                         cardNumber:nsstr
                                                         imageOrNot:YES];
        if (imageDataPathStr == nil) {
            NSLog(@"no imageDataPrthStr");
        }
        else
        {
            NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
            [imageData writeToFile:imageDataPathStr atomically:YES];
            [self addFilePath:imageDataPathStr];
            NSLog(@"successful store image data path = %@", imageDataPathStr);

        }
        
        //collect card all info and put in one array
        [self.cardFilePathArray addObject:self.cardAllInfoArray];
        
        //log for card path store on disk
        for (NSString *str in self.cardFilePathArray) {
            if(str){
                NSLog(@"log for store path on disk = %@", str);
            }
        }
       
    }
}

+ (NSString *)cardInfoFilePath:(NSString *)cardName cardNumber:(NSString *)cardNumber imageOrNot:(BOOL)isImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *name = cardName;
    NSString *number = cardNumber;
    NSString *cardInfo = [name stringByAppendingString:number];
    
    NSString *fileFullPath = nil;
    
    NSLog(@"cardInfo = %@", cardInfo);
    if (!isImage) {
        fileFullPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", cardInfo]];
    }
    else{
        fileFullPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg", cardInfo]];

    }
    
    return fileFullPath;
}


-(NSMutableArray *)cardFilePathArray
{
    if (!_cardFilePathArray) {
        _cardFilePathArray  = [[NSMutableArray alloc]init];
    }
    return _cardFilePathArray;
}


-(NSMutableArray *)cardAllInfoArray
{
    if (!_cardAllInfoArray) {
        _cardAllInfoArray = [[NSMutableArray alloc]init];
    }
    return _cardAllInfoArray;
}

//add card all related info to an array
-(void)addFilePath:(NSString *)pathString
{
    [self.cardAllInfoArray addObject:pathString];
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
    const int movementDistance = 110; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


//alert view to alert any missing field
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    /*
    if([identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER]){
        
        if(!self.image){
            [self alert:@"No photo taken!"];
            return NO;
        }else if(![self.cardNameTextField.text length]){
            [self alert:@"No Card Name!"];
            return NO;
        }else if (![self.cardNumberTextField.text length]){
            [self alert:@"NO Card Number!"];
             return NO;
        }else{
            return YES;
        }
    }else{
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }*/
    
    if([identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER]){
        
        if(![self.cardNameTextField.text length]){
            [self alert:@"Please enter Card Name!"];
            return NO;
        }
        else{
            return YES;
        }
    }else{
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}


-(void)alert:(NSString *)msg
{
    [[[UIAlertView alloc]initWithTitle:@"Create New Card"
                               message:msg
                              delegate:nil
                     cancelButtonTitle:Nil
                     otherButtonTitles:@"OK", nil] show];
}




@end
