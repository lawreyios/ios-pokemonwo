//
//  PGHighscoresTableViewController.swift
//  pokemongo
//
//  Created by Lawrence Tan on 21/7/16.
//  Copyright © 2016 2359 Media Pte Ltd. All rights reserved.
//

import UIKit

let kHighscoreUpdatedNotification = "HighscoreUpdated"
let kShowAlertNotification = "ShowAlert"

class PGHighscoresTableViewController: UITableViewController, UIAlertViewDelegate {
    
    let kPGHighscoreCellIdentifier = "PGHighscoreCell"
    let kPGCaughtCellIdentifier = "PGCaughtCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: kPGHighscoreCellIdentifier, bundle: nil), forCellReuseIdentifier: kPGHighscoreCellIdentifier)
        tableView.registerNib(UINib(nibName: kPGCaughtCellIdentifier, bundle: nil), forCellReuseIdentifier: kPGCaughtCellIdentifier)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTrainerData), name: kHighscoreUpdatedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.showAlert), name: kShowAlertNotification, object: nil)
        PGClient.getTrainersFromServer { (hasResult, error) in }
        PGClient.getSpecialTrainersFromServer { (hasResult, error) in }
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.backgroundColor = UIColor.blackColor()
    }
    
    func reloadTrainerData() {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return pgClient.trainers.count
        }
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(kPGHighscoreCellIdentifier, forIndexPath: indexPath) as! PGHighscoreCell
            cell.setDetails(pgClient.trainers[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(kPGCaughtCellIdentifier, forIndexPath: indexPath) as! PGCaughtCell
            if pgClient.specialTrainers.count > 0 {
                cell.lblName.text = "\((pgClient.specialTrainers.first?.name)!.uppercaseString) has caught MEW!"
            }
            return cell
        }
        
    }
    
    @IBAction func onDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showAlert() {
        let alert = UIAlertView(title: "MEW is caught by \((pgClient.specialTrainers.first?.name)!)!", message: "", delegate: self, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    

}
