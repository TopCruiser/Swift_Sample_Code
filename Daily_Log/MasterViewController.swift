//
//  MasterViewController.swift
//  Daily_Log
//
//  Created by Tommi on 3/12/15.
//  Copyright (c) 2015 Tommi. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController : DetailViewController!
    var fetchedResultsController : NSFetchedResultsController!
    var managedObjectContext : NSManagedObjectContext!

    var addButton : UIBarButtonItem!
    var backButton : UIBarButtonItem!
    var projects : NSMutableArray!
    var project: NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        addButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Add, target: self, action:Selector("addButtonPressed"))
        backButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Reply, target: self, action:Selector("backButtonPressed"));
        detailViewController = self.splitViewController?.viewControllers.last?.topViewController as DetailViewController

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var db = CBDatabase.sharedInstance() as CBDatabase!
        db.fetchProjectsWithCallback(Selector("fetchProjectsCallback:"), delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if project != nil
        {
            var data = project.objectForKey("data") as NSDictionary!
            if data != nil
            {
                var logs = data.objectForKey("logos") as NSArray!
                if logs != nil
                {
                        return logs.count
                }
            }
            return 0
        }
        else
        {
            if projects != nil
            {
                return projects.count
            }
            else
            {
                return 0
            }
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if project != nil
        {
            var logs = project.objectForKey("data")?.objectForKey("logos") as NSArray!
            if logs != nil
            {
                cell.textLabel?.text = logs.objectAtIndex(indexPath.row).objectForKey("date") as? String
            }
        }
        else
        {
            cell.textLabel?.text = projects.objectAtIndex(indexPath.row).objectForKey("discussion_number") as? String
        }
        
        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == .Delete {
            // Delete the row from the data source
            let context = fetchedResultsController.managedObjectContext as NSManagedObjectContext
            context .deleteObject(fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
            
            var error :  NSError?
            if context.save(&error) == false
            {
                NSLog("Unresolved error \(error), \(error?.userInfo)")
                abort()
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = backButton
        if project == nil
        {
            project = projects.objectAtIndex(indexPath.row).mutableCopy() as NSMutableDictionary
        }
        self.tableView.reloadData()
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Functions

    func backButtonPressed()
    {
        if project != nil
        {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
            project = nil
            self.tableView.reloadData()
        }
    }
    
    func addButtonPressed()
    {
        detailViewController = self.splitViewController?.viewControllers.last?.topViewController as DetailViewController
        
        detailViewController.log = ["projectName" : project.objectForKey("discussion_number") as String]
        detailViewController.reloadView()
    }
    
    func fetchProjectsCallback(timer : NSTimer)
    {
        var data = timer.userInfo as NSDictionary!
        if data.objectForKey("projects") != nil
        {
            projects = data.objectForKey("projects")?.mutableCopy() as NSMutableArray
            self.tableView.reloadData()
        }
    }
}
