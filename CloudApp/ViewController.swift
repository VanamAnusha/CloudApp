//
//  ViewController.swift
//  CloudApp
//
//  Created by Anusha on 8/17/16.
//  Copyright © 2016 Anusha. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var recordsArray = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        self.fetchData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pushToNextScreen(sender: AnyObject) {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func fetchData() {
        recordsArray .removeAll()
        let container = CKContainer.defaultContainer()
        let database = container.privateCloudDatabase
        let predicate = NSPredicate.init(value: true)
        let query = CKQuery.init(recordType: "Notes", predicate: predicate)
        database .performQuery(query, inZoneWithID: nil) { (results : [CKRecord]?, error : NSError?) in
            if error != nil {
                // show alert
                self.showAlertWithText(error!.description)
            }
            else {
                for record in results! {
                    self.recordsArray.append(record)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func showAlertWithText(text:String) {
        let alert = UIAlertController.init(title: "Cloud App", message: text, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: TableView delegate methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier") as! UpdatesTableViewCell
        let record  = recordsArray[indexPath.row]
        cell.linkLabel.text = record.valueForKey("name") as? String
        cell.descriptionLabel.text = record.valueForKey("description") as? String
        let asset = record.valueForKey("image") as? CKAsset
        cell.icon.image = UIImage.init(contentsOfFile: asset!.fileURL.path!)
        return cell;
    }
}

