//
//  CBUtils.h
//  Daily Log
//
//  Created by Ayush Sood on 10/15/14.
//  Copyright (c) 2014 Kanler Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBUtils : NSObject

/**
 Returns an instance of a UITextField that has left and right padding of 20px.
 Author: ayush
 
 @param frame The frame that defines the bounds of this UITextField
 @param placeholder The placeholder text for the UITextfield
 
 @return (UITextField *) an instance of UITextField with left and right padding
 of 20px
 */
+ (UITextField *)paddedTextFieldWithFrame:(CGRect)frame
                           andPlaceholder:(NSString *)placeholder;

+ (UIColor *)alizarinColor;
+ (UIColor *)cloudsColor;

+ (void)showMessage:alertText withTitle:alertTitle withDelegate:delegate;

@end
