//
//  ApplicationPrinciple.swift
//  Raivo MacOS
//
//  Created by Tijme Gommers on 02/02/2020.
//  Copyright © 2020 Tijme Gommers. All rights reserved.
//

import Foundation
import AppKit

class ApplicationPrinciple: NSApplication {
    
    let strongDelegate = ApplicationDelegate()
    
    override init() {
        super.init()
        
        delegate = strongDelegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
