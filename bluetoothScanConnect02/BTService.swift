//
//  BTService.swift
//  bluetoothScanConnect02
//
//  Created by Stefan Glaser on 28.02.16.
//  Copyright © 2016 conectas. All rights reserved.
//

import Foundation
import CoreBluetooth


// ----------------------------------------------------------------------------------------------------
protocol BTServiceDelegate {
    func bteErgDisConnect(lader: BTService, navTitleTxt: String?)
    func bteErgSetNavTitleTxt(lader: BTService, navTitleTxt: String?)
    func bteErgCBCarUServiceDaten(lader: BTService, peripheralName: String, peripheralState: String, peripheralUUID: String, serviceUUID: String, serviceCharUUID: String, serviceIsPrimary: Bool)
}


// ----------------------------------------------------------------------------------------------------
//class BTService: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
class BTService: NSObject, CBPeripheralDelegate {
    
    // ------------------------------------------------------
    var delegateBTService: BTServiceDelegate?
    
    // ------------------------------------------------------
    var bleConnectDatenAR = [BleDevices]()
    
    // ------------------------------------------------------
    var peripheral: CBPeripheral?
    
    var navTitleTxt : String?
    
    // ----------------------------------------------------------------------------------------------------
    func bteStartService(bleConnectDatenAR:[BleDevices]) {
        print("BTService: startService: \(bleConnectDatenAR.count)")
        
        if bleConnectDatenAR.count == 1 {
            peripheral = bleConnectDatenAR[0].peripheral
            
            if peripheral?.name == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegateBTService?.bteErgDisConnect(self, navTitleTxt: "Disconnect BLE")
                }
            }
            
            // ------------------------------------------------------
            if peripheral != nil {
                peripheral?.delegate = self
                // peripheral?.discoverServices(nil)
            }
            
        } else {
            return
        }
    }
    
    //
    // ----------------------------------------------------------------------------------------------------
    // kommt von peripheral?.discoverServices(nil):
    // Delegate: Wird geworfen, wenn Peripheriegeräte entdeckt wurden. Lese verfügbare Dienste aus.
    // ----------------------------------------------------------------------------------------------------
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("BTService: didDiscoverServices : \(peripheral)")
        
        if let servicePeripherals = peripheral.services as [CBService]! {
            for service in servicePeripherals {
                peripheral.discoverCharacteristics(nil, forService: service)
                if peripheral.name != nil {
                    navTitleTxt = "\(peripheral.name!)"
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegateBTService?.bteErgSetNavTitleTxt(self, navTitleTxt: self.navTitleTxt)
                    }
                }
            }
        }
    }
    
    //
    // ----------------------------------------------------------------------------------------------------
    // Delegate:
    // Wird aufgerufen, um die Eigenschaften eines bestimmten Service zu entdecken.
    // ----------------------------------------------------------------------------------------------------
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        // print("----------------------------------------")
        print("BTService: didDiscoverCharacteristicsForService P: \(peripheral)")
		// print("BTService: didDiscoverCharacteristicsForService S: \(service)")
        // print("BTService: didDiscoverCharacteristicsForService E: \(error)")
        
        var peripheralName : String = ""
        if let peripheralNameTemp = peripheral.name { peripheralName = peripheralNameTemp }
        var peripheralState : String = ""
        let peripheralUUID : String = peripheral.identifier.UUIDString

        var serviceCharUUID : String = ""
        let serviceIsPrimary = service.isPrimary
        let serviceUUID = "\(service.UUID)"
        
        switch peripheral.state {
        	case .Connected:
            peripheralState = "Connected"
            
        	case .Connecting:
            peripheralState = "Connected"
            
        	case .Disconnected:
            peripheralState = "Disconnected"
            
        	case .Disconnecting:
            peripheralState = "Disconnecting"
        }
        
        
        if let characterArray = service.characteristics as [CBCharacteristic]! {
            for charateristic in characterArray {
                // print("BTService: charateristic: \(charateristic)")
                
                serviceCharUUID = "\(charateristic.UUID)"
                // let thisCharacteristic = charateristic
                peripheral.setNotifyValue(true, forCharacteristic: charateristic)
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.delegateBTService?.bteErgCBCarUServiceDaten(self, peripheralName: peripheralName, peripheralState: peripheralState, peripheralUUID: peripheralUUID, serviceUUID: serviceUUID, serviceCharUUID: serviceCharUUID,  serviceIsPrimary: serviceIsPrimary)
        }
        
//        print("----------------------------------------")
//        print("BTService: peripheralName: \(peripheralName)")
//        print("BTService: peripheralState: \(peripheralState)")
//        print("BTService: peripheralUUID: \(peripheralUUID)")
//        print("BTService: serviceUUID: \(serviceUUID)")
//        print("BTService: serviceCharUUID: \(serviceCharUUID)")
//        print("BTService: serviceIsPrimary: \(serviceIsPrimary)")
        
    }
    
    
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("BTService: didUpdateNotificationStateForCharacteristic: \(peripheral)")
        // print("BTService: didUpdateNotificationStateForCharacteristic: \(characteristic)")
        
        
        
    }
    
    func peripheral(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: NSError?) {
        print("BTService: readRSSI: \(RSSI)")
    }
    
}
