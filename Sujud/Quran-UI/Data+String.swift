//
//  Data+String.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 18/12/2022.
//

import Foundation

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
