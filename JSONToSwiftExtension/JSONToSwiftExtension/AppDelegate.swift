//
//  AppDelegate.swift
//  JSONToSwiftExtension
//
//  Created by Rickey on 2019/11/15.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = NSWindow(contentRect: .init(origin: .zero,
                                             size: .init(width: NSScreen.main!.frame.midX, height: NSScreen.main!.frame.midY)),
                          styleMask: [.closable],
                          backing: .buffered,
                          defer: false)
        window.title = "New Window"
        window.isOpaque = false
        window.center()
        window.isMovableByWindowBackground = true
        window.backgroundColor = NSColor(calibratedHue: 0, saturation: 1.0, brightness: 0, alpha: 0.7)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func createNewWindow() {
        
    }

}
