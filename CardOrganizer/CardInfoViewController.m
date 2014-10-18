//
//  CardInfoViewController.m
//  CardOrganizer
//
//  Created by Jiang on 2014-09-23.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import "CardInfoViewController.h"
#import "createNewCardViewController.h"
#import "EditCardViewController.h"
#import "AllCardsTableViewController.h"
#import "ZXBitMatrix.h"
#import "ZXMultiFormatWriter.h"
#import "ZXImage.h"
#import "ZXUPCAWriter.h"
#import "ZXBarcodeFormat.h"


@interface CardInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *cardNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *barcodeNumberTextField;
@property (weak, nonatomic) IBOutlet UIImageView *barcodeImageView;
//@property (strong,nonatomic)UIImage *image;

@end

@implementation CardInfoViewController



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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    
    NSLog(@"row number in eidit = %ld", self.rowNumer);
    
    NSString *textDataPathStr = [[self.cardPath objectAtIndex:0] objectAtIndex:0];
    NSString *imageDataPathStr = [[self.cardPath  objectAtIndex:0] objectAtIndex:1];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:textDataPathStr] || [fileManager fileExistsAtPath:imageDataPathStr]) {

        
        NSArray *data = [[NSArray alloc] initWithContentsOfFile:textDataPathStr];
        
        self.cardNameTextField.text = [data objectAtIndex:0];
        self.cardNumberTextField.text = [data objectAtIndex:1];
        self.barcodeNumberTextField.text = [data objectAtIndex:2];
        
        UIImage *customImage = [UIImage imageWithContentsOfFile:imageDataPathStr];
        self.imageView.image = customImage;
        
        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
        ZXBitMatrix *result = [writer encode:@"841015928480"
                                      format:kBarcodeFormatUPCA
                                       width:self.barcodeImageView.frame.size.width
                                      height:self.barcodeImageView.frame.size.width
                                       error:nil];
        if (result) {
            ZXImage *image = [ZXImage imageWithMatrix:result];
            self.barcodeImageView.image = [UIImage imageWithCGImage:image.cgimage];
        } else {
            self.barcodeImageView.image = nil;
        }

        
    }else{
        NSLog(@"Did not found corresponding file");
    }
}

//Done with Editing card info
- (IBAction)editCardDone:(UIStoryboardSegue *)segue
{
    
    if ([segue.sourceViewController isKindOfClass:[EditCardViewController class]]) {
        NSLog(@"edit done");
        EditCardViewController *ecVC = (EditCardViewController *)segue.sourceViewController;
        self.cardPath = ecVC.cardPath;
        
        
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //pass the path of a specific card to EditCardViewController
    if ([segue.destinationViewController isKindOfClass:[EditCardViewController class]]) {
        EditCardViewController *ecVC = (EditCardViewController *)segue.destinationViewController;
        ecVC.cardPath = self.cardPath;
        ecVC.cards = self.cards;
        ecVC.rowNumer = self.rowNumer;
        

    }
}


@end
