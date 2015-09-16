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

@interface ReceiptTableViewController ()

@end

@implementation ReceiptTableViewController

@synthesize currencyArray,currencyFullNameArray;
@synthesize typeArray;
@synthesize m_selCurrency;
@synthesize m_selType;
@synthesize m_currencyTextViewPickerView;
@synthesize m_currencyTextViewPickerToolbar;
@synthesize m_typeTextViewPickerView;
@synthesize m_typeTextViewPickerToolbar;
@synthesize m_selDate, m_selAmount;
@synthesize m_currencyText, m_amountText, m_dateText, m_typeText;
@synthesize m_receiptImageHelper, m_deletedImageArr;


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
    currencyFullNameArray = [dictionary objectForKey:@"CurrencyFullName"];
    m_receiptImageHelper = [[ReceiptImage alloc] init];
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
        [m_receiptImageHelper load:self.m_receipt.m_photo receipt:self.m_receipt];
    }
    
    m_deletedImageArr = [[NSMutableArray alloc] init];
    [self setupCoachMark];
}


-(void)setupCoachMark{
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,65.0f},{300.0f,80.0f}}],
                                @"caption": @"Set or change amount you spent and the currency you used."
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,150.0f},{300.0f,80.0f}}],
                                @"caption": @"Set or update date for this expense, and the type of expense."
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,230.0f},{400.0f,80.0f}}],
                                @"caption": @"You can use your camera to click a photo of reciept or use an existing photo. You can add more than one photo. You can delete a photo by left-swipe."
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{250.0f,15.0f},{300.0f,45.0f}}],
                                @"caption": @"Finally click on update button to save the details"
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
}


-(void)onAddOrUpdate{
    if (self.m_selAmount < 0.01 || m_receiptImageHelper.m_imageDataArr.count < 1){
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Please enter an amount and upload an image."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
    }

    
    if (self.m_isUpdating == false){
        self.m_receipt = [[Receipt alloc] init];
    }
    self.m_receipt.m_amount = m_selAmount;
    self.m_receipt.m_currency = m_selCurrency;
    self.m_receipt.m_expenseType = m_selType;
    self.m_receipt.m_date = [RemitConsts strFromDate:self.m_selDate];;
    self.m_receipt.m_tripKey = self.m_tripId;
    self.m_receipt.m_photo = [m_receiptImageHelper getPhotoStr];
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
    [[self navigationController] popViewControllerAnimated:YES];
    

    
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
        
        NSString* imgId = [NSString stringWithFormat:@"%lu",data.m_id];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (((NSInteger)section) == 0 || ((NSInteger)section) == 1 || ((NSInteger)section) == 2 )
        return 1;
    
    if (((NSInteger)section) == 3)
        return self.m_receiptImageHelper.m_imageDataArr.count;
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        
        [self.m_amountText addTarget:self
                      action:@selector(amountFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
        
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
        
        return cell;
    }

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
        
        UIImageView* imgView = (UIImageView*)[cell viewWithTag:107];
        imgView.contentMode = UIViewContentModeScaleAspectFit;

        imgView.image = ((ReceiptImageData*)[self.m_receiptImageHelper.m_imageDataArr objectAtIndex:indexPath.row]).m_image;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    return nil;
}

-(void)amountFieldDidChange:sender{
    UITextField* field = (UITextField*)sender;
    m_selAmount = [field.text floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2)
        return 48;
    if (indexPath.section == 3)
        return 220;
    
    return 0;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3)
        return YES;
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger idOfDeletedImg = ((ReceiptImageData*)(self.m_receiptImageHelper.m_imageDataArr[indexPath.row])).m_id;
        [self.m_deletedImageArr addObject: [NSString stringWithFormat:@"%lu",idOfDeletedImg]];
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
        rcptController.m_image = ((ReceiptImageData*)[self.m_receiptImageHelper.m_imageDataArr objectAtIndex:path.row]).m_image;
    }
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
        return [self.currencyFullNameArray objectAtIndex:row];
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
    [self.m_receiptImageHelper addNewImage:chosenImage];
    
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}





@end
