//
//  ReceiptImageViewController.h
//  Remit Joy
//
//  Created by KUMAR Manish on 9/15/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiptImage.h"

@interface ReceiptImageViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@property (weak, nonatomic) ReceiptImageData* m_imageData;

@property bool m_reloadData;

@end
