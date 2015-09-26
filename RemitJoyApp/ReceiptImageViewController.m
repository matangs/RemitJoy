//
//  ReceiptImageViewController.m
//  Remit Joy
//
//  Created by KUMAR Manish on 9/15/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "ReceiptImageViewController.h"
#import "ReceiptTableViewController.h"

@interface ReceiptImageViewController ()

@end

@implementation ReceiptImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Image";
    self.m_reloadData = false;
    
    self.m_imageView.image = self.m_imageData.m_image;
    self.m_imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //UIImage *image = [[UIImage imageNamed:@"rotate.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onRotate)];
    
    NSString* buttonName = @"Rotate";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:buttonName
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(onRotate)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.m_scrollView.minimumZoomScale=0.5;
    self.m_scrollView.maximumZoomScale=6.0;
    self.m_scrollView.contentSize=CGSizeMake(1280, 960);
    self.m_scrollView.delegate=self;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.m_imageView;
}

-(void)onRotate{
    CGImageRef imageRef = [self CGImageRotatedByAngle:[self.m_imageData.m_image CGImage] angle:-90];
    UIImage* img = [UIImage imageWithCGImage: imageRef];
    
    self.m_imageData.m_image = img;
    self.m_imageView.image = self.m_imageData.m_image;
    self.m_imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.m_imageData.m_isNew = true;
    self.m_reloadData = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle
{
    
    CGFloat angleInRadians =  angle * (M_PI / 180);
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
                          +(rotatedRect.size.width/2.0),
                          +(rotatedRect.size.height/2.0));
    CGContextRotateCTM(bmContext, angleInRadians);
    CGContextTranslateCTM(bmContext,
                          -(width/2.0),
                          -(height/2.0));
    CGContextDrawImage(bmContext, CGRectMake(0, 0,
                                             width,
                                             height),
                       imgRef);
    
    
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    return rotatedImage;
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.m_reloadData){
        NSArray *viewContrlls=[[self navigationController] viewControllers];
        NSInteger parentIndex = viewContrlls.count - 1;
        ReceiptTableViewController* rcptCtrller = (ReceiptTableViewController*)[viewContrlls objectAtIndex:parentIndex];
        [rcptCtrller.tableView reloadData];
    }
    
}


@end
