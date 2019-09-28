//
//  Utility.swift
//  SimplisticDragon
//
//  Created by AJ Caldwell on 9/28/19.
//  Copyright © 2019 Optional(Default). All rights reserved.
//

import Foundation

/* Notes:
 * - Run Shell Scripts: https://stackoverflow.com/questions/26971240/how-do-i-run-an-terminal-command-in-a-swift-script-e-g-xcodebuild
 * - Run/Embed Node: https://ind.ie/labs/blog/gracefully-running-node-as-an-nstask-in-cocoa/
 */

func shell(launchPath: String, arguments: [String]) -> String? {
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: String.Encoding.utf8)

    return output
}

enum ScriptError: Error {
    case NodeNotFound
    case ScriptNotFound(String)
    case Runtime

    var localizedDescription: String {
        switch self {
        case .NodeNotFound:
            return "Failed to find node."
        case .ScriptNotFound(let name):
            return "Failed to find script: \(name)"
        case .Runtime:
            return "Failed while running script"
        }
    }
}

func runScript(named name: String, with arguments: [String]) throws -> String {
    let bundle = Bundle.main

    guard let nodePath = bundle.path(forResource: "node", ofType: nil, inDirectory: "node-v10.16.3-darwin-x64/bin") else {
        throw ScriptError.NodeNotFound
    }
    guard let scriptPath = bundle.path(forResource: name, ofType: "js", inDirectory: "js") else {
        throw ScriptError.ScriptNotFound(name)
    }
    guard let result = shell(launchPath: nodePath, arguments: [scriptPath] + arguments) else {
        throw ScriptError.Runtime
    }

    return result
}
