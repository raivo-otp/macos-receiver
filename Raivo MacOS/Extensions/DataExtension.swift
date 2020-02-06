//
//  DataExtension.swift
//  Raivo MacOS
//
//  Created by Tijme Gommers on 06/02/2020.
//  Copyright © 2020 Tijme Gommers. All rights reserved.
//

import Foundation

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
