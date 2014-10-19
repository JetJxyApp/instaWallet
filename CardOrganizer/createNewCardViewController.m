//
//  createNewCardViewController.m
//  CardOrganizer
//
//  Created by Jiang on 2014-09-22.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import "createNewCardViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface createNewCardViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cardNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *barcodeNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *barcodeTypeTextField;
@property (strong, nonatomic) UIImage *image;
@property( nonatomic,strong) NSMutableArray * cardAllInfoArray;

@end

@implementation createNewCardViewController

#pragma mark - take photo

- (IBAction)takePhoto
{
    UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
    uiipc.delegate = self;
    uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
    uiipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    uiipc.allowsEditing = YES;
    [self presentViewController:uiipc animated:YES completion:NULL];
}

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

//function of barcode Scanner




//deal with keyboard go away
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)setImage:(UIImage *)image
{
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
    
    //just temporary image for testing
    self.image = [UIImage imageNamed:@"pic.jpg"];
    

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
        NSString *textDataPathStr = [[self class] cardInfoFilePath:self.cardNameTextField.text
                                                        cardNumber:self.cardNumberTextField.text
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
        NSString *imageDataPathStr = [[self class] cardInfoFilePath:self.cardNameTextField.text
                                                         cardNumber:self.cardNumberTextField.text
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
                NSLog(@"str = %@", str);
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
