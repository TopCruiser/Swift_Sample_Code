//
//  ExtraWorkFormController.m
//  Daily Log
//
//  Created by Ayush Sood on 10/15/14.
//  Copyright (c) 2014 Kanler Inc. All rights reserved.
//
#import <objc/runtime.h>

#import "ExtraWorkFormController.h"
#import "XLForm.h"
#import "CBUtils.h"

@implementation ExtraWorkFormController {
    XLFormRowDescriptor *work;
    XLFormRowDescriptor *authorizedBy;
    XLFormRowDescriptor *price;
}

@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;

- (id)init
{
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"Extra Work"];
    XLFormSectionDescriptor *section;
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    work = [XLFormRowDescriptor formRowDescriptorWithTag:@"work" rowType:XLFormRowDescriptorTypeText];
    work.required = YES;
    [work.cellConfigAtConfigure setObject:@"Work description" forKey:@"textField.placeholder"];
    [section addFormRow:work];
    
    authorizedBy = [XLFormRowDescriptor formRowDescriptorWithTag:@"authorized_by" rowType:XLFormRowDescriptorTypeText];
    authorizedBy.required = YES;
    [authorizedBy.cellConfigAtConfigure setObject:@"Authorized By" forKey:@"textField.placeholder"];
    [section addFormRow:authorizedBy];
    
    price = [XLFormRowDescriptor formRowDescriptorWithTag:@"price" rowType:XLFormRowDescriptorTypeDecimal title:@"Price ($)"];
    price.required = YES;
    [section addFormRow:price];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    
    return [super initWithForm:form];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *formValues = objc_getAssociatedObject(_rowDescriptor, @"formValues");
    if (formValues) {
        work.value = formValues[@"work"];
        authorizedBy.value = formValues[@"authorized_by"];
        price.value = formValues[@"price"];
    }
}

- (void)savePressed:(UIBarButtonItem *)button
{
    if (self.formValidationErrors.count) {
        [CBUtils showMessage:@"All fields are required." withTitle:@"Error" withDelegate:self];
    } else {
        NSDictionary *formValues = [self formValues];
        objc_setAssociatedObject(_rowDescriptor, @"formValues", formValues, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _rowDescriptor.value = [NSString stringWithFormat:@"%@ - %@ @ $%g", formValues[@"work"], formValues[@"authorized_by"], [formValues[@"price"] floatValue]];
        [self dismiss];
    }
}

- (void)dismiss
{
    [__popoverController dismissPopoverAnimated:YES];
    [__popoverController.delegate popoverControllerDidDismissPopover:__popoverController];
}


@end
