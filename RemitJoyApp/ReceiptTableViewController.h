//
//  ReceiptTableViewController.h
//  Remit Joy
//
//  Created by KUMAR Manish on 9/13/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Receipt.h"


@interface ReceiptTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource,UIPickerViewDelegate>


@property (weak, nonatomic) UITextField* m_amountText;
@property (weak, nonatomic) UITextField* m_currencyText;
@property (weak, nonatomic) UITextField* m_typeText;
@property (weak, nonatomic) UITextField* m_dateText;


@property(strong, nonatomic) NSArray* currencyArray;
@property(strong, nonatomic) NSArray* typeArray;

@property float m_selAmount;
@property(strong, nonatomic) NSString* m_selCurrency;

@property(strong, nonatomic) NSString* m_selType;
@property(strong, nonatomic) NSDate* m_selDate;

@property(strong, nonatomic) NSMutableArray* m_selImageArray;

@property(strong, nonatomic) UIPickerView* m_currencyTextViewPickerView;
@property(strong, nonatomic) UIToolbar* m_currencyTextViewPickerToolbar;
@property(strong, nonatomic) UIPickerView* m_typeTextViewPickerView;
@property(strong, nonatomic) UIToolbar* m_typeTextViewPickerToolbar;
@property(strong, nonatomic) UIDatePicker* m_datePicker;
@property(strong, nonatomic) UIToolbar* m_datePickerToolbar;

@property(strong, nonatomic) Receipt* m_receipt;

@property BOOL m_isUpdating;
@property(strong, nonatomic) NSURL* m_imageURL;
@property NSInteger m_tripId;



@end
