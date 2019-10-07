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

            let pipe = Pipe()
            task.standardOutput = pipe
            let outHandle = pipe.fileHandleForReading
            outHandle.waitForDataInBackgroundAndNotify()

            var processedContent = ""
            var obs1 : NSObjectProtocol!
            obs1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable,
               object: outHandle, queue: nil) {  notification -> Void in
                let data = outHandle.availableData
                if data.count > 0 {
                    if let str = String(data: data, encoding: .utf8) {
                        processedContent += str
                    }
                    outHandle.waitForDataInBackgroundAndNotify()
                } else {
                    //print("EOF on stdout from process")
                    defer {
                        do {
                            try FileManager.default.removeItem(at: path)
                        } catch let error as NSError {
                            print("Fail to remove temporary file: \(error)")
                        }
                    }
                    NotificationCenter.default.removeObserver(obs1)
                }
            }

            var obs2 : NSObjectProtocol!
            obs2 = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification,
                       object: task, queue: nil) { notification -> Void in
                        self.delegate?.processingCompleted(data: processedContent)
                        NotificationCenter.default.removeObserver(obs2)
                }
            task.launch()
        } catch let error as NSError {
            self.delegate?.processingCompleted(data: "Error Writing File : \(error.localizedDescription)")
        }
        
        return command
    }
}
