//
//  blePeripheralExtensions.swift
//  iOS_BLE
//
//  Created by Jonathan Lin on 2022/9/5.
//

import Foundation
import CoreBluetooth

extension BLEManager: CBPeripheralDelegate{
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        //peripheral.discoverServices(earPhoneServiceCBUUIDs)
        for service in services {
            //print(service)
            print(peripheral.discoverCharacteristics(nil, for: service))
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
           // print(characteristic)
            // Heart Rate Measurement Characteristic
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                //print(characteristic.value as Any )
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
     
    }
    func peripheral(_ peripheral: CBPeripheral, requiredCharacteristicUUIDs error: Error?) { }
    
    private func peripheral(_ peripheral: CBPeripheral, didReadValueFor descriptor: CBDescriptor, error: Error?) { }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) { }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) { }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = characteristic.value else { return }
        myDelegate?.value(data: value)
        
        if characteristic.uuid == tx_CBUUID{
            let data = decode_RAW(from: characteristic)
        }

//        switch characteristic.uuid {
//
//        case tx_CBUUID:
//            let bpm = decode(from: characteristic)


//        case xxx_CBUUID:
//            let per = decode(from: characteristic)


//        case temp_CBUUID:
//            let c = decode(from: characteristic)


//        case xxxx_CBUUID:
//            let raw = decode_RAW(from: characteristic)


//        default:
//            //print("Unhandled Characteristic UUID: \(characteristic.uuid)")

//        }
    }
    
    //MARK: - Decode Raw Data(Heart Rate,Spo2,Temperture) after BLE package is split at the first
//    private func decode(from characteristic: CBCharacteristic) -> Float {
//        guard let characteristicData = characteristic.value else { return -1 }
//        let byteArray = [UInt8](characteristicData)
//        var f: Float = 0
//
//        memcpy(&f, byteArray, 4)
//
//        return f
//    }
    //MARK: - Decode Raw Data after BLE package isn't split at the first
    private func decode_RAW(from characteristic: CBCharacteristic) ->  Double {
        guard let characteristicData = characteristic.value else { return -1 }

        //[0]...[1] 2Bytes, BodyTemperature
        let bodyTemp = Int16(characteristicData[0]) << 8 + Int16(characteristicData[1])
        let temp = (Double(bodyTemp)*0.005)
        receiveTemp(temp: temp)

        //[2]...[5] 4Bytes, PPG1: Red Light
        let data_1 = Int32(characteristicData[2]) << 24 + Int32(characteristicData[3]) << 16 + Int32(characteristicData[4]) << 8 + Int32(characteristicData[5])

        //[6]...[9] 4Bytes, PPG2: Green Light
        let data_2 = Int32(characteristicData[6]) << 24 + Int32(characteristicData[7]) << 16 + Int32(characteristicData[8]) << 8 + Int32(characteristicData[9])

        //[10]...[13] 4Bytes, PPG3:IR Light
        let data_3 = Int32(characteristicData[10]) << 24 + Int32(characteristicData[11]) << 16 + Int32(characteristicData[12]) << 8 + Int32(characteristicData[13])

        //[14] 1Bytes, Time for year
        let year = Int16(characteristicData[14]) << 8 + Int16(characteristicData[15])

        //[15] 1Bytes, Time for month
        let month = Int8(characteristicData[16])
        
        //[16] 1Bytes, Time for day
        let day = Int8(characteristicData[17])
        
        //[17] 1Bytes, Time for hour
        let hour = Int8(characteristicData[18])
        
        //[18] 1Bytes, Time for miniute
        let miniute = Int8(characteristicData[19])

        //[19] 1Bytes, Time for second
        let second = Int8(characteristicData[20])
        
        return 0
    }
}
