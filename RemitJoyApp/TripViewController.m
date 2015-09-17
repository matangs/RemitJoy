//
//  ReceiptViewController.m
//  TestApp2
//
//  Created by Manish Kumar on 8/23/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "MainViewController.h"
#import "TripViewController.h"
#import "Receipt.h"
#import "PDFHelper.h"
#import "EmailViewController.h"
#import "ReceiptTableViewController.h"
#import "WSCoachMarksView.h"


@interface TripViewController ()

@end

@implementation TripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.title = self.m_trip.m_name;
    [MainViewController setBackgrounColor:self];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self setupCoachMark];
    
}

-(void)setupCoachMark{
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,65.0f},{300.0f,80.0f}}],
                                @"caption": @"You add a new receipt for this trip here"
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,145.0f},{300.0f,80.0f}}],
                                @"caption": @"Here, you generate a PDF with all receipts captured on this trip for an email"
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,225.0f},{300.0f,80.0f}}],
                                @"caption": @"You view and change details for this expense here."
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,260.0f},{300.0f,45.0f}}],
                                @"caption": @"Now click on this reciept to view it's details"
                                }
                            
                            
                            ];
    self.m_coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
    
    [self.navigationController.view addSubview:self.m_coachMarksView];
}


- (void)viewDidAppear:(BOOL)animated {
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"WSTripViewCoachMarksShown"];
    if (coachMarksShown == NO) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WSTripViewCoachMarksShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.m_coachMarksView start];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (((NSInteger)section) == 0)
        return 1;

    if ( ((NSInteger)section) == 1){
        if (self.m_trip.m_receipts.count == 0)
            return 0;
        return 1;
    }
    
    return self.m_trip.m_receipts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        static NSString* cellIdentifier0 = @"AddReceiptCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier0];// forIndexPath:indexPath];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier0];
        }
        
        cell.textLabel.text = @"New receipt";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    if (indexPath.section == 1){
        static NSString* cellIdentifier1 = @"EmailTripCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];// forIndexPath:indexPath];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
        }
        
        cell.textLabel.text = @"Trip summary";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
        
    }
    static NSString* cellIdentifier = @"ReceiptCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    Receipt* rcpt = (Receipt*)[self.m_trip.m_receipts objectAtIndex:indexPath.row];
    
    NSString* title = [NSString stringWithFormat:@"%@ - %@",rcpt.m_date, rcpt.m_expenseType];
    NSString* subtitle = [NSString stringWithFormat:@"Amount - %.02f", rcpt.m_amount];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    
    return cell;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35)] ;
    [headerView setBackgroundColor:[[RemitConsts sharedInstance] backgrounColor] ];
    UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, tableView.bounds.size.width, 20)];
    subjectLabel.textColor = [[RemitConsts sharedInstance] darkBackgrounColor];
    subjectLabel.backgroundColor = [UIColor clearColor];
    
    if (section == 0){
        subjectLabel.text=@"Add";
    }
    else if (section==1) {
        subjectLabel.text=@"Email";
    }
    else if (section==2) {
        subjectLabel.text=@"Receipts";
    }
    
    [headerView addSubview:subjectLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //if(section == 1 || section == 2)
        return 35;
    //return UITableViewAutomaticDimension;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 2)
        return YES;
    
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        Receipt* selectedReceipt = (Receipt*)[self.m_trip.m_receipts objectAtIndex:indexPath.row];
        [Receipt deleteReceipt:selectedReceipt];
        self.m_trip.m_receipts = [Receipt loadReceipts:self.m_trip.m_primaryKey];
        [self.tableView reloadData];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if (path.section == 0){
        //ReceiptViewController* rcptController = (ReceiptViewController*)[segue destinationViewController];
        ReceiptTableViewController* rcptController = (ReceiptTableViewController*)[segue destinationViewController];
        rcptController.m_receipt = nil;
        rcptController.m_isUpdating = false;
        rcptController.m_tripId = self.m_trip.m_primaryKey;
    }
    else if (path.section == 1){
        [self CreatePDFonTempPath];
        EmailViewController* controller = (EmailViewController*)[segue destinationViewController];
        controller.m_tripName = self.m_trip.m_name;
    }
    else if (path.section == 2){
        
        Receipt* selectedReceipt = (Receipt*)[self.m_trip.m_receipts objectAtIndex:path.row];
        
        //ReceiptViewController* rcptController = (ReceiptViewController*)[segue destinationViewController];
        ReceiptTableViewController* rcptController = (ReceiptTableViewController*)[segue destinationViewController];
        rcptController.m_receipt = selectedReceipt;
        rcptController.m_isUpdating = true;
        rcptController.m_tripId = self.m_trip.m_primaryKey;
    }
}

- (UIImage *) convertToGreyscale:(UIImage *)i {
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen | kBlue | kRed;
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultUIImage;
}

-(void)CreatePDFonTempPath{
    
    NSString *pdfFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.pdf"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pdfFilePath]){
        NSError* error;
        [[NSFileManager defaultManager] removeItemAtPath: pdfFilePath error: &error];
    }
    
    //UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
    
    //UIColor*color = [UIColor blackColor];
    //NSDictionary* att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
    
    
    //creo pdf e vi aggiungo testo e immagini
    PDF*pdfFile = [[PDF alloc]init];
    [pdfFile initContent];
    [pdfFile setSize:CGSizeMake(612,792)];
    [pdfFile beginPDF:pdfFilePath];

    for (Receipt* rcpt in self.m_trip.m_receipts) {
        
        NSArray* arr = [rcpt.m_photo componentsSeparatedByString:@","];
        
        for (NSString* indexStr in arr) {
            NSString* path = [rcpt imagePath:indexStr];
            UIImage* image = [UIImage imageWithContentsOfFile:path];
            //image = [self convertToGreyscale:image];
            image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.1)];
            
            NSInteger width = image.size.width;
            NSInteger height = image.size.height;
            
            NSString* message = [NSString stringWithFormat:@"%@ - %@ - %@ %.02f",rcpt.m_date, rcpt.m_expenseType,rcpt.m_currency, rcpt.m_amount];
            
            //[pdfFile addImageWithRect:lowResImage inRect:CGRectMake(100, 100, width, height)];
            //[pdfFile addTextWithRect:message inRect:CGRectMake(100, height + 50, 500, 100)];
            
            
            if (width > height)
            {
                NSInteger newHt = (NSInteger)(300.0*height/width);
                [pdfFile addImageWithRect:image inRect:CGRectMake(100, 100, 300, newHt)];
                
                [pdfFile addTextWithRect:message inRect:CGRectMake(100, newHt + 150, 500, newHt + 250)];
            }
            else if (width < height)
            {
                NSInteger newwidtht = (NSInteger)(300.0*width/height);
                [pdfFile addImageWithRect:image inRect:CGRectMake(100, 100, newwidtht, 300)];
                [pdfFile addTextWithRect:message inRect:CGRectMake(100, 550, 500, 650)];
            }
            else
            {
                [pdfFile addImageWithRect:image inRect:CGRectMake(100, 100, 300, 300)];
                [pdfFile addTextWithRect:message inRect:CGRectMake(100, 550, 500, 650)];
            }
            
            
            [pdfFile writeOnNewPage];
        }
        
    }
    
    [pdfFile endPDF];
}


@end
