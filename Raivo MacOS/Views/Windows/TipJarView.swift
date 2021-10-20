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
import SwiftUI
import SwiftyStoreKit
import StoreKit

/// A support tab view shown in the preferences window
///
/// - Note: This contains help & support for users that are unsure of how to use the app
struct TipJarView: View {
    
    /// The in-app purchases
    @ObservedObject var products = ObservableProducts()
    
    /// Identifier of payment that was initiated by user
    @State var paymentInitiated: String? = nil
    
    /// dentifier of payment that was made by user
    @State var paymentSucceeded: String? = nil
    
    /// Payment error
    @State var paymentError: String? = nil
    
    /// Initiate the payment process for the given tip
    ///
    /// - Parameter tip: The tip to pay for
    private func startPayment(_ tip: SKProduct) {
        SwiftyStoreKit.purchaseProduct(tip.productIdentifier, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let product):
                paymentSucceeded = product.productId
            case .error(let error):
                paymentInitiated = nil

                switch error.code {
                case .unknown:
                    paymentError = "An unknown error occurred during the payment."
                case .clientInvalid:
                    paymentError = "You are not allowed to make this payment."
                case .paymentInvalid:
                    paymentError = "The purchase identifier was invalid."
                case .paymentNotAllowed:
                    paymentError = "This device is not allowed to make a payment."
                case .storeProductNotAvailable:
                    paymentError = "This tip is not available at the moment."
                case .cloudServicePermissionDenied:
                    paymentError = "Access to cloud service information is not allowed."
                case .cloudServiceNetworkConnectionFailed:
                    paymentError = "Could not connect to the internet."
                case .cloudServiceRevoked:
                    paymentError = "User has revoked permission to use this cloud service"
                case .paymentCancelled:
                    break
                default:
                    paymentError = (error as NSError).localizedDescription
                }
            }
        }
    }
    
    /// The actual view shown when someone clicks on the support tab
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                Image("image-gift")
                    .resizable()
                    .scaledToFit()
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    .frame(width: 550, height: 225, alignment: .bottomLeading)
            }
            .frame(width: 400, height: 250, alignment: .bottomLeading)
            .offset(x: -80.0)
            VStack (alignment: .leading, spacing: 5) {
                VStack(alignment: .leading) {
                    if paymentSucceeded != nil {
                        Image(systemName: "hands.sparkles.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30.0, height: 30.0)
                        Text("That's very generous. Thank you!").foregroundColor(.secondary)
                        Text("Regards, Tijme Gommers.").foregroundColor(.secondary)
                        Button("Close Tip Jar") {
                            getAppPrincipal().keyWindow?.close()
                        }
                    } else if paymentError != nil {
                        Image(systemName: "xmark.octagon.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30.0, height: 30.0)
                        Text(paymentError!).foregroundColor(.secondary)
                        Button("Try Again") {
                            paymentError = nil
                            paymentInitiated = nil
                        }
                    } else if products.tips.isEmpty {
                        ProgressView()
                    } else {
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(products.tips, id: \.self) { tip in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(tip.localizedDescription) \(tip.localizedPrice ?? "")")
                                    Button(action: {
                                        paymentInitiated = tip.productIdentifier
                                        startPayment(tip)
                                    }, label: {
                                        HStack {
                                            if paymentInitiated == tip.productIdentifier {
                                                ProgressView().scaleEffect(0.4)
                                            } else {
                                                Image(systemName: "creditcard")
                                                Text(tip.localizedTitle)
                                            }
                                        }
                                    }).disabled(paymentInitiated != nil)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(width: 250, height: 250)
            .offset(x: +265)
        }
        .frame(width: 550, height: 250, alignment: .topLeading)
    }
}

#if DEBUG
struct TipJarView_Previews: PreviewProvider {
    
    static var previews: some View {
        TipJarView()
    }
    
}
#endif
