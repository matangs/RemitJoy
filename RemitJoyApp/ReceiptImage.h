//
//  ReceiptImage.h
//  Remit Joy
//
//  Created by KUMAR Manish on 9/14/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Receipt.h"

@interface ReceiptImageData : NSObject

@property (strong, nonatomic) UIImage* m_image;
@property BOOL m_isNew;
@property NSInteger m_id;

@end

@interface ReceiptImage : NSObject

@property (strong, nonatomic) NSMutableArray* m_imageDataArr;
@property NSInteger m_nextId;

-(void)load:(NSString*)photoStr  receipt:(Receipt*)theReceipt;
-(void)addNewImage:(UIImage*)image;
-(void)deleteImageAt:(NSInteger)index;
-(NSString*)getPhotoStr;

@end
