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

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize m_tripArray;

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
    return YES;
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
        subjectLabel.text=@"Previous Trips";
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
