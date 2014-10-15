//
//  EditCardViewController.m
//  CardOrganizer
//
//  Created by Jiang on 2014-10-14.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import "EditCardViewController.h"

@interface EditCardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cardNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *barcodeNumberTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property( nonatomic,strong) NSMutableArray * cardAllInfoArray;

@end

@implementation EditCardViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //Display all card info for editing
    NSString *textDataPathStr = [[self.cardPath objectAtIndex:0] objectAtIndex:0];
    NSString *imageDataPathStr = [[self.cardPath  objectAtIndex:0] objectAtIndex:1];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:textDataPathStr] || [fileManager fileExistsAtPath:imageDataPathStr]) {
        
        
        NSArray *data = [[NSArray alloc] initWithContentsOfFile:textDataPathStr];
        
        self.cardNameTextField.text = [data objectAtIndex:0];
        self.cardNumberTextField.text = [data objectAtIndex:1];
        
        UIImage *customImage = [UIImage imageWithContentsOfFile:imageDataPathStr];
        self.imageView.image = customImage;
        
        
    }else{
        NSLog(@"Did not found corresponding file");
    }
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
        
        if ([fileManager fileExistsAtPath:textDataPathStr] || [fileManager fileExistsAtPath:imageDataPathStr])
        {
            /*
             *store card text field
             */
            NSMutableArray *data = [[NSMutableArray alloc]init];
            [data addObject:self.cardNameTextField.text];
            [data addObject:self.cardNumberTextField.text];
            
            [data writeToFile:textDataPathStr atomically:YES];
            [self addFilePath:textDataPathStr];
            NSLog(@"successful edit card text info path = %@", textDataPathStr);

            /*
             *store image
             */
            NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
            [imageData writeToFile:imageDataPathStr atomically:YES];
            [self addFilePath:imageDataPathStr];
            NSLog(@"successful edit image data path = %@", imageDataPathStr);
            
            //collect card all info and put in one array
            [self.cardFilePathArray addObject:self.cardAllInfoArray];
            
        }else
        {
            NSLog(@"Did not found corresponding file in Edit Card View Controller");
        }
    }
    else{
        NSLog(@"Does not entery prepare segue in Edit card");
    }
}

//add card all related info to an array
-(void)addFilePath:(NSString *)pathString
{
    [self.cardAllInfoArray addObject:pathString];
}

@end
