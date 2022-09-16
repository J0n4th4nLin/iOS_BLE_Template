//
//  bleCentralExtensions.swift
//  iOS_BLE
//
//  Created by Jonathan Lin on 2022/9/5.
//

import Foundation
import CoreBluetooth

extension BLEManager: CBCentralManagerDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {//BLE status
        switch myCentral?.state {
        case .unknown: myState = .unknown
        case .resetting: myState = .resetting
        case .unsupported: myState = .unsupported
        case .unauthorized: myState = .unauthorized
        case .poweredOff: myState = .poweredOff
            print("OFF")
        case .poweredOn: myState = .poweredOn
        default: myState = .error
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)

        let uuid = String(describing: peripheral.identifier)
        let filtered = peripherals.filter{$0.uuid == uuid}

        if filtered.count == 0{
            guard let _ = peripheral.name else { return }
            let new = Peripheral(id: peripherals.count, rssi: RSSI.intValue, uuid: uuid, name: peripheral)
            peripherals.append(new)
            myDelegate?.list(list: peripherals)
        }
    }//discover BLE

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) { print(error!) }//fail connect BLE
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        myPeripheral = nil
        myState = .disconnected
    }//disconnect peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        myPeripheral = peripheral
        myState = .connected
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        myCentral.stopScan()
    }//connect BLE
    
}
