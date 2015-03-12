//
//  CBSpinner
//  Daily Log
//
//  Created by Ayush Sood on 10/15/14.
//  Copyright (c) 2014 Kanler Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBSpinner : UIView

/**
 Returns a globally shared instance of CBSpinner. The message of the spinner
 should be set using setMessage below. If added to a view, removeFromView must
 be called once before the parent pops or deallocs.
 Author: ayush
 */
+ (id)sharedSpinner;

/**
 Sets the message on the global instance of CBSpinner.

 @param msg The message to be displayed in the spinner
 */
- (void)setMessage:(NSString *)msg;

/**
 Removes the view from the superview.
 */
- (void)removeFromView;

@end
