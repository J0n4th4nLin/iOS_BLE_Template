//
//  summaryView.swift
//  iOS_BLE
//
//  Created by Jonathan Lin on 2022/9/5.
//

import SwiftUI

struct summaryView: View {
    
    //MARK: - The following 2 vars for received & send values between bleManager & summayView.
    var bluetooth = BLEManager.shared
    var summary = summaryViewModel.shared
    
    //MARK: - The following vars for BLE setting.
    @State var progress: CGFloat = 0.5
    @State var startAnimation: CGFloat = 0
    @State var presented: Bool = false
    @State var list = [BLEManager.Peripheral]()
    @State var isConnected: Bool = BLEManager.shared.myPeripheral != nil { didSet { if isConnected { presented.toggle() } }}
    @State var response = Data()
    @State var string: String = ""
    @State var value: Float = 0
    @State var state: Bool = false { didSet { bluetooth.send([UInt8(state.int)]) } }
    @State var editing = false
    
    //Parameters is received from summayViewModel,we can use vars below in this view.
    @ObservedObject var Temp = summaryViewModel.shared

    var body: some View {
        TabView{
            VStack{
//MARK: - Top view includes word of "Summary" which is a BLE button at the same time by itself.
                HStack{
                    ZStack{
                        Button {
                            withAnimation{
                                presented.toggle()
                            }
                        }
                    label: {
                        //U can decide font color by youself to judge BLE is connected or not,bcz initial color is button blue.
                        if isConnected{
                            Text("Summary").font(.title).fontWeight(.bold).foregroundColor(.white)
                            Spacer(minLength: 0)
                        }else{
                            Text("Summary").font(.title).fontWeight(.bold).foregroundColor(.white)
                            Spacer(minLength: 0)
                        }
                    }
                    .halfSheet(isPresented: $presented){
                        VStack{
                            Text("Bluetooth Device")
                                .font(.title)
                                .padding([.top], 15)
                            scanView(bluetooth: bluetooth, presented: $presented, list: $list, isConnected: $isConnected)
                        }.onAppear{ bluetooth.myDelegate = self }
                    }
                    .ignoresSafeArea()
                        
                    }
                }
                .padding(.horizontal)
                Divider()
//MARK: - Main view.
                Spacer()
                VStack{
                    Text("Temp:\(Temp.tempForSum)")
                }
                Spacer()
                Divider()
            }
//MARK: - Bottom view.
            .tabItem{
                Image(systemName: "heart.fill")
                Text("Summary")
            }
        }
        .padding(.top)
    }
}
//MARK: - BLE State
extension summaryView: BluetoothProtocol {
    
    func state(state: BLEManager.State) {
        switch state {
        case .unknown: print("◦ .unknown")
        case .resetting: print("◦ .resetting")
        case .unsupported: print("◦ .unsupported")
        case .unauthorized: print("◦ bluetooth disabled, enable it in settings")
        case .poweredOff: print("◦ turn on bluetooth")
        case .poweredOn: print("◦ everything is ok")
        case .error: print("• error")
        case .connected:
            print("◦ connected to \(bluetooth.myPeripheral?.name ?? "")")
            isConnected = true
        case .disconnected:
            print("◦ disconnected")
            isConnected = false
        }
    }
    
    func list(list: [BLEManager.Peripheral]) { self.list = list }
    
    func value(data: Data) { response = data }
}
//MARK: -
struct summaryView_Previews: PreviewProvider {
    static var previews: some View {
        summaryView()
    }
}

