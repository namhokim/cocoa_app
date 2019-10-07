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
    
    func processPipe(content: String, command: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            // file
            let tmpFilePath = documentsDirectory.appendingPathComponent(self.filename)
            try content.write(to: tmpFilePath, atomically: true, encoding: .utf8)
            
            // shell
            let tmpShFilePath = documentsDirectory.appendingPathComponent("\(self.filename).sh")
            let postProcCmd = "cat \(tmpFilePath.path) | \(command.utf8)"
            try postProcCmd.write(to: tmpShFilePath, atomically: true, encoding: .utf8)
            
            // chmod
            self.cmhod(tmpShFilePath: tmpShFilePath, tmpFilePath: tmpFilePath)
        } catch let error as NSError {
            self.delegate?.processingCompleted(data: "Error with: \(error.localizedDescription)")
        }
    }
    
    private func cleanTmpFile(tmpFilePath: URL, tmpShFilePath: URL) {
        do {
            try FileManager.default.removeItem(at: tmpFilePath)
            try FileManager.default.removeItem(at: tmpShFilePath)
        } catch let error as NSError {
            NSLog("Fail to remove temporary file: \(error)")
        }
    }
    
    private func cmhod(tmpShFilePath: URL, tmpFilePath: URL) {
        let taskChmod = Process()
        taskChmod.launchPath = "/bin/chmod"
        taskChmod.arguments = ["+x", tmpShFilePath.path]
        taskChmod.terminationHandler = { task in
            guard task.terminationStatus == 0
            else {
                NSLog("The process fail to operate. \(task.terminationStatus)")
                self.cleanTmpFile(tmpFilePath: tmpFilePath, tmpShFilePath: tmpShFilePath)
                return
            }
            
            self.execShellScript(tmpShFilePath: tmpShFilePath, tmpFilePath: tmpFilePath)
        }
        taskChmod.launch()
    }
    
    private func execShellScript(tmpShFilePath: URL, tmpFilePath: URL) {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = [tmpShFilePath.path]
        task.standardOutput = Pipe()
        task.terminationHandler = { task in
            guard task.terminationStatus == 0
            else {
                NSLog("The process fail to operate. \(task.terminationStatus)")
                self.cleanTmpFile(tmpFilePath: tmpFilePath, tmpShFilePath: tmpShFilePath)
                return
            }
            
            guard let data = (task.standardOutput as? Pipe)?.fileHandleForReading.availableData,
            data.count > 0,
            let s = String(data: data, encoding: .utf8)
            else { return }
            self.delegate?.processingCompleted(data: s)
            self.cleanTmpFile(tmpFilePath: tmpFilePath, tmpShFilePath: tmpShFilePath)
        }
        task.launch()
    }
}
