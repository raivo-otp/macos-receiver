//
//
// Raivo OTP
//
// Copyright (c) 2019 Tijme Gommers. All rights reserved. Raivo OTP
// is provided 'as-is', without any express or implied warranty.
//
// Modification, duplication or distribution of this software (in
// source and binary forms) for any purpose is strictly prohibited.
//
// https://github.com/raivo-otp/macos-receiver/blob/master/LICENSE.md
//

import Foundation
import SwiftyStoreKit
import StoreKit

/// An Apple Push Notification Token that can be observed
class ObservableProducts: ObservableObject {
    
    /// The purchases
    @Published var tips: [SKProduct] = []
    
    /// Fetch all products on initialize
    init() {
        fetchTips()
    }
    
    /// Fetch all available tips
    func fetchTips() {
        SwiftyStoreKit.retrieveProductsInfo(["tip.small", "tip.moderate", "tip.immense"]) { result in
            guard result.error == nil else {
                return
            }
            
            self.tips = Array(result.retrievedProducts).sorted(by: { leftProduct, rightProduct in
                leftProduct.price.decimalValue < rightProduct.price.decimalValue
            })
        }
    }
   
}
