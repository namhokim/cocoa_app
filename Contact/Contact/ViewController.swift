//
//  ViewController.swift
//  Contact
//
//  Created by 김남호 on 20-10-1.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func openDialog(_ sender: Any) {
        let panel = NSOpenPanel();
        panel.canChooseFiles = true;
        panel.canChooseDirectories = false;
        panel.resolvesAliases = false;
        panel.allowsMultipleSelection = true;
        
        if (panel.runModal() == NSApplication.ModalResponse.OK) {
            if (panel.urls.count > 0) {
                let shellFileUrl = createScript(panel.urls)
                if (shellFileUrl != nil) {
                    cmhod(shellFileUrl!)
                }
            }
        }
    }
    
    private func createScript(_ urls: [URL]) -> URL? {
        let filename = UUID.init().uuidString
        let desktopDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let tmpFilePath = desktopDirectory.appendingPathComponent(filename + ".sh")
        var content = Data.init()
        content.append("#!/bin/bash\n".data(using: .ascii)!)    // shebang
        
        for url in urls {
            content.append(#"mv -f '"#.data(using: .ascii)!)
            content.append(url.path.data(using: .utf8)!)
            content.append(#"' '"#.data(using: .ascii)!)
            content.append(url.path.precomposedStringWithCanonicalMapping.data(using: .utf8)!)
            content.append("'\n".data(using: .ascii)!)
        }
        
        do {
            try content.write(to: tmpFilePath)
        } catch let error as NSError {
            let alert = NSAlert()
            alert.messageText = "Failed"
            alert.informativeText = error.localizedDescription
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
            return nil
        }

        return tmpFilePath
    }
    
    private func cmhod(_ tmpShFilePath: URL) {
        let taskChmod = Process()
        taskChmod.launchPath = "/bin/chmod"
        taskChmod.arguments = ["+x", tmpShFilePath.path]
        taskChmod.terminationHandler = { task in
            guard task.terminationStatus == 0
            else {
                NSLog("The process fail to operate. \(task.terminationStatus)")
                self.cleanTmpFile(tmpShFilePath)
                return
            }
            
            self.execShellScript(tmpShFilePath)
        }
        taskChmod.launch()
    }
    
    private func execShellScript(_ tmpShFilePath: URL) {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = [tmpShFilePath.path]
        task.standardOutput = Pipe()
        task.terminationHandler = { task in
            guard task.terminationStatus == 0
            else {
                NSLog("The process fail to operate. \(task.terminationStatus)")
                self.cleanTmpFile(tmpShFilePath)
                return
            }
            
            self.cleanTmpFile(tmpShFilePath)
        }
        task.launch()
    }
    
    private func cleanTmpFile(_ tmpShFilePath: URL) {
        do {
            try FileManager.default.removeItem(at: tmpShFilePath)
        } catch let error as NSError {
            NSLog("Fail to remove temporary file: \(error)")
        }
    }
    
}

