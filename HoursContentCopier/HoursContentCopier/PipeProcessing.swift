//
//  PipeProcessing.swift
//  HoursContentCopier
//
//  Created by namho.kim on 07/10/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import Foundation

protocol CompletePostProcessingDelegate {
    func processingCompleted(data: String)
}

class PipeProcessing {
    var filename : String
    var delegate: CompletePostProcessingDelegate?
    init(delegate: CompletePostProcessingDelegate) {
        filename = UUID.init().uuidString
        self.delegate = delegate
    }
    
    func processPipe(content: String, command: String) -> String {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let path = documentsDirectory.appendingPathComponent(self.filename)
            try content.write(to: path, atomically: true, encoding: .utf8)
            
            let task = Process()
            task.launchPath = "/bin/sh"
            task.arguments = ["-c", "cat \(path.path) | \(command.utf8)"]
            task.standardOutput = Pipe()
            task.terminationHandler = { task in
                guard task.terminationStatus == 0
                else {
                    NSLog("The process fail to operate.")
                    return
                }
                
                guard let data = (task.standardOutput as? Pipe)?.fileHandleForReading.availableData,
                data.count > 0,
                let s = String(data: data, encoding: .utf8)
                else { return }
                self.delegate?.processingCompleted(data: s)
                do {
                    try FileManager.default.removeItem(at: path)
                } catch let error as NSError {
                    NSLog("Fail to remove temporary file: \(error)")
                }
            }
            task.launch()
        } catch let error as NSError {
            self.delegate?.processingCompleted(data: "Error with: \(error.localizedDescription)")
        }
        
        return command
    }
}
