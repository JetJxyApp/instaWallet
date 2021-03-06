//
//  BarcodeScannerViewController.m
//  CardOrganizer
//
//  Created by Jet Yue on 2014-10-18.
//  Copyright (c) 2014 Jet&JXY. All rights reserved.
//


#import <AudioToolbox/AudioToolbox.h>
#import "BarcodeScannerViewController.h"

@interface BarcodeScannerViewController ()

@property (nonatomic, strong) ZXCapture *capture;
@property UIView *scanRectView;
@property UILabel *decodedLabel;
@property UILabel *label;

@end

@implementation BarcodeScannerViewController

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    [self.view bringSubviewToFront:self.scanRectView];
    [self.view bringSubviewToFront:self.decodedLabel];
    
    //hide the bottom tabbar controller
    self.tabBarController.tabBar.hidden = YES ;
    
    
    /*
     * code below create a scan view and label
     */
    CGRect bounds = CGRectMake((self.view.frame.size.width - 300)/2.0, 100, 300, 300 );
    self.scanRectView = [[UIView alloc] initWithFrame: bounds];
    [self.scanRectView setBackgroundColor:  [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.4]];
    [self.view addSubview: self.scanRectView];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    [self.label setText: @"Scan your card in the box"];
    [self.label setTextColor: [UIColor colorWithRed:0.29 green:0.53 blue:0.91 alpha:1.0]];
    [self.label setFont:[UIFont fontWithName:@"Chalkduster" size:16.0]];
    self.label.center = CGPointMake((self.view.frame.size.width)/2.0 + 22, self.scanRectView.bounds.size.height/2.0);
    //self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 0;
    [self.scanRectView addSubview: self.label];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(self.scanRectView.frame, captureSizeTransform);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    
    // We got a result. Display information about the result onscreen.
    NSString *formatString = nil;
    if([self barcodeFormatToString:result.barcodeFormat]!=nil)
    {
        formatString = [self barcodeFormatToString:result.barcodeFormat];
        NSLog(@"Barcode Number is: %@",result.text);
        NSLog(@"Barcode Type is: %@", formatString);
        NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
        [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:display waitUntilDone:YES];
    
        // Vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
        //notification to pass barcode info
            NSLog(@"notification statement");
            [self dissmissModelView:result.text type:formatString];
    }
    
}

-(void)dissmissModelView:(NSString *)barcodeString type:(NSString *)barcodeType
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"DismissModalviewController");
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:barcodeString];
    [array addObject:barcodeType];
    
    //raise notification about dismiss
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ScanBarcode Dismiss"
     object:array];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:true];


}



@end
