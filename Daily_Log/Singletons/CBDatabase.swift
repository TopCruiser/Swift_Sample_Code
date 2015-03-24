//
//  CBDatabase.swift
//  Daily_Log
//
//  Created by Tommi on 3/13/15.
//  Copyright (c) 2015 Tommi. All rights reserved.
//

import UIKit

class CBDatabase: NSObject {

    let API_URL = "http://kanler.com/api/v1/"
    
    struct STATICVALUES {
        static var onceToken :  dispatch_once_t = 0
        static var sharedInstance : CBDatabase!
    }
    
    class func sharedInstance() -> CBDatabase!
    {
        dispatch_once(&STATICVALUES.onceToken, { () -> Void in
          STATICVALUES.sharedInstance = CBDatabase()
        })
        
        return STATICVALUES.sharedInstance
    }
    
    func authUserWithEmail(email : String, password : String, callback : Selector, delegate : AnyObject )
    {
        var url = "auth/" as String
        var data = [ "user_email" : email,  "user_password" : password ]  as NSDictionary
        self.makePOSTRequestToEndpoint(url, withData: data, withCallback: callback, withDelegate: delegate)
    }

    func fetchProjectsWithCallback (callback : Selector, delegate : AnyObject)
    {
        var url = "logging/projects/" as String
        self.makeGETRequestToEndpoint(url, withCallback: callback, withDelegate: delegate)
    }

    func updateProject(projectId : NSNumber, data : NSDictionary, callback : Selector, delegate : AnyObject)
    {
        var url = "logging/projects/\(projectId.stringValue)" as String
        self.makePUTRequestToEndpoint(url, withData: data, withCallback:callback, withDelegate: delegate)
    }
    
    func addLogToProject(projectId : NSNumber, data : NSDictionary, callback : Selector, delegate : AnyObject)
    {
        var url = "logging/projects/" as String
        self.makePOSTRequestToEndpoint(url, withData: data, withCallback: callback, withDelegate: delegate)
    }

    func makeGETRequestToEndpoint(url : String, withCallback callback : Selector, withDelegate delegate : AnyObject)
    {
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.allZeros)
        
        var store = UICKeyChainStore()
        if(store["token"] != nil)
        {
            manager.requestSerializer.setValue(store["token"], forHTTPHeaderField: "X-USER-TOKEN")
            manager.requestSerializer.setValue(store["email"], forHTTPHeaderField: "X-USER-EMAIL")
        }
        
        manager.GET(API_URL + url, parameters: nil, success: { (operation : AFHTTPRequestOperation!, responseObject : AnyObject!) -> Void in
                let delay = 0.0
                println("response = \(responseObject)")
                NSTimer.scheduledTimerWithTimeInterval(delay, target: delegate, selector: callback, userInfo: responseObject , repeats: false)
            }) { (operation : AFHTTPRequestOperation!, error : NSError!) -> Void in
                println(error)
        }
    }

    func makePOSTRequestToEndpoint(url : String, withData data : NSDictionary , withCallback callback : Selector, withDelegate delegate : AnyObject)
    {
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.allZeros)
        manager.requestSerializer = AFJSONRequestSerializer(writingOptions: NSJSONWritingOptions.allZeros)
        
        var store = UICKeyChainStore()
        if(store["token"] != nil)
        {
            manager.requestSerializer.setValue(store["token"], forHTTPHeaderField: "X-USER-TOKEN")
            manager.requestSerializer.setValue(store["email"], forHTTPHeaderField: "X-USER-EMAIL")
        }
        
        var error : NSError?
        var jsonData = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
        var jsonString : NSString! = ""
        if( jsonData == nil )
        {
            println("Got an error: \(error)")
        }
        else
        {
            jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)
            println("json string : \(jsonString)")
        }
        
        var objectData = jsonString.dataUsingEncoding(NSUTF8StringEncoding) as NSData!
        var json = NSJSONSerialization.JSONObjectWithData(objectData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary?
        
        manager.POST(API_URL + url, parameters: json, success: { (operation : AFHTTPRequestOperation!, responseObject : AnyObject!) -> Void in
            let delay = 0.0
            NSTimer.scheduledTimerWithTimeInterval(delay, target: delegate, selector: callback, userInfo: ["status" : NSNumber(integer:(operation.response.statusCode)), "response" : responseObject ], repeats: false)

            }) { (operation : AFHTTPRequestOperation!, error :NSError!) -> Void in
                let delay = 0.0
                println("error = \(error)")
                NSTimer.scheduledTimerWithTimeInterval(delay, target: delegate, selector: callback, userInfo: ["status" : NSNumber(integer:(operation.response.statusCode)), "response" : error ], repeats: false)
        }
        
    }
    
    func makePUTRequestToEndpoint(url : String, withData data : NSDictionary , withCallback callback : Selector, withDelegate delegate : AnyObject)
    {
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.allZeros)
        manager.requestSerializer = AFJSONRequestSerializer(writingOptions: NSJSONWritingOptions.allZeros)
        
        var store = UICKeyChainStore()
        if(store["token"] != nil)
        {
            manager.requestSerializer.setValue(store["token"], forHTTPHeaderField: "X-USER-TOKEN")
            manager.requestSerializer.setValue(store["email"], forHTTPHeaderField: "X-USER-EMAIL")
        }
        
        manager.PUT(API_URL + url, parameters: data, success: { (operation : AFHTTPRequestOperation!, responseObject : AnyObject!) -> Void in
                let delay = 0.0
                NSTimer.scheduledTimerWithTimeInterval(delay, target: delegate, selector: callback, userInfo: ["status" : NSNumber(integer:(operation.response.statusCode)), "response" : responseObject ], repeats: false)
            
            }) { (operation : AFHTTPRequestOperation!, error : NSError!) -> Void in
                let delay = 0.0
                NSTimer.scheduledTimerWithTimeInterval(delay, target: delegate, selector: callback, userInfo: ["status" : NSNumber(integer:(operation.response.statusCode)), "response" : error ], repeats: false)
        }
    }
}


