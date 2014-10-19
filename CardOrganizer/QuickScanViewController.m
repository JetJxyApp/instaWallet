//
//  QuickScanViewController.m
//  CardOrganizer
//
//  Created by Jet Yue on 2014-10-19.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import "QuickScanViewController.h"
#import "AppDelegate.h"
#import "ZXBitMatrix.h"
#import "ZXMultiFormatWriter.h"
#import "ZXImage.h"
#import "ZXUPCAWriter.h"
#import "ZXBarcodeFormat.h"


@interface QuickScanViewController()

@property (nonatomic) NSString *barcodeNumber;
@property (nonatomic) NSString *barcodeType;
@property (nonatomic, strong) NSMutableArray * barcodeInfoArray;

@property (weak, nonatomic) IBOutlet UIImageView *barcodeImageView;

@end

@implementation QuickScanViewController
- (IBAction)startBarcodeScan:(id)sender {
    
    for (NSMutableArray *barcodeInfo in self.barcodeInfoArray)
    {
        
        NSString * barcodeNumber = [barcodeInfo objectAtIndex:0];
        NSString * barcodeType = [barcodeInfo objectAtIndex:1];
        
        NSLog(@"barcode number = %@\n", barcodeNumber);
        NSLog(@"barcode type = %@\n", barcodeType);
    
    

    
    if( [barcodeType isEqualToString:@"CODABAR"] )
    {
        barcodeNumber = [NSString stringWithFormat:@"%@%@%@", @"A",barcodeNumber, @"B"];
        NSLog(@"%@",barcodeNumber);
    }
    
    NSLog(@"width is %d\n", (int)self.barcodeImageView.frame.size.width);
    NSLog(@"height is %d\n", (int)self.barcodeImageView.frame.size.height);
    
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:barcodeNumber
                                  format:[self barcodeStringtoFormat:barcodeType]
                                   width:self.barcodeImageView.frame.size.width
                                  height:self.barcodeImageView.frame.size.height
                                   error:nil];
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        NSLog(@"%@",image);
        
        
        self.barcodeImageView.image = [UIImage imageWithCGImage:image.cgimage];
        NSLog(@"%@",self.barcodeImageView.image);
    } else {
        self.barcodeImageView.image = nil;
    }

    }
}

-(void) viewDidAppear:(BOOL)animated
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.cards = [delegate.delegateMutableArray mutableCopy];
    //[self.cards copy: delegate.delegateMutableArray];
    // for example
    
    NSLog(@"self card = %@\n", self.cards);
    
    
    for (NSMutableArray * card in self.cards)
    {
        
        NSString *textDataPathStr = [[card objectAtIndex:0] objectAtIndex:0];
        //NSString *imageDataPathStr = [[card  objectAtIndex:0] objectAtIndex:1];
        
        NSLog(@"text path = %@\n", textDataPathStr);
        //NSLog(@"image pat = %@\n", imageDataPathStr);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:textDataPathStr])
        {
            NSArray *data = [[NSArray alloc] initWithContentsOfFile:textDataPathStr];

            self.barcodeNumber = [data objectAtIndex:2];
            self.barcodeType = [data objectAtIndex:3];
            
            NSMutableArray *barcodeInfo = [[NSMutableArray alloc]init];
            
            [barcodeInfo addObject:self.barcodeNumber];
            [barcodeInfo addObject:self.barcodeType];
            NSLog(@"inside=====================================");

            [self.barcodeInfoArray addObject:barcodeInfo];
            
            for (NSString *str in self.barcodeInfoArray) {
                NSLog(@"barcode info = %@\n", str);
            }
            
        }else
        {
            NSLog(@"Did not found corresponding file");
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.barcodeInfoArray removeAllObjects];
}

-(NSMutableArray *)barcodeInfoArray
{
    if (!_barcodeInfoArray) {
        _barcodeInfoArray = [[NSMutableArray alloc]init];
    }
    return _barcodeInfoArray;
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
