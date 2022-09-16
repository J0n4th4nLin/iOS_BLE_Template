//
//  bleExtensions.swift
//  iOS_BLE
//
//  Created by Jonathan Lin on 2022/9/5.
//

import Foundation

extension Bool {
    var int: Int { self ? 1 : 0 }
}

extension Data {
    var hex: String { map{ String(format: "%02x", $0) }.joined() }//Device Name
}
