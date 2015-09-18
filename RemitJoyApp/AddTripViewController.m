//
//  AddTripViewController.m
//  TestApp2
//
//  Created by Manish Kumar on 8/23/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "AddTripViewController.h"
#import "MainViewController.h"
#import "Trip.h"

@interface AddTripViewController ()

@end

@implementation AddTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Trip";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(onDone)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self.m_tripDate setDate:[NSDate date]];
    [MainViewController setBackgrounColor:self];
    
}

-(void)onDone{
    NSString* name = self.m_tripName.text;
    if (name == nil || name.length < 1){
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Name is a required field"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    
        [myAlertView show];
        return;
    }
    
    NSDateFormatter* outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"MM-dd-YYYY"];
    NSString* date = [outputFormatter stringFromDate:self.m_tripDate.date];
    
    Trip* trip = [[Trip alloc]init];
    trip.m_date = date;
    trip.m_name = name;
    [trip saveTrip];

    NSArray *viewContrlls=[[self navigationController] viewControllers];
    MainViewController* mainCtrl = (MainViewController*)[viewContrlls objectAtIndex:0];
    mainCtrl.m_tripArray = [Trip loadTrips];
    [mainCtrl.tableView reloadData];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* homePath = [paths objectAtIndex:0];
    NSString *dataPath = [homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",trip.m_primaryKey]];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    [[self navigationController] popViewControllerAnimated:YES];
    
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
@end
