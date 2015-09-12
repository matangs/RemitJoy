//
//  Receipt.h
//  TestApp2
//
//  Created by Manish Kumar on 9/5/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Receipt : NSObject

@property (atomic) NSInteger m_primaryKey; //id
@property (atomic) NSInteger m_tripKey; //trip_id

@property (atomic) float  m_amount; //amount
@property (atomic) NSString* m_currency; //currency

@property (atomic) NSString* m_expenseType; // type
@property (atomic) NSInteger m_expenseTypeOrder; // type_order

@property (atomic) NSString* m_date; // date

@property (atomic) NSString* m_photo1; // photo1
@property (atomic) NSInteger m_info1; // info1

@property (atomic) NSString* m_photo2; // photo1
@property (atomic) NSInteger m_info2; // info1

@property (atomic) NSString* m_photo3; // photo1
@property (atomic) NSInteger m_info3; // info1

@property (atomic) NSString* m_photo4; // photo1
@property (atomic) NSInteger m_info4; // info1

@property (atomic) NSString* m_comment; // comment

-(void)saveReceipt;
-(void)updateReceipt;
+(NSMutableArray*)loadReceipts:(NSInteger)tripId;
+(void)deleteReceipt:(Receipt*)rcpt;
-(NSString*)imagePath;



@end
