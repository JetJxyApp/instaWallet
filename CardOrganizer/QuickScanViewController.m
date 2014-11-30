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
@property (nonatomic) float previousBrightness;


@end

@implementation QuickScanViewController

-(void)viewWillAppear:(BOOL)animated
{
    //increase the background brightness to maxinum
    self.previousBrightness = [UIScreen mainScreen].brightness;
    UIScreen *mainScreen = [UIScreen mainScreen];
    mainScreen.brightness = 1.0;
}


-(void)changeBarcode
{
    
    static int counter = 0;
    NSLog(@"total number: %d", (int)[self.barcodeInfoArray count]);
    NSLog(@"current: %d", counter);
    
    if(counter > [self.barcodeInfoArray count])
    {
        counter = 0;
    }
    if([self.barcodeInfoArray count] == counter)
    {
        counter = 0;
    }
    
    NSMutableArray *barcodeInfo = self.barcodeInfoArray[counter];
    NSString * barcodeNumber = [barcodeInfo objectAtIndex:0];
    NSString * barcodeType = [barcodeInfo objectAtIndex:1];
    
    NSLog(@"barcode number in quick scan = %@\n", barcodeNumber);
    NSLog(@"barcode type in quick scan = %@\n", barcodeType);
    
    
    
    
    if( [barcodeType isEqualToString:@"CODABAR"] )
    {
        barcodeNumber = [NSString stringWithFormat:@"%@%@%@", @"A",barcodeNumber, @"B"];
        self.barcodeImageView.frame = CGRectMake(12, 100, 350, 600);

        NSLog(@"%@",barcodeNumber);
    }
    
    NSLog(@"width is %d\n", (int)self.barcodeImageView.frame.size.width);
    NSLog(@"height is %d\n", (int)self.barcodeImageView.frame.size.height);
    
    if([barcodeNumber length]!=0 && [barcodeType length]!=0)
    {
        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
        ZXBitMatrix *result = [writer encode:barcodeNumber
                                      format:[self barcodeStringtoFormat:barcodeType]
                                       width:self.barcodeImageView.frame.size.width
                                      height:self.barcodeImageView.frame.size.height
                                       error:nil];
        if (result) {
            ZXImage *image = [ZXImage imageWithMatrix:result];
            CGImageRef imageRef = [self CGImageRotatedByAngle:image.cgimage angle:270];
            
            self.barcodeImageView.image = [UIImage imageWithCGImage:imageRef];
            NSLog(@"%@",self.barcodeImageView.image);
        } else {
            self.barcodeImageView.image = nil;
        }
    }
    
    counter++;
}

-(void)viewDidLoad
{
    //chage navigation controller color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.29 green:0.65 blue:0.96 alpha:1.0];
}

-(void) viewDidAppear:(BOOL)animated
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.cards = [delegate.delegateMutableArray mutableCopy];
    //[self.cards copy: delegate.delegateMutableArray];
    // for example
    
    if ([self.cards count]!=0)
    {
        NSLog(@"count number = %d", (int)[self.cards count]);
        NSLog(@"self car %@", self.cards);
    }
    else
    {
        NSLog(@"card empty!!!!!!!!!!!!");
    }
    
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
    
    if ([self.cards count]!=0)
    {
    
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(changeBarcode) userInfo:nil repeats:YES];

    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.barcodeInfoArray removeAllObjects];
    [myTimer invalidate];
    myTimer = nil;
    self.barcodeImageView.image = nil;
    
    
    //restore back to previous brightness
    UIScreen *mainScreen = [UIScreen mainScreen];
    mainScreen.brightness = self.previousBrightness;
}



-(NSMutableArray *)barcodeInfoArray
{
    if (!_barcodeInfoArray) {
        _barcodeInfoArray = [[NSMutableArray alloc]init];
    }
    return _barcodeInfoArray;
}


- (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle
{
    
    CGFloat angleInRadians = angle * (M_PI / 180);
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect imgRect = CGRectMake(0, 0, width, height);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
    CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   rotatedRect.size.width,
                                                   rotatedRect.size.height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, YES);
    CGContextSetShouldAntialias(bmContext, YES);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    CGColorSpaceRelease(colorSpace);
    CGContextTranslateCTM(bmContext,
                          +(rotatedRect.size.width/2),
                          +(rotatedRect.size.height/2));
    CGContextRotateCTM(bmContext, angleInRadians);
    CGContextTranslateCTM(bmContext,
                          -(rotatedRect.size.width/2),
                          -(rotatedRect.size.height/2));
    CGContextDrawImage(bmContext, CGRectMake(0, 0,
                                             rotatedRect.size.width,
                                             rotatedRect.size.height),
                       imgRef);
    
    
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    //[(id)rotatedImage autorelease];
    
    return rotatedImage;
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
