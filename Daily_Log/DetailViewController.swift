//
//  DetailViewController.swift
//  Daily_Log
//
//  Created by Tommi on 3/12/15.
//  Copyright (c) 2015 Tommi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var log : NSDictionary!
    var mainForm : MainFormController!
    var sideForm : SideFormController!
    var screenSize : CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        screenSize = UIScreen.mainScreen().bounds.size
        self.reloadView()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var store = UICKeyChainStore() as UICKeyChainStore!
        if store["token"] == nil
        {
            var vc = LoginViewController() as LoginViewController
            self.presentViewController(vc, animated: true, completion: nil)
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Functions
    
    func reloadView()
    {
        let subViews =  self.view.subviews
        for subview in subViews
        {
            subview.removeFromSuperview()
        }
        
        if log != nil
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("savePressed"))
            
            mainForm = MainFormController(projectName: log.objectForKey("projectName") as String!)
            mainForm.view.frame = CGRectMake(0, 64, screenSize.width - 300, screenSize.height - 64)
            self.addChildViewController(mainForm)
            self.view.addSubview(mainForm.view)
            mainForm.didMoveToParentViewController(self)
            
            sideForm = SideFormController()
            sideForm.view.frame = CGRectMake(screenSize.width - 300, 64, 300, screenSize.height - 64)
            self.addChildViewController(sideForm)
            self.view.addSubview(sideForm.view)
            sideForm.didMoveToParentViewController(self)
        }
        else
        {
            self.view.backgroundColor = CBUtils.cloudsColor()
            var noLogLabel = UILabel(frame: CGRectMake(175, 350, 700, 50)) as UILabel!
            noLogLabel.text = "Select project to view or create a log entry"
            noLogLabel.font = UIFont(name: "RobotoCondensed-Regular", size: 40) as UIFont!
            noLogLabel.textColor = CBUtils.alizarinColor()
            self.view.addSubview(noLogLabel)
        }
    }
    
    func savePressed()
    {
        
        if (mainForm.formValidationErrors().count > 0 || sideForm.formValidationErrors().count > 0)
        {
            CBUtils.showMessage("You are missing some required fields.", withTitle: "Error", withDelegate: self)
        }
        else
        {
            var formValues : NSMutableDictionary = NSMutableDictionary()
            formValues .addEntriesFromDictionary(mainForm.formValues())
            
            var date = formValues.objectForKey("date") as String
            formValues.removeObjectForKey("date")
            
            formValues.addEntriesFromDictionary(NSDictionary(object: date, forKey: "date"))
            
            formValues.addEntriesFromDictionary(sideForm.formValues())
            
            var db = CBDatabase.sharedInstance() as CBDatabase!
            db.addLogToProject(NSNumber(integer: log.objectForKey("projectName")?.integerValue as NSInteger!), data: formValues, callback: Selector("dataSavedCallback:"), delegate: self)
            
            var spinner = CBSpinner.sharedSpinner() as CBSpinner!
            spinner.setMessage("Saving...")
            self.view .addSubview(spinner)
            
            self.view.userInteractionEnabled = false
        }

    }
    
    func dataSavedCallback(data : NSDictionary)
    {
        
        var spinner = CBSpinner.sharedSpinner() as CBSpinner!
        spinner.removeFromSuperview()
        self.view.userInteractionEnabled = true
        
        if (data.objectForKey("status")?.intValue == 200)
        {
            CBUtils.showMessage("Data saved successfully.", withTitle: "Success", withDelegate: self)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            CBUtils.showMessage("There is some problem while saving your data. Please try again.", withTitle: "Error", withDelegate: self)
        }
    }
}
