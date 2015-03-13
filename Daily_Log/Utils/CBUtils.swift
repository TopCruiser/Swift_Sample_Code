//
//  CBUtils.swift
//  Daily_Log
//
//  Created by Tommi on 3/12/15.
//  Copyright (c) 2015 Tommi. All rights reserved.
//

import UIKit

@objc class CBUtils: NSObject {

    class func paddedTextFieldWithFrame(frame : CGRect, andPlaceholder : NSString) -> UITextField
    {
        var textField = UITextField(frame: frame) as UITextField!
        textField.backgroundColor = UIColor.whiteColor()
        textField.placeholder = andPlaceholder
        textField.leftViewMode = UITextFieldViewMode.Always
        textField.rightViewMode = UITextFieldViewMode.Always
        textField.leftView = UIView(frame: CGRectMake(0, 0, 20, 40))
        textField.rightView = UIView(frame: CGRectMake(0, 0, 20, 40))
        return textField
    }

    class func showMessage(alertText : NSString, withTitle : NSString, withDelegate : AnyObject)
    {
        UIAlertView(title: alertText, message: withTitle, delegate: withDelegate, cancelButtonTitle: "OK").show()
    }
    

    class func alizarinColor() -> UIColor
    {
        return UIColor(red: (231.0/255.0), green: (76.0/255.0), blue: (60.0/255.0), alpha: 1.0)
    }
    

    class func cloudsColor() -> UIColor
    {
        return UIColor(red: (236.0/255.0), green: (240.0/255.0), blue: (241.0/255.0), alpha: 1.0)
    }
    
}
