//
//  EquipmentRentalFormController.m
//  Daily Log
//
//  Created by Ayush Sood on 10/15/14.
//  Copyright (c) 2014 Kanler Inc. All rights reserved.
//
#import <objc/runtime.h>

#import "EquipmentRentalFormController.h"
#import "XLForm.h"
//#import "CBUtils.h"
#import <Daily_Log-Swift.h>

@implementation EquipmentRentalFormController {
    XLFormRowDescriptor *equipment;
    XLFormRowDescriptor *rentedFrom;
    XLFormRowDescriptor *rate;
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
    
    rentedFrom = [XLFormRowDescriptor formRowDescriptorWithTag:@"rented_from" rowType:XLFormRowDescriptorTypeText];
    rentedFrom.required = YES;
    [rentedFrom.cellConfigAtConfigure setObject:@"Rented From" forKey:@"textField.placeholder"];
    [section addFormRow:rentedFrom];
    
    rate = [XLFormRowDescriptor formRowDescriptorWithTag:@"rate" rowType:XLFormRowDescriptorTypeDecimal title:@"Rate ($)"];
    rate.required = YES;
    [section addFormRow:rate];
    
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
        rentedFrom.value = formValues[@"rented_from"];
        rate.value = formValues[@"rate"];
    }
}

- (void)savePressed:(UIBarButtonItem *)button
{
    if (self.formValidationErrors.count) {
        [CBUtils showMessage:@"All fields are required." withTitle:@"Error" withDelegate:self];
    } else {
        NSDictionary *formValues = [self formValues];
        objc_setAssociatedObject(_rowDescriptor, @"formValues", formValues, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _rowDescriptor.value = [NSString stringWithFormat:@"%@ - %@ @ $%g", formValues[@"equipment"], formValues[@"rented_from"], [formValues[@"rate"] floatValue]];
        [self dismiss];
    }
}

- (void)dismiss
{
    [__popoverController dismissPopoverAnimated:YES];
    [__popoverController.delegate popoverControllerDidDismissPopover:__popoverController];
}

@end