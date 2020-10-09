//
//  AppDelegate.swift
//  Contact
//
//  Created by namo on 20-10-1.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }
    
    
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        let rootViewController = NSApplication.shared.mainWindow?.windowController?.contentViewController as! ViewController
        let fileUrls : [URL] = stringsToUrls(filenames)
        rootViewController.processing(fileUrls)
    }
    
    private func stringsToUrls(_ strings: [String]) -> [URL] {
        var urls : [URL] = []
        for str in strings{
            urls.append(URL(fileURLWithPath: str))
        }
        return urls
    }
    
}

