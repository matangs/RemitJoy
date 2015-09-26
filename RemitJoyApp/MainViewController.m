//
//  MainViewController.m
//  TestApp2
//
//  Created by Manish Kumar on 8/23/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "MainViewController.h"
#import "Trip.h"
#import "Receipt.h"
#import "TripViewController.h"
#import "WSCoachMarksView.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize m_tripArray, m_coachMarksView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.title = @"Trips";
    
    m_tripArray = [Trip loadTrips];
    
    [MainViewController setBackgrounColor:self];
    
    
    self.navigationController.navigationBar.barTintColor = [RemitConsts navBarColor];
    
    [self setupCoachMark];
    
}

-(void)setupCoachMark{
    // Setup coach marks
    NSArray *coachMarks = @[
                            /*@{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{0,0},{45,45}}],
                                @"caption": @"Helpful navigation menu",
                                @"shape": @"circle"
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{10.0f,56.0f},{300.0f,56.0f}}],
                                @"caption": @"Document your wedding by taking photos",
                                @"shape": @"square"
                                },*/
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,65.0f},{300.0f,80.0f}}],
                                @"caption": @"You start by adding a new trip to attach reciepts"
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,145.0f},{300.0f,120.0f}}],
                                @"caption": @"You can view and add receipts to trips already existing"
                                },
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{5.0f,225.0f},{300.0f,40.0f}}],
                                @"caption": @"Now please select Paris trip to explore it"
                                }
                            
                            ];
    m_coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
    
    [self.navigationController.view addSubview:m_coachMarksView];
    //[self.view addSubview:coachMarksView];
    
    //coachMarksView.animationDuration = 0.5f;
    //coachMarksView.enableContinueLabel = NO;
    //[coachMarksView start];
}


- (void)viewDidAppear:(BOOL)animated {
    // Show coach marks
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"WSMainViewCoachMarksShown"];
    if (coachMarksShown == NO) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WSMainViewCoachMarksShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [m_coachMarksView start];
    }
}


+(void)setBackgrounColor:(UIViewController*)controller{
    controller.view.backgroundColor = [[RemitConsts sharedInstance] backgrounColor];
    
    /*
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Values" ofType:@"plist"]];
    NSLog(@"dictionary = %@", dictionary);
    NSString* texture = [dictionary objectForKey:@"BackgroundTexture"];
    controller.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:texture]];
    */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (((NSInteger)section) == 0)
        return 1;
    return [m_tripArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        static NSString* cellIdentifier = @"NewTripCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// forIndexPath:indexPath];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.textLabel.text = @"New Trip";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // Configure the cell...
        
        return cell;
    }
    static NSString* cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];// forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [(Trip*)[m_tripArray objectAtIndex:indexPath.row] m_name];
    cell.detailTextLabel.text = [(Trip*)[m_tripArray objectAtIndex:indexPath.row] m_date];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 1)
        return YES;
    
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.m_tripToBeDeleted = (Trip*)[self.m_tripArray objectAtIndex:indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Deleting a trip can't be undone. You will lose data permanently"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Proceed",nil];
        [alert show];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    Trip* trip = self.m_tripToBeDeleted;
    self.m_tripToBeDeleted = nil;
    
    if (buttonIndex == 0)
    {
        NSLog(@"Cancel Tapped.");
        return;
    }
    else if (buttonIndex == 1)
    {
        [self.m_tripArray removeObject:trip];
        NSLog(@"OK Tapped. Hello World!");
        [Trip deleteTrip:trip];
        [self.tableView reloadData];
        return;
    }
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
        [headerView addSubview:subjectLabel];
        return headerView;
    }
    
    if (section==1) {
        subjectLabel.text=@"Added Trips";
        [headerView addSubview:subjectLabel];
        return headerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //if(section == 1)
        return 35;
    //return UITableViewAutomaticDimension;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
        
    }
    else if (path.section == 1){
        Trip* selectedTrip = (Trip*)[self.m_tripArray objectAtIndex:path.row];
        if (selectedTrip.m_receipts == nil){
            selectedTrip.m_receipts = [Receipt loadReceipts:selectedTrip.m_primaryKey];
        }
        
        TripViewController* tripController = (TripViewController*)[segue destinationViewController];
        tripController.m_trip = selectedTrip;
    }
}

@end
