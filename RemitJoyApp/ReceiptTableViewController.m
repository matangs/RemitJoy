//
//  ReceiptTableViewController.m
//  Remit Joy
//
//  Created by KUMAR Manish on 9/13/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "ReceiptTableViewController.h"
#import "RemitConsts.h"
#import "MainViewController.h"

@interface ReceiptTableViewController ()

@end

@implementation ReceiptTableViewController

@synthesize currencyArray;
@synthesize typeArray;
@synthesize m_selCurrency;
@synthesize m_selType;
@synthesize m_currencyTextViewPickerView;
@synthesize m_currencyTextViewPickerToolbar;
@synthesize m_typeTextViewPickerView;
@synthesize m_typeTextViewPickerToolbar;
@synthesize m_selDate, m_selAmount,m_selImageArray;
@synthesize m_currencyText, m_amountText, m_dateText, m_typeText;


- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Values" ofType:@"plist"]];
    NSLog(@"dictionary = %@", dictionary);
    currencyArray = [dictionary objectForKey:@"Currency"];
    typeArray = [dictionary objectForKey:@"Types"];
    
    if (self.m_receipt == nil){
        m_selCurrency = @"USD";
        m_selType = @"Breakfast";
        m_selAmount = 0.0;
        m_selDate = [NSDate date];
        
    }
    else{
        m_selCurrency = self.m_receipt.m_currency;
        m_selType = self.m_receipt.m_expenseType;
        m_selAmount = self.m_receipt.m_amount;
        m_selDate = [RemitConsts dateFromStr:self.m_receipt.m_date];
    }
    
    m_selImageArray = [[NSMutableArray alloc] init];
}

-(void)onAddOrUpdate{
/*
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
 
*/
    
}

-(void)saveImageToAppFolder{
    
/*    if (self.m_imageURL == nil){
 
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
 
 */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (((NSInteger)section) == 0 || ((NSInteger)section) == 1 )
        return 1;
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //RcptImageCell, RcptAmountCell, RcptTypeCell
    if (indexPath.section == 0)
    {
        static NSString* cellIdentifier = @"RcptAmountCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// forIndexPath:indexPath];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        self.m_currencyText = (UITextField*)[cell viewWithTag:101];
        self.m_amountText = (UITextField*)[cell viewWithTag:102];
        self.m_currencyText.text = self.m_selCurrency;
        if (self.m_selAmount > 0.0)
        {
            self.m_amountText.text = [NSString stringWithFormat:@"%.02f", self.m_selAmount];
        }
        
        [self setCurrencyPicker];
        return cell;
    }
    if (indexPath.section == 1)
    {
        static NSString* cellIdentifier = @"RcptTypeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// forIndexPath:indexPath];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        self.m_dateText = (UITextField*)[cell viewWithTag:103];
        self.m_typeText = (UITextField*)[cell viewWithTag:104];
        
        self.m_dateText.text = [RemitConsts strFromDate:self.m_selDate];
        self.m_typeText.text = self.m_selType;
        
        [self setDatePicker];
        [self setExpenseTypePicker];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }

    //RcptButtonCell
    if (indexPath.section == 2)
    {
        static NSString* cellIdentifier = @"RcptButtonCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// forIndexPath:indexPath];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        UIButton* newPhotoBtn = (UIButton*)[cell viewWithTag:105];
        [newPhotoBtn addTarget:self
                   action:@selector(onAddReceiptPhoto:)
         forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* usePhotoBtn = (UIButton*)[cell viewWithTag:106];
        [usePhotoBtn addTarget:self
                        action:@selector(onUseReceiptPhoto:)
              forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }

    if (indexPath.section == 3)
    {
        static NSString* cellIdentifier = @"RcptImageCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// forIndexPath:indexPath];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        //cell.textLabel.text = @"New Trip";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // Configure the cell...
        
        return cell;
    }
    
    return nil;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35)] ;
    [headerView setBackgroundColor:[[RemitConsts sharedInstance] backgrounColor] ];
    UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, tableView.bounds.size.width, 20)];
    subjectLabel.textColor = [[RemitConsts sharedInstance] darkBackgrounColor];
    subjectLabel.backgroundColor = [UIColor clearColor];
    
    if (section == 0){
        subjectLabel.text=@"Amount";
        [headerView addSubview:subjectLabel];
        return headerView;
    }
    
    if (section==1) {
        subjectLabel.text=@"Date and type";
        [headerView addSubview:subjectLabel];
        return headerView;
    }
    
    if (section==2) {
        subjectLabel.text=@"Receipts";
        [headerView addSubview:subjectLabel];
        return headerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == 1 || section == 2)
        return 35;
    return 0;
}

#pragma mark - various pickers


-(void)setDatePicker{
    
    self.m_datePicker = [[UIDatePicker alloc] init];
    self.m_datePicker.datePickerMode = UIDatePickerModeDate;
    [self.m_datePicker addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
    
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
    
    
    self.m_dateText.inputView = self.m_datePicker;
    self.m_dateText.inputAccessoryView = self.m_datePickerToolbar;
    self.m_dateText.text = dateStr;
    
    
}

-(void)onDateChanged{
    self.m_selDate = self.m_datePicker.date;
    self.m_dateText.text = [RemitConsts strFromDate:self.m_selDate];
    [self.m_dateText resignFirstResponder];
}



-(void)setCurrencyPicker{
    m_currencyTextViewPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [m_currencyTextViewPickerView setDataSource: self];
    [m_currencyTextViewPickerView setDelegate: self];
    m_currencyTextViewPickerView.showsSelectionIndicator = YES;
    
    m_currencyTextViewPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    m_currencyTextViewPickerToolbar.barStyle = UIBarStyleDefault;
    [m_currencyTextViewPickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onCurrencySelected:)];
    [barItems addObject:doneBtn];
    [m_currencyTextViewPickerToolbar setItems:barItems animated:YES];
    
    
    self.m_currencyText.inputView = m_currencyTextViewPickerView;
    self.m_currencyText.inputAccessoryView = m_currencyTextViewPickerToolbar;
}

-(void)onCurrencySelected:sender
{
    self.m_currencyText.text = m_selCurrency;
    [self.m_currencyText resignFirstResponder];
    
}


-(void)setExpenseTypePicker{
    m_typeTextViewPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [m_typeTextViewPickerView setDataSource: self];
    [m_typeTextViewPickerView setDelegate: self];
    m_typeTextViewPickerView.showsSelectionIndicator = YES;
    
    m_typeTextViewPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    m_typeTextViewPickerToolbar.barStyle = UIBarStyleDefault;
    [m_typeTextViewPickerToolbar sizeToFit];
    
    NSMutableArray *barItems2 = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onTypeSelected:)];
    [barItems2 addObject:doneBtn2];
    [m_typeTextViewPickerToolbar setItems:barItems2 animated:YES];
    
    self.m_typeText.inputView = m_typeTextViewPickerView;
    self.m_typeText.inputAccessoryView = m_typeTextViewPickerToolbar;
}

-(void)onTypeSelected:sender
{
    self.m_typeText.text = m_selType;
    [self.m_typeText resignFirstResponder];
    
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

#pragma mark - Image capture


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
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    //self.m_receipt1ImgView.image = chosenImage;
    //self.m_imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}





@end
