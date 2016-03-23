//
//  MasterViewController.swift
//  AccelerometerExample-Swift
//
//  Created by Grzegorz Krukiewicz-Gacek on 05.01.2015.
//  Copyright (c) 2015 Estimote Inc. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, ESTNearableManagerDelegate {
    
    var nearables:Array<ESTNearable>!
    var nearableManager:ESTNearableManager!
    var knownBeacons = Set<String>()
    init() {
        super.init(style: .Plain)
    }
    required init?(coder aDecoder: NSCoder) {
        NSLog("init(coder:)")
        super.init(coder: aDecoder)
        knownBeacons.insert("2d3f05974632c4bb")
        knownBeacons.insert("def")
    }
    // Need this to prevent runtime error:
    // fatal error: use of unimplemented initializer 'init(nibName:bundle:)'
    // for class 'TestViewController'
    // I made this private since users should use the no-argument constructor.
    private override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        NSLog("init(nibName:)")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("yes I am alive")
        
        nearables = []
        nearableManager = ESTNearableManager()
        nearableManager.delegate = self
        nearableManager.startRangingForType(ESTNearableType.All)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedNearable = nearables[indexPath.row] as ESTNearable
                (segue.destinationViewController as! DetailViewController).nearable = selectedNearable
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearables.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let nearable = nearables[indexPath.row] as ESTNearable
        cell.textLabel?.text = ESTNearableDefinitions.nameForType(nearable.type)
        cell.detailTextLabel!.text = nearable.identifier
        if knownBeacons.contains(nearable.identifier) {
            cell.contentView.backgroundColor = UIColor.greenColor()
        } else {
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    
    // MARK: - ESTNearableManager delegate

    func nearableManager(manager: ESTNearableManager, didRangeNearables nearables: [ESTNearable], withType type: ESTNearableType) {
        self.nearables = nearables
        tableView.reloadData()
    }
}

