//
//  WorkerCountFormController.m
//  Daily Log
//
//  Created by Ayush Sood on 10/15/14.
//  Copyright (c) 2014 Kanler Inc. All rights reserved.
//
#import <objc/runtime.h>

#import "WorkerCountFormController.h"
#import "XLForm.h"

@implementation WorkerCountFormController {
    XLFormRowDescriptor *worker;
    XLFormRowDescriptor *num;
}

@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;

- (id)init
{
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"Equipment Rental"];
    XLFormSectionDescriptor *section;
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    worker = [XLFormRowDescriptor formRowDescriptorWithTag:@"worker_type" rowType:XLFormRowDescriptorTypeText];
    [worker.cellConfigAtConfigure setObject:@"Worker Type" forKey:@"textField.placeholder"];
    [section addFormRow:worker];

    num = [XLFormRowDescriptor formRowDescriptorWithTag:@"num" rowType:XLFormRowDescriptorTypeStepCounter title:@"Number"];
    [section addFormRow:num];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    
    return [super initWithForm:form];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *formValues = objc_getAssociatedObject(_rowDescriptor, @"formValues");
    if (formValues) {
        worker.value = formValues[@"worker_type"];
        num.value = formValues[@"num"];
    }
}

- (void)savePressed:(UIBarButtonItem *)button
{
    NSDictionary *formValues = [self formValues];
    objc_setAssociatedObject(_rowDescriptor, @"formValues", formValues, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    _rowDescriptor.value = [NSString stringWithFormat:@"(%d) %@", [formValues[@"num"] intValue], formValues[@"worker_type"]];
    [self dismiss];
}

- (void)dismiss
{
    [__popoverController dismissPopoverAnimated:YES];
    [__popoverController.delegate popoverControllerDidDismissPopover:__popoverController];
}

@end