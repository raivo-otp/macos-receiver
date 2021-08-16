//
// Raivo OTP
//
// Copyright (c) 2021 Tijme Gommers. All rights reserved. Raivo OTP
// is provided 'as-is', without any express or implied warranty.
//
// Modification, duplication or distribution of this software (in
// source and binary forms) for any purpose is strictly prohibited.
//
// https://github.com/raivo-otp/macos-receiver/blob/master/LICENSE.md
//

import Foundation
import UserNotifications

// A helper class for performing notification actions in MacOS.
class NotificationHelper {
    
    /// The singleton instance for the NotificationHelper
    public static let shared = NotificationHelper()
    
    /// A private initializer to make sure this class can only be used as a singleton class
    private init() {}
    
    /// All available notification types. These types may perform different actions.
    public struct NotificationType {
        static let COPIED_OTP_TO_CLIPBOARD = 1
    }
    
    /// Called whenever the app delegate receives a remote notification
    ///
    /// - Parameter userInfo: The information from the remote notification
    public func notify(_ userInfo: [String : Any]) {
        guard let proposedType = userInfo["type"] as? Int else {
            return
        }
        
        switch proposedType {
        case NotificationType.COPIED_OTP_TO_CLIPBOARD:
            setClipboardNotification(userInfo)
            break
        default:
            break
        }
    }
    
    /// Build and show a notification to the MacOS user
    ///
    /// - Parameter title: The title to display in the alert
    /// - Parameter description: The description to display in the alert
    /// - Returns: The notification object that was builtd
    private func build(_ title: String, _ description: String) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = description
        content.sound = UNNotificationSound.default

        return UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: .none)
    }
    
    /// Called whenever a remote clipboard notification is received.
    ///
    /// - Parameter userInfo: The information from the remote notification
    /// - Note: This is usually called when a user taps on a password in Raivo OTP for iOS
    private func setClipboardNotification(_ userInfo: [String : Any]) {
        guard
            let encryptedToken = userInfo["token"] as? String,
            let token = try? CryptographyHelper.shared.decrypt(encryptedToken, withKey: "qqqqqqqq")
        else {
            return
        }
        
        guard
            let encryptedIssuer = userInfo["issuer"] as? String,
            let issuer = try? CryptographyHelper.shared.decrypt(encryptedIssuer, withKey: "qqqqqqqq")
        else {
            return
        }
        
        guard
            let encryptedAccount = userInfo["account"] as? String,
            let account = try? CryptographyHelper.shared.decrypt(encryptedAccount, withKey: "qqqqqqqq")
        else {
            return
        }
        
        ClipboardHelper.shared.set(token)
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(30)) {
            ClipboardHelper.shared.clear(token)
        }
        
        let notification = build("Received \(issuer) OTP", account)
        UNUserNotificationCenter.current().add(notification)
    }
    
}
