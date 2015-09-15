//
//  RemitConsts.h
//  TestApp2
//
//  Created by Manish Kumar on 9/12/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RemitConsts : NSObject

+(RemitConsts*)sharedInstance;

-(UIColor*)backgrounColor;
-(NSString*)backgrounTexture;
-(UIColor*)darkBackgrounColor;
+(NSDate*)dateFromStr:(NSString*)str;
+(NSString*)strFromDate:(NSDate*)date;

+(NSInteger)orderForExpenseType:(NSString*)type;


@end
