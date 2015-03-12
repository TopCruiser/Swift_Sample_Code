//
//  MainFormController.m
//  Daily Log
//
//  Created by Ayush Sood on 10/13/14.
//  Copyright (c) 2014 Kanler Inc. All rights reserved.
//
#import <objc/runtime.h>

#import "MainFormController.h"
#import "XLForm.h"
#import "ExtraWorkFormController.h"
#import "EquipmentRentalFormController.h"

@interface MainFormController ()

@end

@implementation MainFormController

#pragma mark - Managing the detail item

- (id)initWithProjectName:(NSString *)name
{
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@""];
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;

    section = [XLFormSectionDescriptor formSectionWithTitle:@"Basic Information"];
    [form addFormSection:section];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"job_name" rowType:XLFormRowDescriptorTypeText];
    row.value = name;
    row.disabled = YES;
    [row.cellConfigAtConfigure setObject:@"Job Name" forKey:@"textField.placeholder"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"job_num" rowType:XLFormRowDescriptorTypeNumber];
    row.required = YES;
    [row.cellConfigAtConfigure setObject:@"Job Number" forKey:@"textField.placeholder"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"date" rowType:XLFormRowDescriptorTypeDateInline title:@"Date"];
    row.required = YES;
    row.value = [NSDate new];
    [section addFormRow:row];

    section = [XLFormSectionDescriptor formSectionWithTitle:@"Work Performed Today" multivaluedSection:YES];
    section.multiValuedTag = @"work_performed";
    [form addFormSection:section];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:nil];
    [[row cellConfig] setObject:@"Add new work item..." forKey:@"textField.placeholder"];
    [section addFormRow:row];

    section = [XLFormSectionDescriptor formSectionWithTitle:@"Problems and Delays" multivaluedSection:YES];
    section.multiValuedTag = @"problems_delays";
    [form addFormSection:section];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:nil];
    [[row cellConfig] setObject:@"Add new problem or delay..." forKey:@"textField.placeholder"];
    [section addFormRow:row];

    section = [XLFormSectionDescriptor formSectionWithTitle:@"Sub-Contractor Progress" multivaluedSection:YES];
    section.multiValuedTag = @"sub_contractor_progress";
    [form addFormSection:section];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:nil];
    [[row cellConfig] setObject:@"Add new progress item..." forKey:@"textField.placeholder"];
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Extra Work" multivaluedSection:YES];
    section.multiValuedTag = @"extra_work";
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"extra_work" rowType:XLFormRowDescriptorTypeSelectorPopover title:@""];
    row.selectorControllerClass = [ExtraWorkFormController class];
    [section addFormRow:row];

    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Equipment Rental" multivaluedSection:YES];
    section.multiValuedTag = @"equipment_rental";
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"equipment_rental" rowType:XLFormRowDescriptorTypeSelectorPopover title:@""];
    row.selectorControllerClass = [EquipmentRentalFormController class];
    [section addFormRow:row];

    return [super initWithForm:form];
}

- (NSDictionary *)formValues
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (XLFormSectionDescriptor *section in self.form.formSections) {
        if (!section.isMultivaluedSection) {
            for (XLFormRowDescriptor *row in section.formRows) {
                if (row.tag && ![row.tag isEqualToString:@""]) {
                    [result setObject:(row.value ?: [NSNull null]) forKey:row.tag];
                }
            }
        }
        else{
            NSMutableArray *multiValuedValuesArray = [NSMutableArray new];
            for (XLFormRowDescriptor *row in section.formRows) {
                if (row.value) {
                    NSDictionary *associatedVal = objc_getAssociatedObject(row, @"formValues");
                    if (associatedVal) {
                        [multiValuedValuesArray addObject:associatedVal];
                    } else {
                        [multiValuedValuesArray addObject:row.value];
                    }
                }
            }
            [result setObject:multiValuedValuesArray forKey:section.multiValuedTag];
        }
    }
    return result;
}

@end
