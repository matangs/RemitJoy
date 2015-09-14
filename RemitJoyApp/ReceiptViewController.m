//
//  AddReceiptViewController.m
//  TestApp2
//
//  Created by Manish Kumar on 8/24/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "ReceiptViewController.h"
#import "MainViewController.h"
#import "TripViewController.h"
#import "PDFHelper.h"
#import <Photos/Photos.h>

@interface ReceiptViewController ()

@end

@implementation ReceiptViewController

@synthesize currencyArray;
@synthesize typeArray;
@synthesize m_selCurrency;
@synthesize m_selType;
@synthesize m_currencyTextViewPickerView;
@synthesize m_currencyTextViewPickerToolbar;
@synthesize m_typeTextViewPickerView;
@synthesize m_typeTextViewPickerToolbar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Receipt";
    [MainViewController setBackgrounColor:self];

    NSString* buttonName = nil;
    if (self.m_isUpdating)
        buttonName = @"Update";
    else
        buttonName = @"Add";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:buttonName
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(onAddOrUpdate)];
    self.navigationItem.rightBarButtonItem = rightButton;

    
/*    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }*/
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Values" ofType:@"plist"]];
    NSLog(@"dictionary = %@", dictionary);
    currencyArray = [dictionary objectForKey:@"Currency"];
    typeArray = [dictionary objectForKey:@"Types"];
    
    if (self.m_receipt == nil){
        m_selCurrency = @"USD";
        m_selType = @"Breakfast";
    }
    else{
        m_selCurrency = self.m_receipt.m_currency;
        m_selType = self.m_receipt.m_expenseType;
        self.m_amountTextView.text = [NSString stringWithFormat:@"%.02f", self.m_receipt.m_amount];
    }
    self.m_currencyTextView.text = m_selCurrency;
    self.m_typeTextView.text = m_selType;
    
    
    [self setCurrencyPicker];
    [self setExpenseTypePicker];
    
    if (self.m_receipt != nil){
        NSString* path = [self.m_receipt imagePath];
        if (path != nil && [[NSFileManager defaultManager] fileExistsAtPath:path])
            self.m_receipt1ImgView.image = [UIImage imageWithContentsOfFile:path];
    }
    
    [self setDatePicker];
    
    self.m_imgTableView.dataSource = self;
    [self.m_imgTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    /*
    dispatch_async(dispatch_get_main_queue()) {
        //This code will run in the main thread:
        CGRect frame = self.tableView.frame;
        frame.size.height = self.tableView.contentSize.height;
        self.tableView.frame = frame;
    }*/
    
}

-(void)viewDidAppear:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        //This code will run in the main thread:
        CGRect frame = self.m_imgTableView.frame;
        frame.size.height = self.m_imgTableView.contentSize.height;
        self.m_imgTableView.frame = frame;
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ImageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView* imageView = (UIImageView *)[cell viewWithTag:101];
    
    if (self.m_receipt != nil){
        NSString* path = [self.m_receipt imagePath];
        if (path != nil && [[NSFileManager defaultManager] fileExistsAtPath:path])
            imageView.image = [UIImage imageWithContentsOfFile:path];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

-(void)datePickerValueChanged:(id)sender{
    
}

-(void)onDateChanged{
    NSDateFormatter* outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"MM-dd-YYYY"];
    NSString* date = [outputFormatter stringFromDate:self.m_datePicker.date];
    self.m_dateTextView.text = date;
    [self.m_dateTextView resignFirstResponder];
}

-(void)setDatePicker{
    
    self.m_datePicker = [[UIDatePicker alloc] init];
    self.m_datePicker.datePickerMode = UIDatePickerModeDate;
    [self.m_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    //datePicker.tag = indexPath.row;
    self.m_dateTextView.inputView = self.m_datePicker;
    
    self.m_datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    self.m_datePickerToolbar.barStyle = UIBarStyleDefault;
    [self.m_datePickerToolbar sizeToFit];
    
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDateChanged)];
    [barItems addObject:doneBtn];
    [self.m_datePickerToolbar setItems:barItems animated:YES];

    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-YYYY"];
    NSString* dateStr = [formatter stringFromDate:[NSDate date]];
    if (self.m_receipt)
        dateStr = self.m_receipt.m_date;
    
    self.m_datePicker.date = [NSDate date];
    
    
    self.m_dateTextView.inputAccessoryView = self.m_datePickerToolbar;

    self.m_dateTextView.text = dateStr;
    
    
}

-(void)setCurrencyPicker{
    m_currencyTextViewPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [m_currencyTextViewPickerView setDataSource: self];
    [m_currencyTextViewPickerView setDelegate: self];
    m_currencyTextViewPickerView.showsSelectionIndicator = YES;
    self.m_currencyTextView.inputView = m_currencyTextViewPickerView;
    
    m_currencyTextViewPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    m_currencyTextViewPickerToolbar.barStyle = UIBarStyleDefault;
    [m_currencyTextViewPickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onCurrencySelected:)];
    [barItems addObject:doneBtn];
    [m_currencyTextViewPickerToolbar setItems:barItems animated:YES];
    
    
    self.m_currencyTextView.inputAccessoryView = m_currencyTextViewPickerToolbar;
}

-(void)setExpenseTypePicker{
    m_typeTextViewPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [m_typeTextViewPickerView setDataSource: self];
    [m_typeTextViewPickerView setDelegate: self];
    m_typeTextViewPickerView.showsSelectionIndicator = YES;
    self.m_typeTextView.inputView = m_typeTextViewPickerView;
    
    m_typeTextViewPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    m_typeTextViewPickerToolbar.barStyle = UIBarStyleDefault;
    [m_typeTextViewPickerToolbar sizeToFit];
    
    NSMutableArray *barItems2 = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onTypeSelected:)];
    [barItems2 addObject:doneBtn2];
    [m_typeTextViewPickerToolbar setItems:barItems2 animated:YES];
    
    self.m_typeTextView.inputAccessoryView = m_typeTextViewPickerToolbar;
}

-(void)onTypeSelected:sender
{
    self.m_typeTextView.text = m_selType;
    [self.m_typeTextView resignFirstResponder];
    
}

-(void)onCurrencySelected:sender
{
    [self.m_currencyButton setTitle:m_selCurrency forState:UIControlStateNormal];
    self.m_currencyTextView.text = m_selCurrency;
    [self.m_currencyTextView resignFirstResponder];
    
}

-(void)onAddOrUpdate{
    
    if (self.m_amountTextView.text == nil || self.m_amountTextView.text.length < 1 || (self.m_imageURL == nil && self.m_isUpdating == false)){
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Please enter an amount and upload an image."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
    }
    
    NSString* amount = self.m_amountTextView.text;
    NSString* date = self.m_dateTextView.text;
    
    if (self.m_isUpdating == false){
        self.m_receipt = [[Receipt alloc] init];
    }
    self.m_receipt.m_amount = [amount floatValue];
    self.m_receipt.m_currency = m_selCurrency;
    self.m_receipt.m_expenseType = m_selType;
    self.m_receipt.m_date = date;
    self.m_receipt.m_tripKey = self.m_tripId;
    if (self.m_isUpdating)
        [self.m_receipt updateReceipt];
    else
        [self.m_receipt saveReceipt];
    
    [self saveImageToAppFolder];

    
    NSArray *viewContrlls=[[self navigationController] viewControllers];
    TripViewController* tripCtrl = (TripViewController*)[viewContrlls objectAtIndex:1];
    tripCtrl.m_trip.m_receipts = [Receipt loadReceipts:tripCtrl.m_trip.m_primaryKey];;
    [tripCtrl.tableView reloadData];
    [[self navigationController] popViewControllerAnimated:YES];
    
}

-(void)saveImageToAppFolder{
    
    if (self.m_imageURL == nil){
    
        NSData *imageData = UIImageJPEGRepresentation(self.m_receipt1ImgView.image, 0.7); // 0.7 is JPG quality
        NSString* destinationPath = [self.m_receipt imagePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]){
            NSError* error;
            [[NSFileManager defaultManager] removeItemAtPath: destinationPath error: &error];
        }
        
        
        [imageData writeToFile:destinationPath atomically:true];
        return;
        
    }

    NSArray* urlArray = [NSArray arrayWithObjects:self.m_imageURL,nil];
    
    PHFetchResult* fetchResult = [PHAsset fetchAssetsWithALAssetURLs:urlArray options:nil];
    if (fetchResult.count != 1)
        return;
    
    PHAsset* asset = (PHAsset*)[fetchResult objectAtIndex:0];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:options
                                                resultHandler:^(NSData *imageData,
                                                                NSString *dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary *info){
                                                    
                                                    NSString* destinationPath = [self.m_receipt imagePath];
                                                    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]){
                                                        NSError* error;
                                                        [[NSFileManager defaultManager] removeItemAtPath: destinationPath error: &error];
                                                    }


                                                    [imageData writeToFile:destinationPath atomically:true];
                                                    
                                                }];
}

- (IBAction)onEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"iOS programming is so fun!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"matangs@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.pdf"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSString* filename = @"Velizy-Trip.pdf";
    
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

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if (pickerView == m_currencyTextViewPickerView)
        return currencyArray.count;
    if (pickerView == m_typeTextViewPickerView)
        return typeArray.count;
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (pickerView == m_currencyTextViewPickerView)
        return [self.currencyArray objectAtIndex:row];
    if (pickerView == m_typeTextViewPickerView)
        return [self.typeArray objectAtIndex:row];
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    if (pickerView == m_currencyTextViewPickerView)
        m_selCurrency = [currencyArray objectAtIndex:row];
    if (pickerView == m_typeTextViewPickerView)
        m_selType = [typeArray objectAtIndex:row];
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

- (IBAction)onAddReceiptPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)onUseReceiptPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.m_receipt1ImgView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.m_imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
}

- (IBAction)testButton:(id)sender {
    [self CreaPDFconPath];
}

- (IBAction)onCreatePDF:(id)sender {
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)onCurrencyChooser:(id)sender {
    self.m_currencyPicker.hidden = false;
}

//-(void)CreaPDFconPath:(NSString*)pdfFilePathIn{
-(void)CreaPDFconPath{
    
    NSString *pdfFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.pdf"];
    
    UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
    
    UIColor*color = [UIColor blackColor];
    NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
    
    NSString* bottomText = @"lines1 \n\nline2";
    CGFloat stringSize = [bottomText boundingRectWithSize:CGSizeMake(980, CGFLOAT_MAX)// use CGFLOAT_MAX to dinamically calculate the height of a string
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:att context:nil].size.height;
    
    //creo pdf e vi aggiungo testo e immagini
    PDF*pdfFile = [[PDF alloc]init];
    [pdfFile initContent];
    [pdfFile setSize:CGSizeMake(1000, 400+stringSize)];
    
    // set header text
    [pdfFile addHeadertWithRect:@"Header text" inRect:CGRectMake(10, 10, 980, 60)];
    
    
    // set image
    if (self.m_receipt1ImgView.image){
        [pdfFile addImageWithRect:self.m_receipt1ImgView.image inRect:CGRectMake(10, 80, 250, 250)];
    }
    
    // set text next to image.
    NSString*imgText = @"test1\n\ntest2";
    [pdfFile addHeadertWithRect:imgText inRect:CGRectMake(300, 190, 500, 120)];


    // set text at the bottom
    [pdfFile addTextWithRect:bottomText inRect:CGRectMake(10, 350, 980, CGFLOAT_MAX)];
    
    
    // now create PDF file.
    [pdfFile beginPDF:pdfFilePath];
    [pdfFile writeOnNewPage];
    // set text next to image.
    [pdfFile addHeadertWithRect:@"new text" inRect:CGRectMake(300, 210, 500, 120)];
    // set text at the bottom
    [pdfFile addTextWithRect:@"New bottom text" inRect:CGRectMake(10, 370, 980, CGFLOAT_MAX)];

    [pdfFile writeOnNewPage];

    [pdfFile writeOnNewPage];
    [pdfFile endPDF];
}

@end
