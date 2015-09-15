//
//  ReceiptImageViewController.m
//  Remit Joy
//
//  Created by KUMAR Manish on 9/15/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "ReceiptImageViewController.h"

@interface ReceiptImageViewController ()

@end

@implementation ReceiptImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Image";
    
    self.m_imageView.image = self.m_image;
    self.m_imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
