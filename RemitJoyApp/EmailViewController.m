//
//  EmailViewController.m
//  TestApp2
//
//  Created by Manish Kumar on 8/24/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "EmailViewController.h"
#import "MainViewController.h"

@interface EmailViewController ()

@end

@implementation EmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"PDF";
    
    // let this be white background to match the web-view background.
    //[MainViewController setBackgrounColor:self];
    
    NSString* buttonName = @"Email";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:buttonName
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(onSendEmail:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    

    self.m_pdfWebView.scalesPageToFit = YES;
    self.m_pdfWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.m_pdfWebView.delegate = self;

    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.m_pdfWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSendEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = [NSString stringWithFormat: @"%@ - Trip summary", self.m_tripName];
    // Email Content
    NSString *messageBody = @"<br /> Hello there,<br /><br />The PDF containing all reciept images are attached for your filing purposes. Hope you enjoyed the ease of use of RemitJoy.<br /><br />Sent using <a href = 'www.remitjoy.com'>RemitJoy</a> for the iPhone.</p>";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@""];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc setToRecipients:toRecipents];
    
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.pdf"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSString* filename = [NSString stringWithFormat:@"%@.pdf",self.m_tripName];
    
    NSString* mimeType = @"application/pdf";
    [mc addAttachmentData:fileData mimeType:mimeType fileName:filename];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
