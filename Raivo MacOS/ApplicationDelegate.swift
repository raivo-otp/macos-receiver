//
//  AppDelegate.swift
//  Raivo MacOS
//
//  Created by Tijme Gommers on 01/02/2020.
//  Copyright © 2020 Tijme Gommers. All rights reserved.
//

import Cocoa
import SwiftUI
import Preferences
import UserNotifications
import NotificationCenter

///
/// Get the Application Delegate (shared `UIApplicationDelegate` class).
///
/// - Returns: The application delegate singleton instance
func getAppDelegate() -> ApplicationDelegate {
    return (getAppPrincipal().delegate as! ApplicationDelegate)
}

class ApplicationDelegate: NSObject, NSApplicationDelegate {
    
    lazy var generalView = GeneralView()
    
    lazy var devicesView = DevicesView()

    /// We need to keep a strong reference to the status bar to make sure it keeps working
    var statusBarFeature: StatusBarFeature?
    
    var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarFeature = StatusBarFeature()

        getAppPrincipal().registerForRemoteNotifications(matching: [.alert, .badge, .sound])
    }
    
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        devicesView.notifyAboutDeviceToken(deviceToken)
    }
    
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        let token = userInfo["otp"] as? String ?? "000 000"
        let issuer = userInfo["issuer"] as? String ?? "Unknown issuer"
        let account = userInfo["account"] as? String ?? "Unknown account"
        
        let notification = NSUserNotification()
        notification.title = "Received \(issuer) OTP"
        notification.informativeText = "\(account)"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.hasActionButton = false
            
        NSUserNotificationCenter.default.deliver(notification)
        
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(token, forType: .string)

        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(2)) {
            NSUserNotificationCenter.default.removeDeliveredNotification(notification)
        }
    }

}
