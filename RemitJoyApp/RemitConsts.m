//
//  RemitConsts.m
//  TestApp2
//
//  Created by Manish Kumar on 9/12/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "RemitConsts.h"

@implementation RemitConsts

+(RemitConsts*)sharedInstance{
    static RemitConsts* _sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[RemitConsts alloc] init];
    });
    return _sharedInstance;
}

+(UIColor*)navBarColor{
    //light orange
    //return [UIColor colorWithRed:255.0f/255.0f green:229.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    
    // darker orange
    return [UIColor colorWithRed:255.0f/255.0f green:220.0f/255.0f blue:187.0f/255.0f alpha:1.0f];
    
}
-(UIColor*)backgrounColor{
    // default gray
    //return [UIColor colorWithRed:238/256.0 green:238/256.0 blue:243/256.0 alpha:1.0];
    
    // light orange
    return [UIColor colorWithRed:255/255.0 green:248/255.0 blue:240/255.0 alpha:1.0];
}

-(UIColor*)darkBackgrounColor{
    return [UIColor colorWithRed:106/256.0 green:106/256.0 blue:106/256.0 alpha:1.0];
}

-(NSString*)backgrounTexture{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Values" ofType:@"plist"]];
    NSLog(@"dictionary = %@", dictionary);
    return [dictionary objectForKey:@"BackgroundTexture"];
    
}

+(NSDate*)dateFromStr:(NSString*)str{
    NSDateFormatter* outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"MM-dd-yyyy"];
    return [outputFormatter dateFromString:str];
    
}

+(NSString*)strFromDate:(NSDate*)date{
    NSDateFormatter* outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"MM-dd-yyyy"];
    return [outputFormatter stringFromDate:date];
    
}

+(NSInteger)orderForExpenseType:(NSString*)type{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Values" ofType:@"plist"]];
    NSLog(@"dictionary = %@", dictionary);
    NSDictionary* dict = (NSDictionary*)[dictionary objectForKey:@"ExpenseTypeOrder"];
    NSString* valOut = (NSString*)[dict objectForKey:type];
    return [valOut integerValue];
}

+(UIColor*) colorFromRGB:(NSUInteger)rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}



@end
