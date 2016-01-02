//
//  MainViewController.h
//  TestApp2
//
//  Created by Manish Kumar on 8/23/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemitConsts.h"
#import "WSCoachMarksView.h"
#import "Trip.h"

@interface MainViewController : UITableViewController <UIAlertViewDelegate,UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) NSMutableArray* m_tripArray;

+(void)setBackgrounColor:(UIViewController*)controller;

@property(strong, nonatomic) WSCoachMarksView* m_coachMarksView;

@property(strong, nonatomic) Trip* m_tripToBeDeleted;
@end
