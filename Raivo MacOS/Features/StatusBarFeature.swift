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

import Cocoa
import Preferences

extension Preferences.PaneIdentifier {
    static let general = Self("general")
    static let devices = Self("devices")
}

/// TODO
class StatusBarFeature: NSObject {
    
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
                identifier: .devices,
                title: getAppDelegate().devicesView.preferencePaneTitle,
                toolbarIcon: NSImage(systemSymbolName: "qrcode", accessibilityDescription: "")!
            ) {
                getAppDelegate().devicesView
            }
        ],
        style: .segmentedControl
    )
    
    /// TODO
//    lazy var preferencesWindowController = PreferencesWindowController(
//        preferencePanes: [
//            GeneralPreferenceViewController(),
//            AdvancedPreferenceViewController()
////            getAppDelegate().generalView,
////            getAppDelegate().devicesView
//        ],
//        style: .segmentedControl
//    )
    
    /// TODO
    @discardableResult
    override init() {
        super.init()
        
        getAppDelegate().statusItem = getStatusItem()
    }
    
    /// TODO
    ///
    /// - Returns: TODO
    func getStatusItem() -> NSStatusItem {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        statusItem.button?.title = "Raivo"
        statusItem.button?.image = NSImage(named: "MenuIcon")
        statusItem.menu = getMenu()
        
        return statusItem
    }
    
    /// TODO
    ///
    /// - Returns: TODO
    func getMenu() -> NSMenu {
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Raivo MacOS v0.0.1", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())

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
    
    /// TODO
    @objc func onPreferences() {
        preferencesWindowController.show()
        getAppPrincipal().activate(ignoringOtherApps: true)
    }
    
    /// TODO
    @objc func onAbout() {
        getAppPrincipal().orderFrontStandardAboutPanel(self)
        getAppPrincipal().activate(ignoringOtherApps: true)
    }
    
    /// TODO
    @objc func onQuit() {
        getAppPrincipal().terminate(self)
    }
    
}
