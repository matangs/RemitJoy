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
@property (atomic, strong) NSString* m_currency; //currency

@property (atomic, strong) NSString* m_expenseType; // type
@property (atomic) NSInteger m_expenseTypeOrder; // type_order

@property (atomic, strong) NSString* m_date; // date

@property (atomic, strong) NSString* m_photo; // photo1

@property (atomic, strong) NSString* m_comment; // comment

-(void)saveReceipt;
-(void)updateReceipt;
+(NSMutableArray*)loadReceipts:(NSInteger)tripId;
+(void)deleteReceipt:(Receipt*)rcpt;
-(NSString*)imagePathOld;
-(NSString*)imagePath:(NSString*)imgId;



@end
