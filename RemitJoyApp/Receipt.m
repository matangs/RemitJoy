//
//  Receipt.m
//  TestApp2
//
//  Created by Manish Kumar on 9/5/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "Receipt.h"
#import "DBManager.h"

@implementation Receipt


-(void)saveReceipt{
    NSString* insertStr = [NSString stringWithFormat:@"insert into receipts (trip_id, amount, currency, type, date, photo1) values(%lu, %.02f, '%@', '%@', '%@','test')",
                           self.m_tripKey,
                           self.m_amount,
                           self.m_currency,
                           self.m_expenseType,
                           self.m_date];
    
    DBManager* mgr = [[DBManager alloc] initDatabase];
    [mgr executeQuery:insertStr];
    
    self.m_primaryKey = [mgr lastInsertedRowID];
    
}

-(void)updateReceipt{
    NSString* updateStr = [NSString stringWithFormat:@"UPDATE receipts SET amount = %.02f, currency = '%@', type = '%@', date = '%@' WHERE id = %lu",
                           self.m_amount,
                           self.m_currency,
                           self.m_expenseType,
                           self.m_date,
                           self.m_primaryKey
                           ];
    DBManager* mgr = [[DBManager alloc] initDatabase];
    [mgr executeQuery:updateStr];
}

+(void)deleteReceipt:(Receipt*)rcpt{
    NSString* photoPath = [rcpt imagePath];
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
    
    NSString* loadStr = [NSString stringWithFormat:@"select id, trip_id, amount, currency, type, type_order, date, photo1, info1, photo2, info2, photo3, info3, photo4, info4, comment from receipts where trip_id = %lu order by date, type_order",tripId];
    
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
        rcpt.m_photo1 = (NSString*)row[7];

        if ( [(NSString*)row[8] length] > 0)
            rcpt.m_info1 = [(NSString*)row[8] integerValue];
        else
            rcpt.m_info1 = 0;
        
        if ( [(NSString*)row[9] length] > 0)
            rcpt.m_photo2 = (NSString*)row[9];
        else
            rcpt.m_photo2 = nil;
        
        if ( [(NSString*)row[10] length] > 0)
            rcpt.m_info2 = [(NSString*)row[10] integerValue];
        else
            rcpt.m_info2 = 0;
        
        if ( [(NSString*)row[11] length] > 0)
            rcpt.m_photo3 = (NSString*)row[11];
        else
            rcpt.m_photo3 = nil;
        
        if ( [(NSString*)row[12] length] > 0)
            rcpt.m_info3 = [(NSString*)row[12] integerValue];
        else
            rcpt.m_info3 = 0;
        
        if ( [(NSString*)row[13] length] > 0)
            rcpt.m_photo4 = (NSString*)row[13];
        else
            rcpt.m_photo4 = nil;
        
        if ( [(NSString*)row[14] length] > 0)
            rcpt.m_info4 = [(NSString*)row[14] integerValue];
        else
            rcpt.m_info4 = 0;
        
        if ( [(NSString*)row[15] length] > 0)
            rcpt.m_comment = (NSString*)row[15];
        else
            rcpt.m_comment = nil;
        
        [retArr addObject: rcpt];
    }
    
    return retArr;
    
}

-(NSString*)imagePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu/%lu.1.jpg", self.m_tripKey, self.m_primaryKey]];
}


@end

