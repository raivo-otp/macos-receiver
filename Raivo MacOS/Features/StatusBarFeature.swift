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

/// The available panes in the GUI of the app
extension Preferences.PaneIdentifier {
    static let welcome = Self("welcome")
    static let settings = Self("settings")
    static let linking = Self("linking")
    static let support = Self("support")
}

/// The actual status bar app which has a menu, GUI and tab items
class StatusBarFeature: NSObject {
    
    /// Initiate the tabs and associate a title, icon and view
    lazy var preferencesWindowController = PreferencesWindowController(
        panes: [
            Preferences.Pane(
                identifier: .welcome,
                title: getAppDelegate().welcomeView.preferencePaneTitle,
                toolbarIcon: NSImage(named: "MenuIcon")!
            ) {
                getAppDelegate().welcomeView.accentColor(Color("color-tint-red"))
            },
            Preferences.Pane(
                identifier: .settings,
                title: getAppDelegate().settingsView.preferencePaneTitle,
                toolbarIcon: NSImage(systemSymbolName: "gear", accessibilityDescription: "")!
            ) {
                getAppDelegate().settingsView.accentColor(Color("color-tint-red"))
            },
            Preferences.Pane(
                identifier: .linking,
                title: getAppDelegate().linkingView.preferencePaneTitle,
                toolbarIcon: NSImage(systemSymbolName: "qrcode", accessibilityDescription: "")!
            ) {
                getAppDelegate().linkingView.accentColor(Color("color-tint-red"))
            },
            Preferences.Pane(
                identifier: .support,
                title: getAppDelegate().supportView.preferencePaneTitle,
                toolbarIcon: NSImage(systemSymbolName: "questionmark.circle", accessibilityDescription: "")!
            ) {
                getAppDelegate().supportView.accentColor(Color("color-tint-red"))
            }
        ],
        style: .segmentedControl,
        animated: false
    )
    
    /// Initialize the status bar feature by setting the status root item (containing menu items) in the app delegate
    override init() {
        super.init()
        
        getAppDelegate().statusItem = getStatusItem()
    }
    
    /// Build and get the status root item (a Raivo logo with a menu)
    ///
    /// - Returns: The status root item
    func getStatusItem() -> NSStatusItem {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        statusItem.button?.title = "Raivo"
        statusItem.button?.image = NSImage(named: "MenuIcon")
        statusItem.menu = getMenu()
        
        return statusItem
    }
    
    /// Initialize and return the menu that shows on click of the Raivo icon status root item
    ///
    /// - Returns: The menu containing various clickable items, such as 'Preferences'.
    func getMenu() -> NSMenu {
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Raivo OTP v\(AppHelper.version)", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        #if DEBUG
            menu.addItem(NSMenuItem(title: "Debug", action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem.separator())
        #endif
        

        let openItem = NSMenuItem(title: "Open", action: #selector(onOpen), keyEquivalent: "o")
        openItem.target = self
        menu.addItem(openItem)

        let quitItem = NSMenuItem(title: "Quit", action: #selector(onQuit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }
    
    /// Called when a user clicks on the preferences menu item
    @objc func onOpen() {
        preferencesWindowController.show()
        getAppPrincipal().activate(ignoringOtherApps: true)
    }
    
    /// Called when a user clicks on the quit menu item
    ///
    /// - Note: This terminates the application
    @objc func onQuit() {
        getAppPrincipal().terminate(self)
    }
    
}
