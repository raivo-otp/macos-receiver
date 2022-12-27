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

import Cocoa
import SwiftUI
import Preferences
import LaunchAtLogin
import SwiftyStoreKit
import UserNotifications

///
/// Get the Application Delegate (shared `UIApplicationDelegate` class).
///
/// - Returns: The application delegate singleton instance
func getAppDelegate() -> ApplicationDelegate {
    return (getAppPrincipal().delegate as! ApplicationDelegate)
}

/// UI events that were launched from the ApplicationPrincipal
class ApplicationDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    
    /// The welcome to Raivo view
    lazy var welcomeView = WelcomeView()
    
    /// The general preferences view
    lazy var settingsView = SettingsView()
    
    /// The devices 'QR code' preferences view
    lazy var linkingView = LinkingView()
    
    /// The help/support view
    lazy var supportView = SupportView()

    /// We need to keep a strong reference to the status bar to make sure it keeps working
    var statusBarFeature: StatusBarFeature?
    
    /// Our status item (menu bar item) that was generated using the status bar featured
    var statusItem: NSStatusItem?
    
    /// Sent by the default notification center after the application has been launched and initialized but before it has received its first event.
    ///
    /// - Parameter notification: A notification named didFinishLaunchingNotification.
    func applicationDidFinishLaunching(_ notification: Notification) {
        log.verbose("Application did finish launching.")
        
        // Migrate `LaunchAtLogin` module
        LaunchAtLogin.migrateIfNeeded()
        log.verbose("Migrating `LaunchAtLogin` module if needed.")
        
        // Initialise status bar
        statusBarFeature = StatusBarFeature()
        log.verbose("Status bar feature initialized.")
        
        // Getting (and generating if needed) the decryption password
        if StorageHelper.shared.getDecryptionPasswordIsPresent() == false {
            log.warning("Encryption password not set. Generating new encryption password.")
            try! StorageHelper.shared.setDecryptionPassword(CryptographyHelper.shared.getRandomDecryptionPassword())
            log.verbose("Encryption password generated and stored.")
        }
        
        // Listen for notifications, and request authorization
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if !granted {
                log.error(error?.localizedDescription ?? "Push notification authorization not granted.")
            }
        }
        
        // Register for remote notifications
        getAppPrincipal().registerForRemoteNotifications()
        
        // Register for transaction callbacks
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                    case .purchased, .restored:
                        if purchase.needsFinishTransaction {
                            log.verbose("In-app purchase finishing 'purchased' or 'restored' transaction.")
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                    default:
                        break
                }
            }
        }
        
        // If this is the first launch, open the welcome screen
        if !StorageHelper.shared.getHasLaunchedBefore() {
            try? StorageHelper.shared.setHasLaunchedBefore()
            LaunchAtLogin.isEnabled = true
            statusBarFeature?.onOpen()
        }
    }
    
    /// Sent to the delegate when Apple Push Services successfully completes the registration process.
    ///
    /// - Parameter application: The application that initiated the remote-notification registration process.
    /// - Parameter deviceToken: A token that identifies the device to Apple Push Notification Service (APNS).
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        log.verbose("Successfully completed APNS registration process.")
        
        settingsView.pushToken.data = deviceToken
        linkingView.pushToken.data = deviceToken
    }
    
    /// Sent to the delegate when Apple Push Service cannot successfully complete the registration process.
    ///
    /// - Parameter application: The application that initiated the remote-notification registration process.
    /// - Parameter error: An NSError object that encapsulates information why registration did not succeed. The application can display this information to the user.
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.error(error)
    }
    
    
    /// Sent to the delegate when a running application receives a remote notification.
    ///
    /// - Parameter application: The application that received the remote notification.
    /// - Parameter userInfo: A dictionary that contains information related to the remote notification, specifically a badge number for the application icon, a notification identifier, and possibly custom data.
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        log.verbose("Received a remote notification in the application delegate.")
        
        NotificationHelper.shared.notify(userInfo)
    }
    
    /// Asks the delegate how to handle a notification that arrived while the app was running in the foreground.
    ///
    /// - Parameter center: The shared user notification center object that received the notification.
    /// - Parameter notification: The notification that is about to be delivered. Use the information in this object to determine an appropriate course of action. For example, you might use the information to update your app’s interface.
    /// - Parameter completionHandler: The block to execute with the presentation option for the notification. Always execute this block at some point during your implementation of this method.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {        
        completionHandler([.badge, .banner, .list, .sound])
    }
    
}
