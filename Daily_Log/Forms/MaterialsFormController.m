//
//  MaterialsFormController.m
//  Daily Log
//
//  Created by Ayush Sood on 10/14/14.
//  Copyright (c) 2014 ; Inc. All rights reserved.
//
#import <objc/runtime.h>

#import "MaterialsFormController.h"
#import "XLForm.h"
//#import "CBUtils.h"
#import <Daily_Log-Swift.h>

@implementation MaterialsFormController {
    XLFormRowDescriptor *item;
    XLFormRowDescriptor *quantity;
    XLFormRowDescriptor *store;
}

@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;

- (id)init
{
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"Material Purchases"];
    XLFormSectionDescriptor *section;

    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    item = [XLFormRowDescriptor formRowDescriptorWithTag:@"item" rowType:XLFormRowDescriptorTypeText];
    item.required = YES;
    [item.cellConfigAtConfigure setObject:@"Item Name" forKey:@"textField.placeholder"];
    [section addFormRow:item];

    quantity = [XLFormRowDescriptor formRowDescriptorWithTag:@"quantity" rowType:XLFormRowDescriptorTypeStepCounter title:@"Quantity"];
    quantity.required = YES;
    [section addFormRow:quantity];

    store = [XLFormRowDescriptor formRowDescriptorWithTag:@"store" rowType:XLFormRowDescriptorTypeText];
    store.required = YES;
    [store.cellConfigAtConfigure setObject:@"Store Name" forKey:@"textField.placeholder"];
    [section addFormRow:store];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];

    return [super initWithForm:form];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *formValues = objc_getAssociatedObject(_rowDescriptor, @"formValues");
    if (formValues) {
        quantity.value = formValues[@"quantity"];
        item.value = formValues[@"item"];
        store.value = formValues[@"store"];
    }
}

- (void)savePressed:(UIBarButtonItem *)button
{
    if (self.formValidationErrors.count) {
        [CBUtils showMessage:@"All fields are required!" withTitle:@"Error" withDelegate:self];
    } else {
        NSDictionary *formValues = [self formValues];
        objc_setAssociatedObject(_rowDescriptor, @"formValues", formValues, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _rowDescriptor.value = [NSString stringWithFormat:@"(%d) %@ - %@", [formValues[@"quantity"] intValue], formValues[@"item"], formValues[@"store"]];
        [self dismiss];
    }
}

- (void)dismiss
{
    [__popoverController dismissPopoverAnimated:YES];
    [__popoverController.delegate popoverControllerDidDismissPopover:__popoverController];
}

@end
