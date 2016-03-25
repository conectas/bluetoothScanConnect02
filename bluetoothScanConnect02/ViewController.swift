//
//  ViewController.swift
//  bluetoothScanConnect02
//
//  Created by Stefan Glaser on 28.02.16.
//  Copyright © 2016 conectas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BTServiceDelegate {
    
    // ------------------------------------------------------
    @IBOutlet weak var deviceNameOutlet: UILabel!
    @IBOutlet weak var deviceUuidOutlet: UILabel!
    
    @IBOutlet weak var peripheralNameOutlet: UILabel!
    @IBOutlet weak var peripheralStateOutlet: UILabel!
    @IBOutlet weak var peripheralUUIDOutlet: UILabel!
    
    @IBOutlet weak var serviceUUIDOutlet: UILabel!
    @IBOutlet weak var serviceCharUUIDOutlet: UILabel!
    @IBOutlet weak var serviceIsPrimaryOutlet: UILabel!
    
    
    
    
    
    // ------------------------------------------------------
    let laderBTS = BTService()
    
    // ------------------------------------------------------
    var bleConnectDatenAR = [BleDevices]()
    
    // ------------------------------------------------------
    var navTitleTxt : String?
    
    //
    // ----------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if bleConnectDatenAR.count == 1 {
            let aktuelleConnectDaten = self.bleConnectDatenAR[0]
            
            navigationItem.title = "Connecting \(aktuelleConnectDaten.devicesNamen)"
            deviceNameOutlet.text = aktuelleConnectDaten.devicesNamen
            deviceUuidOutlet.text = aktuelleConnectDaten.deviceUUID
            
            laderBTS.delegateBTService = self
            laderBTS.bteStartService(bleConnectDatenAR)
            
        } else {
            navigationItem.title = "Fehler Connecting"
            deviceNameOutlet.text = "-"
            deviceUuidOutlet.text = "-"
        }
        
        
    }
    
    
    
    // ----------------------------------------------------------------------------------------------------
    // MARK: - ANFANG: BTServiceDelegate
    // ----------------------------------------------------------------------------------------------------
    
    func bteErgDisConnect(lader: BTService, navTitleTxt: String?) {
        if let navTitleTxtSET = navTitleTxt {
            navigationItem.title = navTitleTxtSET
        }
    }
    
    func bteErgSetNavTitleTxt(lader: BTService, navTitleTxt: String?) {
        if let navTitleTxtSET = navTitleTxt {
            navigationItem.title = navTitleTxtSET
        }
    }
    
    func bteErgCBCarUServiceDaten(lader: BTService, peripheralName: String, peripheralState: String, peripheralUUID: String, serviceUUID: String, serviceCharUUID: String, serviceIsPrimary: Bool) {
        
        peripheralNameOutlet.text = peripheralName
        peripheralStateOutlet.text = peripheralState
        peripheralUUIDOutlet.text = peripheralUUID
        
        serviceUUIDOutlet.text = serviceUUID
        serviceCharUUIDOutlet.text = serviceCharUUID
        serviceIsPrimaryOutlet.text = "\(serviceIsPrimary)"
    }
    
    /*
    @IBOutlet weak var peripheralNameOutlet: UILabel!
    @IBOutlet weak var peripheralStateOutlet: UILabel!
    @IBOutlet weak var peripheralUUIDOutlet: UILabel!
    
    @IBOutlet weak var serviceUUIDOutlet: UILabel!
    @IBOutlet weak var serviceCharUUIDOutlet: UILabel!
    @IBOutlet weak var serviceIsPrimaryOutlet: UILabel!




*/
    
    
    // ----------------------------------------------------------------------------------------------------
    // MARK: - ENDE: BTServiceDelegate
    // ----------------------------------------------------------------------------------------------------

    


}

