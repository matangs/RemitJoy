//
//  Trip.m
//  TestApp2
//
//  Created by Manish Kumar on 9/5/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "Trip.h"
#import "DBManager.h"

@implementation Trip

-(void)saveTrip{
    NSString* insertStr = [NSString stringWithFormat:@"insert into trips(name,date) values('%@','%@')",
           self.m_name,
           self.m_date];
    
    DBManager* mgr = [[DBManager alloc] initDatabase];
    [mgr executeQuery:insertStr];
    
    self.m_primaryKey = [[DBManager sharedInstance] lastInsertedRowID];
}

+(NSMutableArray*)loadTrips{
    NSString* loadStr = @"select id,name,date from trips order by date desc";
    
    DBManager* mgr = [[DBManager alloc] initDatabase];
    NSArray* data = [mgr loadDataFromDB:loadStr];
    
    NSMutableArray* retArr = [[NSMutableArray alloc] init];
    for (NSArray* row in data) {
        Trip* trip = [[Trip alloc] init];
        trip.m_primaryKey = [(NSString*)row[0] integerValue];
        trip.m_name = (NSString*)row[1];
        trip.m_date = (NSString*)row[2];
        
        [retArr addObject: trip];
    }
    
    return retArr;
    
}


@end
