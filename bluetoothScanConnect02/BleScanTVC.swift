//
//  BleScanTVC.swift
//  bluetoothScanConnect
//
//  Created by Stefan Glaser on 27.02.16.
//  Copyright © 2016 conectas. All rights reserved.
//

import UIKit


class BleScanTVC: UITableViewController, BTDiscoveryDelegate {
    
    // ------------------------------------------------------
    let laderBTD = BTDiscovery()
    
    // ------------------------------------------------------
    var bleDevicesDatenAR = [BleDevices]()
    var bleConnectDatenAR = [BleDevices]()
    
    var identifier = "detailVcSegue"
    var senderCell : UITableViewCell?

    // ----------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        // refreshControl.addTarget(self, action: Selector("update"), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.addTarget(self, action: #selector(BleScanTVC.update), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
    }
    
    // ----------------------------------------------------------------------------------------------------
    override func viewDidAppear(animated: Bool) {
        
        // Initialize central manager on load
        laderBTD.delegateBTDiscovery = self
        laderBTD.startBteScan(bleConnectDatenAR)
        
    }
    
    
    // ----------------------------------------------------------------------------------------------------
    // MARK: - ANFANG: BTDiscoveryDelegate
    // ----------------------------------------------------------------------------------------------------
    
    func bteErgScanFertig(lader: BTDiscovery, bleDevicesDaten: [BleDevices]) {
        
        print("BleScanTVC: tableView.reloadData")
        bleDevicesDatenAR = bleDevicesDaten
        
        let navTitleTxt = "Scan Daten"
        if let _ = navigationController {
            self.navigationItem.title = navTitleTxt
            
            print("BleScanTVC: devNamenCount: \(bleDevicesDatenAR.count)")
            print("BleScanTVC: devicesNamen: \(bleDevicesDatenAR[0])")
            
            self.tableView.reloadData()
        }
    }
    
    
    func bteErgConnectSET(lader: BTDiscovery) {
        
        // Now that we are setup, return to main view.
        if let navigationController = navigationController {
            _ = navigationController
            // navTitle = navTitleTxt
            
//            let mainVC = self.navigationController!.viewControllers.first as! ViewController
//            mainVC.bleConnectDatenAR = bleConnectDatenAR
//            navigationController.popViewControllerAnimated(true)
            // self.navigationController!.popToRootViewControllerAnimated(true)
            
            
            performSegueWithIdentifier(identifier, sender: senderCell)
            
        }
    }
    
    
    // ----------------------------------------------------------------------------------------------------
    // MARK: - ENDE: BTDiscoveryDelegate
    // ----------------------------------------------------------------------------------------------------
    
    
    // ----------------------------------------------------------------------------------------------------
    func update() {
        
        self.navigationItem.title = "Update"
        
        print("BleScanTVC: update")
        
        bleDevicesDatenAR.removeAll(keepCapacity: false)
        // self.tableView.reloadData()
        
        // Initialize central manager on load
        laderBTD.delegateBTDiscovery = self
        laderBTD.startBteScan(bleConnectDatenAR)
        self.refreshControl?.endRefreshing()
        
        bleConnectDatenAR.removeAll(keepCapacity: false)
    }
    
    
    // ----------------------------------------------------------------------------------------------------
    // MARK: - Table view data source
    // ----------------------------------------------------------------------------------------------------
    //
    // ----------------------------------------------------------------------------------------------------
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //
    // ----------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bleDevicesDatenAR.count ?? 0
    }
    //
    // ----------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BleScanTVCell
        print("BleScanTVC: cellForRowAtIndexPath")
        
        let aktuelleDevicesDaten = self.bleDevicesDatenAR[indexPath.row]
        
        if aktuelleDevicesDaten.devicesNamen != "nil" {
            
            print("BleScanTVC: devicesNamen: \(bleDevicesDatenAR.count) | \(indexPath.row)")
            
            cell.nameOutlet.text = ("\(aktuelleDevicesDaten.devicesNamen)")
            cell.uuidOutlet.text = aktuelleDevicesDaten.deviceUUID
            cell.rssiOutlet.text = aktuelleDevicesDaten.devicesRSSI.stringValue
        }
        
        return cell
    }
    
    //
    // ----------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        identifier = "detailVcSegue"
        senderCell = tableView.cellForRowAtIndexPath(indexPath)
        
        bleConnectDatenAR.removeAll()
        let aktuelleConnectDaten = self.bleDevicesDatenAR[indexPath.row]
        let connectDevice = BleDevices(
            activeCentralManager : aktuelleConnectDaten.activeCentralManager,
            peripheral : aktuelleConnectDaten.peripheral,
            devicesNamen : aktuelleConnectDaten.devicesNamen,
            deviceUUID : aktuelleConnectDaten.deviceUUID,
            devicesRSSI : aktuelleConnectDaten.devicesRSSI
        )
        self.bleConnectDatenAR.append(connectDevice)
        
        laderBTD.delegateBTDiscovery = self
        laderBTD.startBteConnect(bleConnectDatenAR)
        
        
//        if let _ = navigationController {
//            navigationItem.title = "Connecting \(aktuelleConnectDaten.devicesNamen)"
//        }
        
    }
    
    //
    // ----------------------------------------------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // print("BleScanTVC: prepareForSegue")
        if segue.identifier == "detailVcSegue" {
            let zielViewController = segue.destinationViewController as! ViewController
            zielViewController.bleConnectDatenAR = bleConnectDatenAR
        }
    }
    
    
    
    
    
}
