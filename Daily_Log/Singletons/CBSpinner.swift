//
//  CBSpinner.swift
//  
//
//  Created by Tommi on 3/13/15.
//
//

import UIKit

class CBSpinner: UIView {
    var messageLabel : UILabel!
    
    struct STATICVALUES {
        static var onceToken :  dispatch_once_t = 0
        static var sharedSpinner : CBSpinner!
    }
    
    class func sharedSpinner() -> CBSpinner!
    {
        
        dispatch_once(&STATICVALUES.onceToken, { () -> Void in
            STATICVALUES.sharedSpinner = CBSpinner(msg: "")
        });
        
        return STATICVALUES.sharedSpinner
    }
    
    convenience init(msg : NSString)
    {
        var screenSize = UIScreen.mainScreen().bounds.size as CGSize!
        var frame = CGRectMake((screenSize.width - 100) / 2, (screenSize.height - 100) / 2 , 100, 100)
        self.init(frame: frame, andMessage: msg)
    }
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame : CGRect, andMessage msg: NSString)
    {
        super.init(frame: frame)
        if(self != NSNull())
        {
            self.backgroundColor = UIColor.blackColor()
            self.opaque = true
            self.alpha = 0.6
            self.layer.cornerRadius = 15.0
            self.layer.masksToBounds = true
            
            var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.WhiteLarge)
            activityIndicatorView.startAnimating()
            activityIndicatorView.center = CGPointMake(50, 45)
            self .addSubview(activityIndicatorView)
            
            messageLabel = UILabel(frame: CGRectMake(10, 70, 80, 20))
            messageLabel.text = msg
            messageLabel.textColor = UIColor.whiteColor()
            messageLabel.font = UIFont(name: "JosefinSans", size: 13)
            messageLabel.textAlignment = NSTextAlignment.Center
            self.addSubview(messageLabel)
        }
        
    }
    
    func setMessage(msg : NSString)
    {
        messageLabel.text = msg
    }
    
    func removeFromView()
    {
        self.removeFromView()
    }
}
