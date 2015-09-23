//
//  ReceiptImage.m
//  Remit Joy
//
//  Created by KUMAR Manish on 9/14/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import "ReceiptImage.h"

@implementation ReceiptImageData


@end

@implementation ReceiptImage

-(id)init{
    self = [super init];
    self.m_imageDataArr = [[NSMutableArray alloc] init];
    return self;
}

-(void)load:(NSString*)photoStr receipt:(Receipt*)theReceipt {
    NSArray* arr = [photoStr componentsSeparatedByString:@","];
    
    for (NSString* indexStr in arr) {
        ReceiptImageData* data = [[ReceiptImageData alloc] init];
        
        NSString* imgPath = [theReceipt imagePath:indexStr];
        UIImage* img = [UIImage imageWithContentsOfFile:imgPath];
        UIImageOrientation orientation = img.imageOrientation;
        if (orientation != UIImageOrientationUp){
            data.m_image = [UIImage imageWithCGImage:[img CGImage]
                            scale:1.0
                      orientation: UIImageOrientationUp];
        }
        else
            data.m_image = img;
        
        data.m_isNew = false;
        data.m_id = [indexStr integerValue];
        
        [self.m_imageDataArr addObject:data];
        self.m_nextId = data.m_id + 1;
    }
    
}

-(void)addNewImage:(UIImage*)image{
    ReceiptImageData* data = [[ReceiptImageData alloc] init];
    
    data.m_image = image;
    data.m_isNew = true;
    data.m_id = self.m_nextId;
    [self.m_imageDataArr addObject:data];

    self.m_nextId++;
}

-(void)deleteImageAt:(NSInteger)index{
    [self.m_imageDataArr removeObjectAtIndex:index];
}

-(NSString*)getPhotoStr{
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    for (ReceiptImageData* data in self.m_imageDataArr) {
        [arr addObject:[NSString stringWithFormat:@"%lu", data.m_id]];
    }
    
    return [arr componentsJoinedByString:@","];
}
@end
