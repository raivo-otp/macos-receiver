//
//  StatusBarFeature.swift
//  Raivo MacOS
//
//  Created by Tijme Gommers on 02/02/2020.
//  Copyright © 2020 Tijme Gommers. All rights reserved.
//

import Cocoa
import Preferences

extension PreferencePane.Identifier {
    static let general = Identifier("general")
    static let devices = Identifier("devices")
}

class StatusBarFeature: NSObject {

    lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: [
            PreferencePaneHostingController(preferencePaneView: getAppDelegate().generalView),
            PreferencePaneHostingController(preferencePaneView: getAppDelegate().devicesView)
        ],
        style: PreferencesStyle.segmentedControl
    )
    
    @discardableResult
    override init() {
        super.init()
        
        getAppDelegate().statusItem = getStatusItem()
    }
    
    func getStatusItem() -> NSStatusItem {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        statusItem.button?.title = "Raivo"
        statusItem.button?.image = NSImage(named: "menu")
        statusItem.menu = getMenu()
        
        return statusItem
    }
    
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
    
    @objc func onPreferences() {
        preferencesWindowController.show()
    }

    @objc func onAbout() {
        getAppPrincipal().orderFrontStandardAboutPanel(self)
    }

    @objc func onQuit() {
        getAppPrincipal().terminate(self)
    }
    
}
