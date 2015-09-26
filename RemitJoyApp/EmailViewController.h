//
//  EmailViewController.h
//  TestApp2
//
//  Created by Manish Kumar on 8/24/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Trip.h"

@interface EmailViewController : UIViewController<MFMailComposeViewControllerDelegate, UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *m_pdfWebView;
@property (weak, nonatomic) Trip* m_trip;

@property (strong, nonatomic) MFMailComposeViewController * m_mailComposerViewcontroller;

@end
