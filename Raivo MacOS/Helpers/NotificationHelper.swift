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

// A helper class for performing cryptographic calculations.
class NotificationHelper {
    
    /// The singleton instance for the NotificationHelper
    public static let shared = NotificationHelper()
    
    /// A private initializer to make sure this class can only be used as a singleton class
    private init() {}
    
    /// TODO
    public struct NotificationType {
        static let COPIED_OTP_TO_CLIPBOARD = 1
    }
    
    /// TODO
    ///
    /// - Parameter userInfo: TODO
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
    
    /// TODO
    ///
    /// - Parameter title: TODO
    /// - Parameter description: TODO
    /// - Returns: TODO
    private func build(_ title: String, _ description: String) -> NSUserNotification {
        let notification = NSUserNotification()
        
        notification.title = title
        notification.informativeText = description
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.hasActionButton = false
        
        return notification
    }
    
    /// TODO
    ///
    /// - Parameter userInfo: TODO
    private func setClipboardNotification(_ userInfo: [String : Any]) {
        guard let token = userInfo["token"] as? String else {
            return
        }
        
        guard let issuer = userInfo["issuer"] as? String else {
            return
        }
        
        guard let account = userInfo["account"] as? String else {
            return
        }
        
        let notification = build("Received \(issuer) OTP", account)
        ClipboardHelper.shared.set(token)
        
        NSUserNotificationCenter.default.deliver(notification)
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(3)) {
            NSUserNotificationCenter.default.removeDeliveredNotification(notification)
        }
    }
    
}
