//
//  CBUtils.m
//  Daily Log
//
//  Created by Ayush Sood on 10/15/14.
//  Copyright (c) 2014 Kanler Inc. All rights reserved.
//

#import "CBDatabase.h"
#import "AFHTTPRequestOperationManager.h"
#import "UICKeyChainStore.h"

NSString *const API_URL = @"http://kanler.com/api/v1/";

@implementation CBDatabase

+ (CBDatabase *)sharedInstance {
    static CBDatabase *sharedDB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDB = [[self alloc] init];
    });
    return sharedDB;
}

- (void)authUserWithEmail:(NSString *)email password:(NSString *)password callback:(SEL)callback delegate:(id)delegate
{
    NSString *url = @"auth/";
    NSDictionary *data = @{
                           @"user_email": email,
                           @"user_password": password
                           };
    
    [self makePOSTRequestToEndpoint:url withData:data withCallback:callback withDelegate:delegate];
}

- (void)fetchProjectsWithCallback:(SEL)callback delegate:(id)delegate {
    NSString *url = @"logging/projects/";
    [self makeGETRequestToEndpoint:url withCallback:callback withDelegate:delegate];
}

- (void)updateProject:(NSNumber *)projectId data:(NSDictionary *)data callback:(SEL)callback delegate:(id)delegate {
    NSString *url = [@"logging/projects/" stringByAppendingString:[projectId stringValue]];
    [self makePUTRequestToEndpoint:url withData:data withCallback:callback withDelegate:delegate];
}

- (void)addLogToProject:(NSNumber *)projectId data:(NSDictionary *)data callback:(SEL)callback delegate:(id)delegate
{
    NSString *url = [@"logging/projects/" stringByAppendingString:@""];
    [self makePOSTRequestToEndpoint:url withData:data withCallback:callback withDelegate:delegate];
}

- (void)makeGETRequestToEndpoint:(NSString *)url withCallback:(SEL)callback withDelegate:(id)delegate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    if (store[@"token"] != nil) {
        [manager.requestSerializer setValue:store[@"token"] forHTTPHeaderField:@"X-USER-TOKEN"];
        [manager.requestSerializer setValue:store[@"email"] forHTTPHeaderField:@"X-USER-EMAIL"];
    }
    
    [manager GET:[API_URL stringByAppendingString:url] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSLog(@"response = %@", responseObject);
        [delegate performSelector:callback withObject:responseObject];
#pragma clang diagnostic pop
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        NSLog(@"%@", error);
    }];
}

- (void)makePOSTRequestToEndpoint:(NSString *)url withData:(NSDictionary *)data withCallback:(SEL)callback withDelegate:(id)delegate
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    if (store[@"token"] != nil) {
        [manager.requestSerializer setValue:store[@"token"] forHTTPHeaderField:@"X-USER-TOKEN"];
        [manager.requestSerializer setValue:store[@"email"] forHTTPHeaderField:@"X-USER-EMAIL"];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = @"";
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json string :%@", jsonString);
    }
    
    NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
    [manager POST:[API_URL stringByAppendingString:url] parameters:json success:^(AFHTTPRequestOperation *operation, id responseObject) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [delegate performSelector:callback withObject:@{@"status": [NSNumber numberWithInteger:[operation.response statusCode]], @"response": responseObject}];
#pragma clang diagnostic pop
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSLog(@"error: %@", error);
        [delegate performSelector:callback withObject:@{@"status":[NSNumber numberWithInteger:[operation.response statusCode]], @"response": error}];
#pragma clang diagnostic pop
    }];
}

- (void)makePUTRequestToEndpoint:(NSString *)url withData:(NSDictionary *)data withCallback:(SEL)callback withDelegate:(id)delegate
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    if (store[@"token"] != nil) {
        [manager.requestSerializer setValue:store[@"token"] forHTTPHeaderField:@"X-USER-TOKEN"];
        [manager.requestSerializer setValue:store[@"email"] forHTTPHeaderField:@"X-USER-EMAIL"];
    }
    
    [manager PUT:[API_URL stringByAppendingString:url] parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [delegate performSelector:callback withObject:@{@"status": [NSNumber numberWithInteger:[operation.response statusCode]], @"response": responseObject}];
#pragma clang diagnostic pop
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSLog(@"error: %@", error);
        [delegate performSelector:callback withObject:@{@"status":[NSNumber numberWithInteger:[operation.response statusCode]], @"response": error}];
#pragma clang diagnostic pop
    }];
}

@end
