//
//  CBDatabase.h
//  Daily Log
//
//  Created by Ayush Sood on 10/15/14.
//  Copyright (c) 2014 Kanler Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBDatabase : NSObject

+ (CBDatabase *)sharedInstance;

- (void)authUserWithEmail:(NSString *)email password:(NSString *)password callback:(SEL)callback delegate:(id)delegate;
- (void)fetchProjectsWithCallback:(SEL)callback delegate:(id)delegate;
- (void)updateProject:(NSNumber *)projectId data:(NSDictionary *)data callback:(SEL)callback delegate:(id)delegate;
- (void)addLogToProject:(NSNumber *)projectId data:(NSDictionary *)data callback:(SEL)callback delegate:(id)delegate;

@end
