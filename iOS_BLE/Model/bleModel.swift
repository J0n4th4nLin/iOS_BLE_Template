//
//  bleModel.swift
//  iOS_BLE
//
//  Created by Jonathan Lin on 2022/9/5.
//

import Foundation
import CoreBluetooth
import SwiftUI

//UUID
let ServiceCBUUIDs: [CBUUID] = [service_CBUUID,tx_CBUUID,no_CBUUID]
//Fill in your UUID
let service_CBUUID = CBUUID(string: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
let tx_CBUUID = CBUUID(string: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
let no_CBUUID = CBUUID(string: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

protocol BluetoothProtocol {
    func state(state: BLEManager.State)
    func list(list: [BLEManager.Peripheral])
    func value(data: Data)
}

final class BLEManager: NSObject,ObservableObject{

    struct Peripheral: Identifiable {
        let id: Int
        let rssi: Int
        let uuid: String
        let name: CBPeripheral
    }

    static let shared = BLEManager()
    var myDelegate: BluetoothProtocol?
    var myCentral: CBCentralManager!
    var myPeripheral: CBPeripheral!
    var myState: State = .unknown { didSet { myDelegate?.state(state: myState) } }
    
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    
    //For Summuary
//    @Published var temp = Double()
//    @Published var red = Double()
//    @Published var green = Double()
//    @Published var IR = Double()
    
    var summuary = summaryViewModel.shared
    
    private var readCharacteristic: CBCharacteristic?
    private var writeCharacteristic: CBCharacteristic?
    private var notifyCharacteristic: CBCharacteristic?

    override init() {
        super.init()
            myCentral = CBCentralManager(delegate: self, queue: nil)
            myCentral.delegate = self
    }

    func connect(_ peripheral: CBPeripheral) {//connect BLE
        if myPeripheral != nil {
            guard let myPeripheral = myPeripheral else { return }
            myCentral?.cancelPeripheralConnection(myPeripheral)
            myCentral?.connect(peripheral, options: nil)
        } else { myCentral?.connect(peripheral, options: nil) }
    }

    func disconnect() {//disconnect BLE
        guard let myPeripheral = myPeripheral else { return }
        myCentral?.cancelPeripheralConnection(myPeripheral)
    }

    func startScanning() {//scan BLE
        print("startScanning")
        peripherals.removeAll()
        myCentral.scanForPeripherals(withServices: nil, options: nil)
     }

    func stopScanning() {//stopScan BLE
        print("stopScanning")
        peripherals.removeAll()
        myCentral.stopScan()
    }

    func send(_ value: [UInt8]) {//send value BLE
        guard let characteristic = writeCharacteristic else { return }
        myPeripheral?.writeValue(Data(value), for: characteristic, type: .withResponse)
    }

    func startCentralManager() {
        self.myCentral = CBCentralManager(delegate: self, queue: nil)
    }
    enum State { case unknown, resetting, unsupported, unauthorized, poweredOff, poweredOn, error, connected, disconnected }
    
//MARK: - Received datas after is decoded from blePeripheralExtensions.
    //So u can add functions below for the data u wanna receive.
    func receiveTemp(temp: Double) {
        //Send datas to u wanna specfied viewModel.
        summuary.tempForSummary(temp: temp)
    }
    //(Cont)
    func receivedXXX(XXX: Double){
        
    }
}

