//
//  LandscapeViewController.m
//  CardOrganizer
//
//  Created by Jet Yue on 2014-10-25.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//

#import "LandscapeViewController.h"
#import "ZXBitMatrix.h"
#import "ZXMultiFormatWriter.h"
#import "ZXImage.h"
#import "ZXUPCAWriter.h"
#import "ZXBarcodeFormat.h"

@interface LandscapeViewController()

@property (weak, nonatomic) IBOutlet UIImageView *barcodeImageView;
@property (nonatomic) float previousBrightness;


@end

@implementation LandscapeViewController
- (IBAction)cancel
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) viewWillDisappear:(BOOL)animated
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    mainScreen.brightness = self.previousBrightness;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    
    NSLog(@"the barcode number is: %@\n", self.barcodeNumberTextField);
    NSLog(@"the barcode type is %@\n", self.barcodeTypeTextField);
    
    if ([self.barcodeNumberTextField length]!=0  && [self.barcodeTypeTextField length]!=0)
    {
        //start barcode generating
        if( [self.barcodeTypeTextField isEqualToString:@"CODABAR"] )
        {
            self.barcodeImageView.frame = CGRectMake(12, 103, 350, 600);
        }
        
        NSLog(@"width is %d\n", (int)self.barcodeImageView.frame.size.width);
        NSLog(@"height is %d\n", (int)self.barcodeImageView.frame.size.height);
        ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
        ZXBitMatrix *result = [writer encode:self.barcodeNumberTextField
                                      format:[self barcodeStringtoFormat:self.barcodeTypeTextField]
                                       width:self.barcodeImageView.frame.size.width
                                      height:self.barcodeImageView.frame.size.height
                                       error:nil];
        if (result && (![self.barcodeTypeTextField isEqualToString:@"PDF417"])) {
            
            ZXImage *image = [ZXImage imageWithMatrix:result];
            CGImageRef imageRef = [self CGImageRotatedByAngle:image.cgimage angle: -90];
            NSLog(@"image has been rotated -90 degrees!!");

            self.barcodeImageView.image = [UIImage imageWithCGImage:imageRef];

        }
        else if (result && [self.barcodeTypeTextField isEqualToString:@"PDF417"])
        {
            ZXImage *image = [ZXImage imageWithMatrix:result];
            CGImageRef imageRef = [self CGImageRotatedByAngle:image.cgimage angle: 180];
            NSLog(@"image has been rotated 180 degrees!!");
            
            self.barcodeImageView.image = [UIImage imageWithCGImage:imageRef];
            
        }
        else {
            self.barcodeImageView.image = nil;
        }
        
    }
    
    //increase the background brightness to maxinum
    self.previousBrightness = [UIScreen mainScreen].brightness;
    UIScreen *mainScreen = [UIScreen mainScreen];
    mainScreen.brightness = 1.0;
    

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
