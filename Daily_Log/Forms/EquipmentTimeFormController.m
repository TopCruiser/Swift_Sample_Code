//
//  EquipmentTimeFormController.m
//  Daily Log
//
//  Created by Ayush Sood on 10/15/14.
//  Copyright (c) 2014 Kanler Inc. All rights reserved.
//
#import <objc/runtime.h>

#import "EquipmentTimeFormController.h"
#import "XLForm.h"
//#import "CBUtils.h"
#import <Daily_Log-Swift.h>

@implementation EquipmentTimeFormController {
    XLFormRowDescriptor *equipment;
    XLFormRowDescriptor *hrs;
}

@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;

- (id)init
{
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"Equipment Rental"];
    XLFormSectionDescriptor *section;
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    equipment = [XLFormRowDescriptor formRowDescriptorWithTag:@"equipment" rowType:XLFormRowDescriptorTypeText];
    equipment.required = YES;
    [equipment.cellConfigAtConfigure setObject:@"Equipment Rented" forKey:@"textField.placeholder"];
    [section addFormRow:equipment];

    hrs = [XLFormRowDescriptor formRowDescriptorWithTag:@"hrs" rowType:XLFormRowDescriptorTypeStepCounter title:@"Hrs"];
    hrs.required = YES;
    [section addFormRow:hrs];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    
    return [super initWithForm:form];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *formValues = objc_getAssociatedObject(_rowDescriptor, @"formValues");
    if (formValues) {
        equipment.value = formValues[@"equipment"];
        hrs.value = formValues[@"hrs"];
    }
}

- (void)savePressed:(UIBarButtonItem *)button
{
    if (self.formValidationErrors.count) {
        [CBUtils showMessage:@"All fields are required." withTitle:@"Error" withDelegate:self];
    } else {
        NSDictionary *formValues = [self formValues];
        objc_setAssociatedObject(_rowDescriptor, @"formValues", formValues, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _rowDescriptor.value = [NSString stringWithFormat:@"%@ (%d Hrs)", formValues[@"equipment"], [formValues[@"hrs"] intValue]];
        [self dismiss];
    }
}

- (void)dismiss
{
    [__popoverController dismissPopoverAnimated:YES];
    [__popoverController.delegate popoverControllerDidDismissPopover:__popoverController];
}

@end