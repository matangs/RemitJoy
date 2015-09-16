//
//  ReceiptViewController.h
//  TestApp2
//
//  Created by Manish Kumar on 8/23/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import "WSCoachMarksView.h"

@interface TripViewController : UITableViewController

@property (strong, nonatomic) Trip* m_trip;
@property(strong, nonatomic) WSCoachMarksView* m_coachMarksView;

@end
