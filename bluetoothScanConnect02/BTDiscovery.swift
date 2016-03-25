//
//  BTDiscovery.swift
//  bluetoothScanConnect02
//
//  Created by Stefan Glaser on 28.02.16.
//  Copyright © 2016 conectas. All rights reserved.
//

import Foundation
import CoreBluetooth


// ----------------------------------------------------------------------------------------------------
protocol BTDiscoveryDelegate {
    
    func bteErgScanFertig(lader: BTDiscovery, bleDevicesDaten: [BleDevices])
    func bteErgConnectSET(lader: BTDiscovery)
}


class BTDiscovery: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // ------------------------------------------------------
    var delegateBTDiscovery: BTDiscoveryDelegate?
    
    // ------------------------------------------------------
    var activeCentralManager : CBCentralManager?
    var activeCentralManagerSET : CBCentralManager?
    
    var peripheral : CBPeripheral?
    var peripheralSET : CBPeripheral?
    var peripheralDevice: CBPeripheral?
    
    // ------------------------------------------------------
    var bleDevicesDatenAR = [BleDevices]()
    var bleConnectDatenAR = [BleDevices]()
    
    
    
    //
    // ----------------------------------------------------------------------------------------------------
    // Starte das scannen
    // ----------------------------------------------------------------------------------------------------
    func startBteScan(bleConnectDatenAR: [BleDevices]) {
        print("BTDiscovery: startBteScan")
        
        self.bleConnectDatenAR = bleConnectDatenAR
        
        if activeCentralManager == nil {
            print("BTDiscovery: activeCentralManager NIL")
            activeCentralManager = CBCentralManager(delegate: self, queue: nil)
        } else {
            print("BTDiscovery: activeCentralManager IST")
            
            if bleConnectDatenAR.count >= 1 {
                print("BTDiscovery: bleConnectDatenAR IST")
                
                let bleConnectDaten = bleConnectDatenAR[0]
                activeCentralManagerSET = bleConnectDaten.activeCentralManager
                peripheralSET = bleConnectDaten.peripheral
                activeCentralManagerSET!.cancelPeripheralConnection(peripheralSET!)
            }
            
            
            print("BTDiscovery: isScanning IST: \(activeCentralManager!.isScanning)")
            
            activeCentralManager!.stopScan()
            activeCentralManager = nil
            self.bleDevicesDatenAR.removeAll(keepCapacity: false)
            self.bleConnectDatenAR.removeAll(keepCapacity: false)
            startBteScan(self.bleConnectDatenAR)
            
        }
        
    }
    //
    // ----------------------------------------------------------------------------------------------------
    // Starte den connect
    // ----------------------------------------------------------------------------------------------------
    func startBteConnect(bleConnectDatenAR: [BleDevices]) {
        print("BTDiscovery: startBteConnect")
        
        
        if bleConnectDatenAR.count == 1 {
            
            print("BTDiscovery: bleConnectDatenAR")
            
            self.peripheralDevice = bleConnectDatenAR[0].peripheral
            self.peripheralDevice?.delegate = self
            
            if let activeCM = activeCentralManager {
                
                print("BTDiscovery: activeCM \(peripheralDevice!)")
                activeCM.connectPeripheral(peripheralDevice!, options: nil)
                
            } else {
                print("Connecting activeCentralManager fehlgeschlagen..")
            }
            
        } else {
            print("Fehler in den BTE Connect Daten..")
        }
    }
    //
    // ----------------------------------------------------------------------------------------------------
    // (1) Delegate: wird immer aufgerufen wenn sich an Bluetooth was ändert
    // ----------------------------------------------------------------------------------------------------
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("BTDiscovery: centralManagerDidUpdateState")
        
        var msg = ""
        switch (central.state) {
            
        case .PoweredOff:
            msg = "Bluetooth leider ausgeschaltet"
        case .PoweredOn:
            msg = "Bluetooth ist eingeschaltet"
            central.scanForPeripheralsWithServices(nil, options: nil)
            
            
        case .Resetting:
            msg = "Resetting"
            
            
        case .Unauthorized:
            msg = "Unauthorized"
            
            
        case .Unknown:
            msg = "Unknown"
            
            
        case .Unsupported:
            msg = "Unsupported"
            
            // default: break
            
        }
        print("BTDiscovery: STAT MSG: \(msg)")
    }
    
    //
    // ----------------------------------------------------------------------------------------------------
    // (2) Delegate: wird zum Scan aufgerufen => kommt von scanForPeripheralsWithServices
    // ----------------------------------------------------------------------------------------------------
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("BTDiscovery: didDiscoverPeripheral")
        
        if let deviceNamen = peripheral.name {
            
            if deviceNamen != "nil" {
                print("BTDiscovery: PName: \(peripheral.name!)")
                
                let neueDevice = BleDevices(
                    activeCentralManager : central,
                    peripheral : peripheral,
                    devicesNamen : deviceNamen,
                    deviceUUID : peripheral.identifier.UUIDString,
                    devicesRSSI : RSSI
                )
                self.bleDevicesDatenAR.append(neueDevice)
                
                dispatch_async(dispatch_get_main_queue()) {
                    print("BTDiscovery: Update TVC")
                    self.delegateBTDiscovery?.bteErgScanFertig(self, bleDevicesDaten: self.bleDevicesDatenAR)
                }
            }
        }
    }
    
    //
    // ----------------------------------------------------------------------------------------------------
    // (3) Delegate: kommt bei erfolgreichen Connect => connectPeripheral(peripheralDevice!, options: nil)
    // ----------------------------------------------------------------------------------------------------
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("BTDiscovery: didConnectPeripheral \(peripheral)")
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        if let activeCM = activeCentralManager {
            activeCM.stopScan()
            dispatch_async(dispatch_get_main_queue()) {
                self.delegateBTDiscovery?.bteErgConnectSET(self)
            }
        }
        
        
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("BTDiscovery: didFailToConnectPeripheral \(peripheral)")
    }
    
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("BTDiscovery: didDisconnectPeripheral \(peripheral)")
    }
    
    
    func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject]) {
        print("BTDiscovery: willRestoreState \(peripheral)")
    }
    
    
    func centralManager(central:CBCentralManager, didRetrievePeripherals peripherals:[AnyObject]!) {
        print("BTDiscovery: didRetrievePeripherals \(peripheral)")
        
    }
    
    
    /*
    
    @seealso            CBConnectPeripheralOptionNotifyOnConnectionKey
    *  @seealso            CBConnectPeripheralOptionNotifyOnDisconnectionKey
    *  @seealso            CBConnectPeripheralOptionNotifyOnNotificationKey
    
    */
    
}



// ----------------------------------------------------------------------------------------------------
// MARK: - struct BleDevices
struct BleDevices {
    var activeCentralManager : CBCentralManager
    var peripheral : CBPeripheral
    var devicesNamen : String
    var deviceUUID : String
    var devicesRSSI : NSNumber
    
}

