//
//  CBSpinner.m
//  Daily Log
//
//  Created by Ayush Sood on 10/15/14.
//  Copyright (c) 2014 Kanler Inc. All rights reserved.
//

#import "CBSpinner.h"

@implementation CBSpinner {
    UILabel *messageLabel;
}

/**
 Returns a spinner singleton for the application. If a shared static spinner
 doesn't exist, creates one using GCD. Returns an instace of the spinner. The
 user is responsible for setting a message with the setter below.
 Author: ayush

 @return (id) the instance of the CBSpinner
 */
+ (id)sharedSpinner {
    static CBSpinner *sharedSpinner = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSpinner = [[CBSpinner alloc] initWithMessage:@""];
    });
    return sharedSpinner;
}

/**
 Responsible for creating an instace of the CBSpinner. Creates neccessary
 subviews.
 Author: ayush

 @param frame The bounding frame for this view.
 @param msg The message to be displayed in the spinner

 @return (id) an instance of the CBSpinner
 */
- (id)initWithFrame:(CGRect)frame andMessage:(NSString *)msg
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setOpaque:YES];
        [self setAlpha:0.6];
        [self.layer setCornerRadius:15.0f];
        [self.layer setMasksToBounds:YES];

        UIActivityIndicatorView *activityIndicatorView =
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView startAnimating];
        [activityIndicatorView setCenter:CGPointMake(50, 45)];
        [self addSubview:activityIndicatorView];

        messageLabel =
            [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 80, 20)];
        messageLabel.text = msg;
        [messageLabel setTextColor:[UIColor whiteColor]];
        [messageLabel setFont:[UIFont fontWithName:@"JosefinSans" size:13]];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:messageLabel];
    }
    return self;
}

/**
 A wrapper used to initialize an instance of the CBSpinner with the default
 frame size.
 Author: ayush

 @param msg The message to be displayed in the spinner

 @return (id) an instance of the CBSpinner
 */
- (id)initWithMessage:(NSString *)msg
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame = CGRectMake((screenSize.width - 100)/2,
                              (screenSize.height - 100)/2, 100, 100);
    return [self initWithFrame:frame andMessage:msg];
}

/**
 Sets the message for an instance of the spinner. Sets the label subview's text.
 Author: ayush

 @param msg The message to be displayed in the spinner
 */
- (void)setMessage:(NSString *)msg
{
    messageLabel.text = msg;
}

/**
 Removes the spinner view from its parent view. This should be called from the
 parent before the parent is popped or dealloced.
 Author: ayush
 */
- (void)removeFromView
{
    [self removeFromSuperview];
}

@end
