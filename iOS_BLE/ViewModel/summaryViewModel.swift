//
//  summaryViewModel.swift
//  iOS_BLE
//
//  Created by Jonathan Lin on 2022/9/5.
//

import Foundation
import SwiftUI

class summaryViewModel: NSObject,ObservableObject{
 
//MARK: - The following a var for send values between bleManager & summayViewModel.
    static let shared = summaryViewModel()
    
//MARK: - Parameters gonna send to summaryView.
    @Published var tempForSum = Double()
    @Published var xxxForSum = Double()
    
//MARK: - Received datas from bleModel.
    func tempForSummary(temp: Double) -> Double{
        print("Test:\(temp)")
        tempForSum = temp
        return tempForSum
    }
    
}
