//
//  PDFHelper.h
//  TestApp2
//
//  Created by Manish Kumar on 8/27/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#ifndef TestApp2_PDFHelper_h
#define TestApp2_PDFHelper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PDF : NSObject{
}
@property(nonatomic, readwrite) CGSize size;
@property(nonatomic, strong) NSMutableArray *headerRect;

@property(nonatomic, strong) NSMutableArray *header;

@property(nonatomic, strong) NSMutableArray *imageArray;
@property(nonatomic, strong) NSMutableArray *imageRectArray;

@property(nonatomic, strong) NSMutableArray *textArray;
@property(nonatomic, strong) NSMutableArray *textRectArray;

@property(nonatomic, strong)  NSMutableData *data;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
// i metodi vanno invocati nel seguente ordine:
-(void)initContent;
-(void)addImageWithRect:(UIImage*)image inRect:(CGRect)rect;
-(void)addTextWithRect:(NSString*)text inRect:(CGRect)rect;
-(void)addHeadertWithRect:(NSString *)text inRect:(CGRect)rect;

- (void) drawText;
- (void) drawHeader;
- (void) drawImage;
- (NSMutableData*) generatePdfWithFilePath: (NSString *)thefilePath;

-(void)beginPDF: (NSString *)thefilePath;
-(void)writeOnNewPage;
-(void)endPDF;
@end

#endif

