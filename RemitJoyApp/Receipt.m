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

-(id)copyWithZone:(NSZone *)zone{
    Receipt* rcpt = [[Receipt alloc] init];
    
    rcpt.m_comment = [self.m_comment copyWithZone:zone];
    rcpt.m_currency = [self.m_currency copyWithZone:zone];
    rcpt.m_date = [self.m_date copyWithZone:zone];
    rcpt.m_expenseType = [self.m_expenseType copyWithZone:zone];
    rcpt.m_photo = [self.m_photo copyWithZone:zone];
    
    rcpt.m_amount = self.m_amount;
    rcpt.m_expenseTypeOrder = self.m_expenseTypeOrder;
    rcpt.m_primaryKey = self.m_primaryKey;
    rcpt.m_tripKey = self.m_tripKey;
    
    return rcpt;
}

-(void)transferData:(Receipt*)rcpt{
    self.m_comment = [rcpt.m_comment copy];
    self.m_currency = [rcpt.m_currency copy];
    self.m_date = [rcpt.m_date copy];
    self.m_expenseType = [rcpt.m_expenseType copy];
    self.m_photo = [rcpt.m_photo copy];
    
    self.m_amount = rcpt.m_amount;
    self.m_expenseTypeOrder = rcpt.m_expenseTypeOrder;
    self.m_primaryKey = rcpt.m_primaryKey;
    self.m_tripKey = rcpt.m_tripKey;
}

-(BOOL)isSame:(Receipt*) rcpt{
    if (rcpt.m_amount != self.m_amount || rcpt.m_primaryKey != rcpt.m_primaryKey || rcpt.m_tripKey != self.m_tripKey)
        return false;
    
    if (rcpt.m_comment != self.m_comment && [rcpt.m_comment isEqualToString:self.m_comment] == false)
        return false;

    if (rcpt.m_currency != self.m_currency && [rcpt.m_currency isEqualToString:self.m_currency] == false)
        return false;

    if (rcpt.m_date != self.m_date && [rcpt.m_date isEqualToString:self.m_date] == false)
        return false;

    if (rcpt.m_expenseType != self.m_expenseType && [rcpt.m_expenseType isEqualToString:self.m_expenseType] == false)
        return false;
    
    if (rcpt.m_photo != self.m_photo && [rcpt.m_photo isEqualToString:self.m_photo] == false)
        return false;
    
    return true;
}

-(void)saveReceipt{
    NSInteger typeOrder = [RemitConsts orderForExpenseType:self.m_expenseType];
    
    NSString* insertStr = [NSString stringWithFormat:@"insert into receipts (trip_id, amount, currency, type, type_order, date, photo, comment) values(%lu, %.02f, ?, ?, %lu, ?,?,?)",
                            (long)self.m_tripKey,
                            self.m_amount,
                            (long)typeOrder
                     ];
        
    
    DBManager* mgr = [[DBManager alloc] initDatabase];
    [mgr.m_parameterArray addObject:self.m_currency];
    [mgr.m_parameterArray addObject:self.m_expenseType];
    [mgr.m_parameterArray addObject:self.m_date];
    [mgr.m_parameterArray addObject:self.m_photo];
    if (self.m_comment != nil)
        [mgr.m_parameterArray addObject:self.m_comment];
    else
        [mgr.m_parameterArray addObject:[NSNull null]];
    
    [mgr executeQuery:insertStr];
    
    self.m_primaryKey = (NSInteger)[mgr lastInsertedRowID];
    
}

-(void)updateReceipt{
    NSInteger typeOrder = [RemitConsts orderForExpenseType:self.m_expenseType];

    NSString* updateStr = [NSString stringWithFormat:@"UPDATE receipts SET amount = %.02f, currency = ?, type = ?, date = ?, photo = ?, type_order = %lu, comment = ? WHERE id = %lu",
                     self.m_amount,
                     (long)typeOrder,
                     (long)self.m_primaryKey
                     ];
    
    DBManager* mgr = [[DBManager alloc] initDatabase];
    [mgr.m_parameterArray addObject:self.m_currency];
    [mgr.m_parameterArray addObject:self.m_expenseType];
    [mgr.m_parameterArray addObject:self.m_date];
    [mgr.m_parameterArray addObject:self.m_photo];
    if (self.m_comment != nil)
        [mgr.m_parameterArray addObject:self.m_comment];
    else
        [mgr.m_parameterArray addObject:[NSNull null]];
    
    [mgr executeQuery:updateStr];
}

+(void)deleteReceipt:(Receipt*)rcpt{
    
    NSArray* arr = [rcpt.m_photo componentsSeparatedByString:@","];
    
    for (NSString* indexStr in arr)
    {
        NSString* photoPath = [rcpt imagePath:indexStr];
        if ([[NSFileManager defaultManager] fileExistsAtPath:photoPath]){
            NSError* error;
            [[NSFileManager defaultManager] removeItemAtPath: photoPath error: &error];
        }
    }
    
    NSString* deleteStr = [NSString stringWithFormat:@"DELETE FROM receipts WHERE id = %lu ",(long)rcpt.m_primaryKey];
    DBManager* mgr = [[DBManager alloc] initDatabase];
    [mgr executeQuery:deleteStr];
}

+(NSMutableArray*)loadReceipts:(NSInteger)tripId{

    if (false)
    {
        DBManager* mgr = [[DBManager alloc] initDatabase];
        [mgr executeQuery:@"UPDATE receipts SET comment='my comment' WHERE id=1"];
    }
    
    NSString* loadStr = [NSString stringWithFormat:@"select id, trip_id, amount, currency, type, type_order, date, photo, comment from receipts where trip_id = %lu order by date, type_order",(long)tripId];
    
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
            rcpt.m_comment = (NSString*)row[8];
        else
            rcpt.m_comment = nil;
        
        [retArr addObject: rcpt];
        
    }
    
    return retArr;
    
}

-(NSString*)imagePath:(NSString*)imgId{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu/%lu.%@.jpg", (long)self.m_tripKey, (long)self.m_primaryKey,imgId]];
}

@end

