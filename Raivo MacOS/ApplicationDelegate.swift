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

extension PreferencePane.Identifier {
    static let general = Identifier("general")
    static let devices = Identifier("devices")
}

class ApplicationDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet private var window: NSWindow!
    
    var statusItem: NSStatusItem?
    
    lazy var preferences: [PreferencePane] = [
        GeneralPreferencePane(),
        DevicesPreferencePane()
    ]

    lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: preferences,
        style: PreferencesStyle.segmentedControl,
        animated: true,
        hidesToolbarForSingleItem: true
    )
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem!.button?.title = "Raivo"
        statusItem!.button?.image = NSImage(named: "menu")
        
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
        
        statusItem!.menu = menu
    }
    
    @objc func onPreferences() {
        preferencesWindowController.show()
    }
    
    @objc func onAbout() {
        NSApplication.shared.orderFrontStandardAboutPanel(self)
    }
    
    @objc func onQuit() {
        NSApplication.shared.terminate(self)
    }
    
}
