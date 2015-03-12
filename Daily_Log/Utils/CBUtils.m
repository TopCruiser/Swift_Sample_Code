//
//  CBUtils.m
//  Daily Log
//
//  Created by Ayush Sood on 10/15/14.
//  Copyright (c) 2014 Kanler Inc. All rights reserved.
//

#import "CBUtils.h"

@implementation CBUtils

+ (UITextField *)paddedTextFieldWithFrame:(CGRect)frame
                           andPlaceholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = placeholder;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.leftView =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    textField.rightView =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    return textField;
}

+ (void)showMessage:alertText withTitle:alertTitle withDelegate:delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertText
                                                   delegate:delegate
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (UIColor *)alizarinColor
{
    return [UIColor colorWithRed:(231.0f/255.0) green:(76.0f/255.0) blue:(60.0f/255.0) alpha:1.0f];
}

+ (UIColor *)cloudsColor {
    return [UIColor colorWithRed:(236.0f/255.0) green:(240.0f/255.0) blue:(241.0f/255.0) alpha:1.0f];
}

@end
