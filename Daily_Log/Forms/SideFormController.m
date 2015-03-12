//
//  SideFormController.m
//  Daily Log
//
//  Created by Ayush Sood on 10/13/14.
//  Copyright (c) 2014 Kanler Inc. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#import "SideFormController.h"
#import "MaterialsFormController.h"
#import "EquipmentTimeFormController.h"
#import "WorkerCountFormController.h"
#import "XLForm.h"

@interface SideFormController ()

@end

@implementation SideFormController {
    XLFormSectionDescriptor *customSection;
}

#pragma mark - Managing the detail item

-(id)init
{
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;

    section = [XLFormSectionDescriptor formSectionWithTitle:@"Workers" multivaluedSection:YES];
    section.multiValuedTag = @"num_workers";
    customSection = section;
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"num_workers" rowType:XLFormRowDescriptorTypeSelectorPopover title:@""];
    row.selectorControllerClass = [WorkerCountFormController class];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Equipment" multivaluedSection:YES];
    section.multiValuedTag = @"equipment_time";
    customSection = section;
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"equipment_time" rowType:XLFormRowDescriptorTypeSelectorPopover title:@""];
    row.selectorControllerClass = [EquipmentTimeFormController class];
    [section addFormRow:row];

    section = [XLFormSectionDescriptor formSectionWithTitle:@"Materials Purchased" multivaluedSection:YES];
    section.multiValuedTag = @"materials_purchased";
    customSection = section;
    [form addFormSection:section];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"materials_purchased" rowType:XLFormRowDescriptorTypeSelectorPopover title:@""];
    row.selectorControllerClass = [MaterialsFormController class];
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