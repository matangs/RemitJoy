//
//  DatabaseTest.m
//  TestApp2
//
//  Created by Manish Kumar on 9/5/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Trip.h"
#import "Receipt.h"

@interface DatabaseTest : XCTestCase

@property (atomic) NSMutableArray* m_trips;

@end

@implementation DatabaseTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.m_trips = [[NSMutableArray alloc] init];
    
    Trip* trip1 = [[Trip alloc] init];
    trip1.m_name = @"Trip1";
    trip1.m_date = @"08-23-2015";
    [self.m_trips addObject:trip1];
    
    Trip* trip2 = [[Trip alloc] init];
    trip2.m_name = @"Trip2";
    trip2.m_date = @"09-23-2015";
    [self.m_trips addObject:trip2];

    Trip* trip3 = [[Trip alloc] init];
    trip3.m_name = @"Trip3";
    trip1.m_date = @"07-23-2015";
    [self.m_trips addObject:trip3];

    Trip* trip4 = [[Trip alloc] init];
    trip4.m_name = @"Trip4";
    trip4.m_date = @"06-23-2015";
    [self.m_trips addObject:trip4];

    Trip* trip5 = [[Trip alloc] init];
    trip5.m_name = @"Trip5";
    trip5.m_date = @"08-22-2015";
    [self.m_trips addObject:trip5];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
