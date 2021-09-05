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
import Preferences

/// The available panes in the GUI of the app
extension Preferences.PaneIdentifier {
    static let general = Self("general")
    static let scan = Self("scan")
    static let help = Self("help")
}

/// The actual status bar app which has a menu, GUI and tab items
class StatusBarFeature: NSObject {
    
    /// Initiate the tabs and associate a title, icon and view
    lazy var preferencesWindowController = PreferencesWindowController(
        panes: [
            Preferences.Pane(
                identifier: .general,
                title: getAppDelegate().generalView.preferencePaneTitle,
                toolbarIcon: NSImage(systemSymbolName: "gear", accessibilityDescription: "")!
            ) {
                getAppDelegate().generalView
            },
            Preferences.Pane(
                identifier: .scan,
                title: getAppDelegate().scanView.preferencePaneTitle,
                toolbarIcon: NSImage(systemSymbolName: "qrcode", accessibilityDescription: "")!
            ) {
                getAppDelegate().scanView
            },
            Preferences.Pane(
                identifier: .help,
                title: getAppDelegate().helpView.preferencePaneTitle,
                toolbarIcon: NSImage(systemSymbolName: "questionmark.circle", accessibilityDescription: "")!
            ) {
                getAppDelegate().helpView
            }
        ],
        style: .segmentedControl
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

        menu.addItem(NSMenuItem(title: "Raivo OTP " + AppHelper.version, action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        #if DEBUG
            menu.addItem(NSMenuItem(title: "Debug", action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem.separator())
        #endif
        

        let preferencesItem = NSMenuItem(title: "Preferences", action: #selector(onPreferences), keyEquivalent: "p")
        preferencesItem.target = self
        menu.addItem(preferencesItem)

        let aboutItem = NSMenuItem(title: "About", action: #selector(onAbout), keyEquivalent: "a")
        aboutItem.target = self
        menu.addItem(aboutItem)

        let quitItem = NSMenuItem(title: "Quit", action: #selector(onQuit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }
    
    /// Called when a user clicks on the preferences menu item
    @objc func onPreferences() {
        preferencesWindowController.show()
        getAppPrincipal().activate(ignoringOtherApps: true)
    }
    
    /// Called when a user clicks on the about menu item
    ///
    /// - Note: This show's MacOS' standard about panel
    @objc func onAbout() {
        getAppPrincipal().orderFrontStandardAboutPanel(self)
        getAppPrincipal().activate(ignoringOtherApps: true)
    }
    
    /// Called when a user clicks on the quit menu item
    ///
    /// - Note: This terminates the application
    @objc func onQuit() {
        getAppPrincipal().terminate(self)
    }
    
}
