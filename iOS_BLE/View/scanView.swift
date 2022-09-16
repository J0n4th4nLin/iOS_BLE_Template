//
//  scanView.swift
//  iOS_BLE
//
//  Created by Jonathan Lin on 2022/9/5.
//

import SwiftUI

//MARK: - This view for BLE gonna scan peripherals and print on list after click button of "Summary" in summuaryView.
struct scanView: View {
    var bluetooth: BLEManager
    @Binding var presented: Bool
    @Binding var list: [BLEManager.Peripheral]
    @Binding var isConnected: Bool
    
    var body: some View{
        List(list){ peripheral in
            Button(action: { bluetooth.connect(peripheral.name) }){
                HStack{
                    Text(peripheral.name.name ?? "")
                    Spacer()
                }
            }
        }
        .listStyle(InsetGroupedListStyle()).onAppear{
            bluetooth.startScanning()
        }.onDisappear{ bluetooth.stopScanning() }.padding(.vertical, 0)
    }
}

