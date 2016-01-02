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
#import "ReceiptImage.h"
#import "TripViewController.h"
#import "ReceiptImageViewController.h"
#import "WSCoachMarksView.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ReceiptTableViewController ()

@end

const NSInteger SECTION_AMOUNT = 1;
const NSInteger SECTION_EXP_TYPE = 2;
const NSInteger SECTION_BUTTONS = 0;
const NSInteger SECTION_PHOTOS = 3;
const NSInteger SECTION_NOTE = 4;

@implementation ReceiptTableViewController



@synthesize currencyArray,currencyFullNameArray;
@synthesize typeArray;
@synthesize m_selCurrency;
@synthesize m_selType, m_selComment;
@synthesize m_currencyTextViewPickerView;
@synthesize m_currencyTextViewPickerToolbar;
@synthesize m_typeTextViewPickerView;
@synthesize m_typeTextViewPickerToolbar;
@synthesize m_selDate, m_selAmount;
@synthesize m_currencyText, m_amountText, m_dateText, m_typeText;
@synthesize m_receiptImageHelper, m_deletedImageArr, m_origReceipt;



- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Receipt";
    [MainViewController setBackgrounColor:self];
    
    NSString* buttonName = @"Save";
    /*if (self.m_isUpdating)
        buttonName = @"Update";
    else
        buttonName = @"Add";
     */
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:buttonName
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(onAddOrUpdate)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Values" ofType:@"plist"]];
    NSLog(@"dictionary = %@", dictionary);
    currencyArray = [dictionary objectForKey:@"Currency"];
    typeArray = [dictionary objectForKey:@"Types"];
    currencyFullNameArray = [dictionary objectForKey:@"CurrencyFullName"];
    m_receiptImageHelper = [[ReceiptImage alloc] init];
    if (self.m_receipt == nil){
        m_origReceipt = nil;
        
        NSString* defCurrency = [[NSUserDefaults standardUserDefaults] stringForKey:@"ReceiptCurrency"];
        if (defCurrency == nil){
            defCurrency = @"USD";
            [[NSUserDefaults standardUserDefaults] setObject:defCurrency forKey:@"ReceiptCurrency"];
        }
        m_selCurrency = defCurrency;
        
        NSString* defType = [[NSUserDefaults standardUserDefaults] stringForKey:@"ExpenseType"];
        if (defType == nil){
            defType = @"Breakfast";
            [[NSUserDefaults standardUserDefaults] setObject:defType forKey:@"ExpenseType"];
        }
        
        m_selType = defType;
        m_selAmount = 0.0;
        
        NSString* defDateStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"DefaultReceiptDate"];
        NSDate* defDate = nil;
        if (defDateStr)
            defDate = [RemitConsts dateFromStr:defDateStr];
        else
            defDate = [NSDate date];
            
        m_selDate = defDate;
        m_selComment = nil;
    }
    else{
        m_origReceipt = [self.m_receipt copy];
        m_selCurrency = self.m_receipt.m_currency;
        m_selType = self.m_receipt.m_expenseType;
        m_selAmount = self.m_receipt.m_amount;
        m_selDate = [RemitConsts dateFromStr:self.m_receipt.m_date];
        [m_receiptImageHelper load:self.m_receipt.m_photo receipt:self.m_receipt];
        m_selComment = self.m_receipt.m_comment;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    m_deletedImageArr = [[NSMutableArray alloc] init];
    //[self setupCoachMark];
}


-(void)setupCoachMark{
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,65.0f},{365.0f,100.0f}}],
                                @"caption": @"Tap above to use your camera for clicking a photo of reciept or use an existing photo. You can add more than one photo. You can delete a photo by left-swipe."
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,165.0f},{365.0f,80.0f}}],
                                @"caption": @"Set or change amount you spent and the currency you used."
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,250.0f},{365.0f,80.0f}}],
                                @"caption": @"Set or modify date for this expense, and the type of expense."
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{250.0f,20.0f},{200.0f,45.0f}}],
                                @"caption": @"Finally click on save button to save your data."
                                }
                            
                            
                            ];
    self.m_coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
    
    [self.navigationController.view addSubview:self.m_coachMarksView];
}

- (void)viewDidAppear:(BOOL)animated {
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"WSReceiptViewCoachMarksShown"];
    if (coachMarksShown == NO) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WSReceiptViewCoachMarksShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.m_coachMarksView start];
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        // do your logic
    } else if(authStatus == AVAuthorizationStatusDenied){
        // denied
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Xpense Rcpt does not have access to your camera. to enable access, tap Settings and turn on Camera."
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alert addAction:cancelAction];
        
        UIAlertAction* settings = [UIAlertAction
                                   actionWithTitle:@"Settings"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
                                       
                                   }];
        [alert addAction:settings];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if(authStatus == AVAuthorizationStatusRestricted){
        // restricted, normally won't happen
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        // not determined?!
    } else {
        // impossible, unknown authorization status
    }
}


-(void)onAddOrUpdate{
    [self.view endEditing:YES];
    
    if (self.m_selAmount < 0.01 || m_receiptImageHelper.m_imageDataArr.count < 1){
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Please enter an amount and upload an image."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
    }

    
    [self saveReceipt];
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)updateReceipt{
    if (self.m_isUpdating == false){
        self.m_receipt = [[Receipt alloc] init];
    }
    
    self.m_receipt.m_amount = m_selAmount;
    self.m_receipt.m_currency = m_selCurrency;
    self.m_receipt.m_expenseType = m_selType;
    self.m_receipt.m_date = [RemitConsts strFromDate:self.m_selDate];;
    self.m_receipt.m_tripKey = self.m_tripId;
    self.m_receipt.m_photo = [m_receiptImageHelper getPhotoStr];
    self.m_receipt.m_comment = self.m_selComment;
}

-(void)saveReceipt{
    [self updateReceipt];
    if (self.m_isUpdating)
        [self.m_receipt updateReceipt];
    else
        [self.m_receipt saveReceipt];
    
    [self saveImagesToAppFolder];
    
    
    NSArray *viewContrlls=[[self navigationController] viewControllers];
    TripViewController* tripCtrl = (TripViewController*)[viewContrlls objectAtIndex:1];
    tripCtrl.m_trip.m_receipts = [Receipt loadReceipts:tripCtrl.m_trip.m_primaryKey];;
    [tripCtrl.tableView reloadData];
    [self.m_receiptImageHelper.m_imageDataArr removeAllObjects];
}

-(void)saveImagesToAppFolder{
    
    for (NSString* imgId in self.m_deletedImageArr) {
        NSString* destinationPath = [self.m_receipt imagePath:imgId];
        if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]){
            NSError* error;
            [[NSFileManager defaultManager] removeItemAtPath: destinationPath error: &error];
        }
    }
    
    for (ReceiptImageData* data in self.m_receiptImageHelper.m_imageDataArr) {
        if (data.m_isNew == false)
            continue;
        
        NSString* imgId = [NSString stringWithFormat:@"%lu",(long)data.m_id];
        NSString* destinationPath = [self.m_receipt imagePath:imgId];
        if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]){
            NSError* error;
            [[NSFileManager defaultManager] removeItemAtPath: destinationPath error: &error];
        }
        
        NSData *imageData = UIImageJPEGRepresentation(data.m_image, 0.3);
        [imageData writeToFile:destinationPath atomically:true];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (((NSInteger)section) == SECTION_AMOUNT || ((NSInteger)section) == SECTION_EXP_TYPE || ((NSInteger)section) == SECTION_BUTTONS )
        return 1;
    
    if (((NSInteger)section) == SECTION_PHOTOS)
        return self.m_receiptImageHelper.m_imageDataArr.count;

    if (((NSInteger)section) == SECTION_NOTE)
        return 1;

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SECTION_AMOUNT)
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
        
        self.m_amountText.delegate = self;
        self.m_currencyText.delegate = self;
        
        return cell;
    }
    if (indexPath.section == SECTION_EXP_TYPE)
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
        
        self.m_dateText.delegate = self;
        self.m_typeText.delegate = self;
        
        
        return cell;
    }

    if (indexPath.section == SECTION_BUTTONS)
    {
        static NSString* cellIdentifier = @"RcptButtonCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// forIndexPath:indexPath];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        UIButton* newPhotoBtn = (UIButton*)[cell viewWithTag:105];
        //UIImage *btnImage = [UIImage imageNamed:@"Camera Filled-50-2.png"];
        //[newPhotoBtn setImage:btnImage forState:UIControlStateNormal];
        [newPhotoBtn addTarget:self
                        action:@selector(onGetPhoto:)//onAddReceiptPhoto:)
         forControlEvents:UIControlEventTouchUpInside];
        
        /*UIButton* usePhotoBtn = (UIButton*)[cell viewWithTag:106];
        [usePhotoBtn addTarget:self
                        action:@selector(onUseReceiptPhoto:)
              forControlEvents:UIControlEventTouchUpInside];
        */
        
        return cell;
    }

    if (indexPath.section == SECTION_PHOTOS)
    {
        static NSString* cellIdentifier = @"RcptImageCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// forIndexPath:indexPath];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        UIImageView* imgView = (UIImageView*)[cell viewWithTag:107];
        imgView.contentMode = UIViewContentModeScaleAspectFit;

        imgView.image = ((ReceiptImageData*)[self.m_receiptImageHelper.m_imageDataArr objectAtIndex:indexPath.row]).m_image;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    if (indexPath.section == SECTION_NOTE)
    {
        static NSString* cellIdentifier = @"CommentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// forIndexPath:indexPath];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        self.m_commentText = (UITextView*)[cell viewWithTag:110];
        if (self.m_selComment != nil)
            self.m_commentText.text = m_selComment;
        
        self.m_commentText.delegate = self;
        return cell;
    }
    return nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.m_amountText)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        NSError *error = nil;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.m_currencyText){
        NSInteger index = [self.currencyArray indexOfObject:self.m_selCurrency];
        [self.m_currencyTextViewPickerView selectRow:index inComponent:0 animated:false];
        
    }
    if (textField == self.m_typeText){
        NSInteger index = [self.typeArray indexOfObject:self.m_selType];
        [self.m_typeTextViewPickerView selectRow:index inComponent:0 animated:false];
        
    }
    if (textField == self.m_dateText){
        [self.m_datePicker setDate:self.m_selDate];
        //self.m_datePicker.date = self.m_selDate;
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.m_amountText){
        m_selAmount = [textField.text floatValue];
    }
    if (textField == self.m_dateText){
        [self onDateChanged];
    }
    if (textField == self.m_currencyText){
        NSInteger row = [m_currencyTextViewPickerView selectedRowInComponent:0];
        m_selCurrency = [currencyArray objectAtIndex:row];
        [[NSUserDefaults standardUserDefaults] setObject:m_selCurrency forKey:@"ReceiptCurrency"];
        self.m_currencyText.text = m_selCurrency;
        
    }
    if (textField == self.m_typeText){
        NSInteger row = [m_typeTextViewPickerView selectedRowInComponent:0];
        m_selType = [typeArray objectAtIndex:row];
        [[NSUserDefaults standardUserDefaults] setObject:m_selType forKey:@"ExpenseType"];
        self.m_typeText.text = m_selType;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == SECTION_AMOUNT || indexPath.section == SECTION_EXP_TYPE)
        return 48;
    if (indexPath.section == SECTION_PHOTOS)
        return 220;
    if (indexPath.section == SECTION_NOTE)
        return 100;
    
    if (indexPath.section == SECTION_BUTTONS)
        return 66;
    
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35)] ;
    [headerView setBackgroundColor:[[RemitConsts sharedInstance] backgrounColor] ];
    UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, tableView.bounds.size.width, 20)];
    subjectLabel.textColor = [[RemitConsts sharedInstance] darkBackgrounColor];
    subjectLabel.backgroundColor = [UIColor clearColor];
    
    if (section == SECTION_AMOUNT){
        subjectLabel.text=@"Amount";
        [headerView addSubview:subjectLabel];
        return headerView;
    }
    
    if (section== SECTION_EXP_TYPE) {
        subjectLabel.text=@"Date and type";
        [headerView addSubview:subjectLabel];
        return headerView;
    }
    
    if (section==SECTION_BUTTONS) {
        subjectLabel.text=@"Capture Receipt";
        [headerView addSubview:subjectLabel];
        return headerView;
    }

    if (section == SECTION_PHOTOS){
        if (self.m_receiptImageHelper.m_imageDataArr.count > 0){
            subjectLabel.text=@"Receipts";
            [headerView addSubview:subjectLabel];
            return headerView;
        }
    }
    if (section==SECTION_NOTE) {
        subjectLabel.text=@"Enter notes";
        [headerView addSubview:subjectLabel];
        return headerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == SECTION_AMOUNT || section == SECTION_EXP_TYPE || section == SECTION_NOTE)
        return 35;
    
    if (section == SECTION_BUTTONS)
        return 35;
    
    if (section == SECTION_PHOTOS){
        if (self.m_receiptImageHelper.m_imageDataArr.count > 0)
            return 35;
    }
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SECTION_PHOTOS)
        return YES;
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger idOfDeletedImg = ((ReceiptImageData*)(self.m_receiptImageHelper.m_imageDataArr[indexPath.row])).m_id;
        [self.m_deletedImageArr addObject: [NSString stringWithFormat:@"%lu",(long)idOfDeletedImg]];
        [self.m_receiptImageHelper deleteImageAt:indexPath.row];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if (path.section == 3){
        ReceiptImageViewController* rcptController = (ReceiptImageViewController*)[segue destinationViewController];
        rcptController.m_imageData = ((ReceiptImageData*)[self.m_receiptImageHelper.m_imageDataArr objectAtIndex:path.row]);
    }
}


#pragma mark - various pickers


-(void)setDatePicker{
    
    self.m_datePicker = [[UIDatePicker alloc] init];
    self.m_datePicker.datePickerMode = UIDatePickerModeDate;
    //[self.m_datePicker addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
    
    self.m_datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    self.m_datePickerToolbar.barStyle = UIBarStyleDefault;
    [self.m_datePickerToolbar sizeToFit];
    
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDateChanged)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexibleSpace];
    [barItems addObject:doneBtn];
    [self.m_datePickerToolbar setItems:barItems animated:YES];
    //[self.m_datePickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpace, doneBtn, nil]];
    
    
    self.m_datePicker.date = self.m_selDate;
    
    
    self.m_dateText.inputView = self.m_datePicker;
    self.m_dateText.inputAccessoryView = self.m_datePickerToolbar;
    self.m_dateText.text = [RemitConsts strFromDate:self.m_selDate];
    
    
}

-(void)onDateChanged{
    self.m_selDate = self.m_datePicker.date;
    self.m_dateText.text = [RemitConsts strFromDate:self.m_selDate];
    [[NSUserDefaults standardUserDefaults] setObject:self.m_dateText.text forKey:@"DefaultReceiptDate"];
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
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexibleSpace];
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
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems2 addObject:flexibleSpace];
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
        return [self.currencyFullNameArray objectAtIndex:row];
    if (pickerView == m_typeTextViewPickerView)
        return [self.typeArray objectAtIndex:row];
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    if (pickerView == m_currencyTextViewPickerView){
        m_selCurrency = [currencyArray objectAtIndex:row];
        [[NSUserDefaults standardUserDefaults] setObject:m_selCurrency forKey:@"ReceiptCurrency"];
    }
    if (pickerView == m_typeTextViewPickerView)
        m_selType = [typeArray objectAtIndex:row];
}

#pragma mark - Image capture

-(IBAction)onGetPhoto:(id)sender{
    UIAlertController * alert=   [UIAlertController
                                 alertControllerWithTitle:@"How do you want to capture the receipt?"
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* newPhoto = [UIAlertAction
                               actionWithTitle:@"Take New Photo(s)"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [self onAddReceiptPhoto:nil];
                                   
                               }];
    [alert addAction:newPhoto];
    
    UIAlertAction* choosePhoto = [UIAlertAction
                                  actionWithTitle:@"Import from Cameral Roll"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [self onUseReceiptPhoto:nil];
                                      
                                  }];
    [alert addAction:choosePhoto];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)onAddReceiptPhoto:(id)sender {
    @try {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray* avMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        if (avMediaTypes.count > 0)
        {
            picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
            picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        }
        
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    @catch (NSException *exception) {
        NSLog(@"error = %@", exception.reason);
    }
    @finally {
        NSLog(@"done");
    }
}


- (IBAction)onUseReceiptPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    UIImageOrientation orientation = chosenImage.imageOrientation;
    if (orientation != UIImageOrientationUp){
        chosenImage = [UIImage imageWithCGImage:[chosenImage CGImage]
                                           scale:1.0
                                     orientation: UIImageOrientationUp];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.m_receiptImageHelper addNewImage:chosenImage];
    
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    NSString* defText = @"Details about this receipt.";
    if ([defText isEqualToString:textView.text]){
        // something new was entered.
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    self.m_selComment = textView.text;
    if ([textView.text isEqualToString:@""]){
        textView.text = @"Details about this receipt.";
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        NSString* defText = @"Details about this receipt.";
        if ([defText isEqualToString:textView.text] == false){
            // something new was entered.
            self.m_selComment = textView.text;
        }
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL) navigationShouldPopOnBackButton {
    
    if (m_origReceipt == nil){
        if (self.m_selAmount > 0.01 && m_receiptImageHelper.m_imageDataArr.count > 0){
        
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                           message:@"You have not save the Receipt. Save now?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [self saveReceipt];
                                                                      [[self navigationController] popViewControllerAnimated:YES];

                                                                  }];
            
            [alert addAction:defaultAction];
            UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [[self navigationController] popViewControllerAnimated:YES];
                                                                  }];
            
            [alert addAction:noAction];
            [self presentViewController:alert animated:YES completion:nil];
        
            return NO;
        }
        
        return YES;
    }
    
    NSString* defText = @"Details about this receipt.";
    if ([defText isEqualToString:self.m_commentText.text] == false){
        // something new was entered.
        self.m_selComment = self.m_commentText.text;
    }
    [self updateReceipt];
    
    bool needsUpdate = false;
    if (self.m_deletedImageArr.count > 0)
        needsUpdate = true;
    if (needsUpdate == false){
        for (ReceiptImageData* data in self.m_receiptImageHelper.m_imageDataArr) {
            if (data.m_isNew){
                needsUpdate = true;
                break;
            }
        }
    }
    
    if (needsUpdate || [self.m_receipt isSame:self.m_origReceipt] == false){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                       message:@"You have not save the Receipt. Save now?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self saveReceipt];
                                                                  [[self navigationController] popViewControllerAnimated:YES];
                                                                  
                                                              }];
        
        [alert addAction:defaultAction];
        UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [self.m_receipt transferData: self.m_origReceipt];
                                                             [[self navigationController] popViewControllerAnimated:YES];
                                                         }];
        
        [alert addAction:noAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    
    return YES; // Process 'Back' button click and Pop view controller
}


@end
