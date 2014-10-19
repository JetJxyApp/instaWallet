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
@property (weak, nonatomic) IBOutlet UITextField *barcodeTypeTextField;
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
        self.barcodeTypeTextField.text = [data objectAtIndex:3];
        
        UIImage *customImage = [UIImage imageWithContentsOfFile:imageDataPathStr];
        self.imageView.image = customImage;
        
        
        if( [self.barcodeTypeTextField.text isEqualToString:@"CODABAR"] )
        {
            self.barcodeNumberTextField.text = [NSString stringWithFormat:@"%@%@%@", @"A",self.barcodeNumberTextField.text, @"B"];
            NSLog(@"%@",self.barcodeNumberTextField.text);
        }
        
        NSLog(@"width is %d\n", (int)self.barcodeImageView.frame.size.width);
        NSLog(@"width is %d\n", (int)self.barcodeImageView.frame.size.height);
        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
        ZXBitMatrix *result = [writer encode:self.barcodeNumberTextField.text
                                      format:[self barcodeStringtoFormat:self.barcodeTypeTextField.text]
                                       width:self.barcodeImageView.frame.size.width
                                      height:self.barcodeImageView.frame.size.height
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


- (ZXBarcodeFormat )barcodeStringtoFormat:(NSString *) str {
    
    if ([str isEqualToString:@"Aztec"])
    {
        return kBarcodeFormatAztec;
    }
    else if ([str isEqualToString:@"CODABAR"])
    {
        return kBarcodeFormatCodabar;
    }
    else if ([str isEqualToString:@"Code 39"])
    {
        return kBarcodeFormatCode39;
    }
    else if ([str isEqualToString:@"Code 93"])
    {
        return kBarcodeFormatCode93;
    }
    else if ([str isEqualToString:@"Code 128"])
    {
        return kBarcodeFormatCode128;
    }
    else if ([str isEqualToString:@"Data Matrix"])
    {
        return kBarcodeFormatDataMatrix;
    }
    else if ([str isEqualToString:@"EAN-8"])
    {
        return kBarcodeFormatEan8;
    }
    else if ([str isEqualToString:@"EAN-13"])
    {
        return kBarcodeFormatEan13;
    }
    else if ([str isEqualToString:@"ITF"])
    {
        return kBarcodeFormatITF;
    }
    else if ([str isEqualToString:@"PDF417"])
    {
        return kBarcodeFormatPDF417;
    }
    else if ([str isEqualToString:@"QR Code"])
    {
        return kBarcodeFormatQRCode;
    }
    else if ([str isEqualToString:@"RSS 14"])
    {
        return kBarcodeFormatRSS14;
    }
    else if ([str isEqualToString:@"RSS Expanded"])
    {
        return kBarcodeFormatRSSExpanded;
    }
    else if ([str isEqualToString:@"UPCA"])
    {
        return kBarcodeFormatUPCA;
    }
    else if ([str isEqualToString:@"UPCE"])
    {
        return kBarcodeFormatUPCE;
    }
    else if ([str isEqualToString:@"UPC/EAN extension"])
    {
        return kBarcodeFormatUPCEANExtension;
    }
    else
    {
        return 0;
    }
}



@end
