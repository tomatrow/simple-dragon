//
//  AppDelegate.swift
//  SimplisticDragon
//
//  Created by AJ Caldwell on 9/28/19.
//  Copyright © 2019 Optional(Default). All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        runExampleScript()
    }
}

func runExampleScript() {
    do {
        let output = try runScript(named: "hello", with: ["AJ", "Tristan", "Sam"])
        print(output)
    } catch let e {
        print(e.localizedDescription)
    }
}
