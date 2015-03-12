//
//  LoginViewController.swift
//  Daily_Log
//
//  Created by Tommi on 3/12/15.
//  Copyright (c) 2015 Tommi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

//    CGSize screenSize;
//    UITextField *loginEmail;
//    UITextField *loginPassword;
//    UIButton *loginButton;

    var screenSize : CGSize!
    var loginEmail : UITextField!
    var loginPassword : UITextField!
    var loginButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        screenSize = [[UIScreen mainScreen] bounds].size;
//        self.view.backgroundColor = [CBUtils cloudsColor];
//        
//        UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(360, 225, 100, 50)];
//        loginLabel.text = @"Login";
//        loginLabel.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:40];
//        loginLabel.textColor = [CBUtils alizarinColor];
//        [self.view addSubview:loginLabel];
//        
//        loginEmail = [CBUtils paddedTextFieldWithFrame:CGRectMake(360, 285, 300, 40)
//        andPlaceholder:@"Email"];
//        [loginEmail setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//        [self.view addSubview:loginEmail];
//        
//        loginPassword = [CBUtils paddedTextFieldWithFrame:CGRectMake(360, 335, 300, 40)
//        andPlaceholder:@"Password"];
//        [loginPassword setSecureTextEntry:YES];
//        [self.view addSubview:loginPassword];
//        
//        loginButton = [[UIButton alloc] initWithFrame:CGRectMake(360, 385, 300, 40)];
//        loginButton.backgroundColor = [CBUtils alizarinColor];
//        [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
//        [loginButton addTarget:self action:@selector(loginButtonPress)
//        forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:loginButton];
        
        screenSize = UIScreen.mainScreen().bounds.size;
        self.view.backgroundColor = CBUtils.cloudsColor()
        
        var loginLabel = UILabel(frame: CGRectMake(360, 225, 100, 50)) as UILabel!
        loginLabel.text = "Login"
        loginLabel.font = UIFont(name: "RobotoCondensed-Regular", size: 40)
        loginLabel.textColor = CBUtils.alizarinColor()
        self.view.addSubview(loginLabel)
        
        loginEmail = CBUtils.paddedTextFieldWithFrame(CGRectMake(360, 285, 300, 40), andPlaceholder: "Email") as UITextField!
        loginEmail.autocapitalizationType = UITextAutocapitalizationType.None
        self.view .addSubview(loginEmail)
        
        loginPassword = CBUtils.paddedTextFieldWithFrame(CGRectMake(360, 335, 300, 40), andPlaceholder: "Password") as UITextField!
        loginPassword.secureTextEntry = true
        self.view .addSubview(loginPassword)
        
        loginButton = UIButton(frame: CGRectMake(360, 385, 300, 40))
        loginButton.backgroundColor = CBUtils.alizarinColor()
        loginButton.setTitle("Log In", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "loginButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginButton)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    
    func loginButtonPress()
    {
//        CBDatabase *db = [CBDatabase sharedInstance];
//        [db authUserWithEmail:loginEmail.text password:loginPassword.text callback:@selector(loginCallback:) delegate:self];
//        
//        CBSpinner *spinner = [CBSpinner sharedSpinner];
//        [spinner setMessage:@"Logging in..."];
//        [self.view addSubview:spinner];
//        
//        [self.view setUserInteractionEnabled:NO];
        
        var db = CBDatabase.sharedInstance() as CBDatabase!
        db.authUserWithEmail(loginEmail.text, password: loginPassword.text, callback: Selector("loginCallback:"), delegate: self)
        
        var spinner = CBSpinner.sharedSpinner() as CBSpinner!
        spinner.setMessage("Logging in...")
        self.view.addSubview(spinner)
        
        self.view.userInteractionEnabled = false
    }
    
    func loginCallback(data : NSDictionary)
    {
//        CBSpinner *spinner = [CBSpinner sharedSpinner];
//        [spinner removeFromSuperview];
//        [self.view setUserInteractionEnabled:YES];
//        
//        if ([data[@"status"] intValue] == 200) {
//        UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
//        store[@"token"] = data[@"response"][@"token"];
//        store[@"email"] = loginEmail.text;
//        [store synchronize];
//        NSLog(@"%@", store);
//        [self dismissViewControllerAnimated:YES completion:nil];
//        } else {
//        [CBUtils showMessage:@"Your username and password is incorrect" withTitle:@"Error" withDelegate:self];
//        }
        
        var spinner = CBSpinner.sharedSpinner() as CBSpinner!
        spinner.removeFromSuperview()
        self.view.userInteractionEnabled = true
        
        if (data.objectForKey("status")?.intValue == 200)
        {
            // TODO:
            var store = UICKeyChainStore() as UICKeyChainStore!
            store["token"] = data.objectForKey("response")?.objectForKey("token") as String
            store["email"] = loginEmail.text
            store.synchronize()
            
            NSLog("%@", store)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            CBUtils.showMessage("Your username and password is incorrect", withTitle: "Error", withDelegate: self)
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
