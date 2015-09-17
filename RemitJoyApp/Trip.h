//
//  Trip.h
//  TestApp2
//
//  Created by Manish Kumar on 9/5/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject

@property (atomic) NSInteger m_primaryKey; // id
@property (atomic) NSString* m_name; // name
@property (atomic) NSString* m_date; // date

@property (atomic) NSArray* m_receipts;

-(void)saveTrip;
+(NSMutableArray*)loadTrips;


-(NSString*)tripDirectoryPath;
+(void)deleteTrip:(Trip*)trip;



@end
