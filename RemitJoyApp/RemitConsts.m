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

-(UIColor*)backgrounColor{
    return [UIColor colorWithRed:238/256.0 green:238/256.0 blue:243/256.0 alpha:1.0];
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
    [outputFormatter setDateFormat:@"MM-dd-YYYY"];
    return [outputFormatter dateFromString:str];
    
}

+(NSString*)strFromDate:(NSDate*)date{
    NSDateFormatter* outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"MM-dd-YYYY"];
    return [outputFormatter stringFromDate:date];
    
}


@end
