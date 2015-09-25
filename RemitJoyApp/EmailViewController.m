//
//  EmailViewController.m
//  TestApp2
//
//  Created by Manish Kumar on 8/24/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "EmailViewController.h"
#import "MainViewController.h"
#import "Receipt.h"

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
    NSString *emailTitle = [NSString stringWithFormat: @"%@ - Trip summary", self.m_trip.m_name];
    // Email Content
    //NSString *messageBody = @"<br /> Hello there,<br /><br />The PDF containing all reciept images are attached for your filing purposes. Hope you enjoyed the ease of use of RemitJoy.<br /><br />Sent using <a href = 'www.remitjoy.com'>RemitJoy</a> for the iPhone.</p>";
    NSMutableString* message = [[NSMutableString alloc] init];
    
    [message appendString:@"<br />Hello there,<br /><br />The PDF containing all reciept images are attached for your filing purposes. Hope you enjoyed the ease of use of RemitJoy. Please find your expenses in a tabular format below.<br /><br /><table style=\"margin:0;border-collapse:collapse;\" cellpadding=\"5px\" cellspacing=\"5px\" border=\"1px\"><tr><th>Amount</th><th>Currency</th><th>Date</th><th>Type</th><th>Notes</th></tr>"];
    
    for (Receipt* rcpt in self.m_trip.m_receipts) {
        NSString* comment = @"";
        if (rcpt.m_comment != nil)
            comment = rcpt.m_comment;
        
        NSString* str = [NSString stringWithFormat:@"<tr><td>%.02f</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>", rcpt.m_amount, rcpt.m_currency, rcpt.m_date, rcpt.m_expenseType, comment];
        [message appendString:str];
    }
    
    [message appendString:@"</table><br/><br/>Sent using <a href = 'www.remitjoy.com'>RemitJoy</a> for the iPhone.</p>"];
    
    NSString* messageBody = [NSString stringWithFormat:@"%@",message];
    NSArray *toRecipents = [NSArray arrayWithObject:@""];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.pdf"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSString* filename = [NSString stringWithFormat:@"%@.pdf",self.m_trip.m_name];
    
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
