//
//  DBManager.h
//  TestApp2
//
//  Created by Manish Kumar on 8/30/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+(DBManager*)sharedInstance;
-(instancetype)initDatabase;

@property (nonatomic, strong) NSMutableArray* m_parameterArray;

@property NSString* const m_databaseFileName;
@property (nonatomic, strong) NSString* m_documentsDirectory;

@property (nonatomic, strong) NSMutableArray *arrResults;
@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(void)copyDatabaseIntoDocumentsDirectory;
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

@end
