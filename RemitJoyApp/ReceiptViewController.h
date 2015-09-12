//
//  AddReceiptViewController.h
//  TestApp2
//
//  Created by Manish Kumar on 8/24/15.
//  Copyright (c) 2015 Manish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Receipt.h"


@interface ReceiptViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource,UIPickerViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *m_receipt1ImgView;
@property (weak, nonatomic) IBOutlet UIPickerView *m_currencyPicker;
@property (weak, nonatomic) IBOutlet UIButton *m_currencyButton;
@property (weak, nonatomic) IBOutlet UITextField *m_currencyTextView;
@property (weak, nonatomic) IBOutlet UITextField *m_typeTextView;
@property (weak, nonatomic) IBOutlet UITextField *m_amountTextView;
@property (weak, nonatomic) IBOutlet UITextField *m_dateTextView;

@property(strong, nonatomic) NSArray* currencyArray;
@property(strong, nonatomic) NSArray* typeArray;
@property(strong, nonatomic) NSString* m_selCurrency;
@property(strong, nonatomic) NSString* m_selType;
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
