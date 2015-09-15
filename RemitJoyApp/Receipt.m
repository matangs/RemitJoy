//
//  Receipt.m
//  TestApp2
//
//  Created by Manish Kumar on 9/5/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "Receipt.h"
#import "DBManager.h"
#import "RemitConsts.h"

@implementation Receipt

-(void)saveReceipt{
    NSInteger typeOrder = [RemitConsts orderForExpenseType:self.m_expenseType];
    
    NSString* insertStr = [NSString stringWithFormat:@"insert into receipts (trip_id, amount, currency, type, type_order, date, photo) values(%lu, %.02f, '%@', '%@', %lu, '%@','%@')",
                           self.m_tripKey,
                           self.m_amount,
                           self.m_currency,
                           self.m_expenseType,
                           typeOrder,
                           self.m_date,
                           self.m_photo];
    
    DBManager* mgr = [[DBManager alloc] initDatabase];
    [mgr executeQuery:insertStr];
    
    self.m_primaryKey = [mgr lastInsertedRowID];
    
}

-(void)updateReceipt{
    NSInteger typeOrder = [RemitConsts orderForExpenseType:self.m_expenseType];

    NSString* updateStr = [NSString stringWithFormat:@"UPDATE receipts SET amount = %.02f, currency = '%@', type = '%@', date = '%@', photo = '%@', type_order = %lu WHERE id = %lu",
                           self.m_amount,
                           self.m_currency,
                           self.m_expenseType,
                           self.m_date,
                           self.m_photo,
                           typeOrder,
                           self.m_primaryKey
                           ];
    DBManager* mgr = [[DBManager alloc] initDatabase];
    [mgr executeQuery:updateStr];
}

+(void)deleteReceipt:(Receipt*)rcpt{
    NSString* photoPath = [rcpt imagePathOld];
    if ([[NSFileManager defaultManager] fileExistsAtPath:photoPath]){
        NSError* error;
        [[NSFileManager defaultManager] removeItemAtPath: photoPath error: &error];
    }
    
    NSString* deleteStr = [NSString stringWithFormat:@"DELETE FROM receipts WHERE id = %lu ",rcpt.m_primaryKey];
    DBManager* mgr = [[DBManager alloc] initDatabase];
    [mgr executeQuery:deleteStr];
}

+(NSMutableArray*)loadReceipts:(NSInteger)tripId{

    if (false)
    {
        DBManager* mgr = [[DBManager alloc] initDatabase];
        [mgr executeQuery:@"UPDATE receipts SET comment='my comment' WHERE id=1"];
    }
    
    NSString* loadStr = [NSString stringWithFormat:@"select id, trip_id, amount, currency, type, type_order, date, photo, comment from receipts where trip_id = %lu order by date, type_order",tripId];
    
    DBManager* mgr = [[DBManager alloc] initDatabase];
    NSArray* data = [mgr loadDataFromDB:loadStr];
    
    NSMutableArray* retArr = [[NSMutableArray alloc] init];
    for (NSArray* row in data) {
        Receipt* rcpt = [[Receipt alloc] init];
        rcpt.m_primaryKey = [(NSString*)row[0] integerValue];
        rcpt.m_tripKey = [(NSString*)row[1] integerValue];
        rcpt.m_amount = [(NSString*)row[2] floatValue];
        rcpt.m_currency = (NSString*)row[3];
        rcpt.m_expenseType = (NSString*)row[4];
        rcpt.m_expenseTypeOrder = [(NSString*)row[5] integerValue];
        rcpt.m_date = (NSString*)row[6];
        rcpt.m_photo = (NSString*)row[7];

        if ( [(NSString*)row[8] length] > 0)
            rcpt.m_comment = (NSString*)row[15];
        else
            rcpt.m_comment = nil;
        
        [retArr addObject: rcpt];
        
    }
    
    return retArr;
    
}

-(NSString*)imagePathOld{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu/%lu.1.jpg", self.m_tripKey, self.m_primaryKey]];
}

-(NSString*)imagePath:(NSString*)imgId{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu/%lu.%@.jpg", self.m_tripKey, self.m_primaryKey,imgId]];
}

@end

