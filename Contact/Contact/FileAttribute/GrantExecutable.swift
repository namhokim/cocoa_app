import Foundation

func grantExecutable(_ target: URL) {
    executeProcess("/bin/chmod", ["+x", target.path]);
}

func executeShellScript(_ scriptFile: URL) {
    executeProcess("/bin/sh", [scriptFile.path]);
}

func deleteFile(_ target: URL) {
    do {
        try FileManager.default.removeItem(at: target)
    } catch let error as NSError {
        let dialog = AlertDialog(error)
        dialog.showDialogModal()
    }
}

func generateTemporaryFilePath() -> URL {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileName = NSUUID().uuidString
    return documentsDirectory.appendingPathComponent("\(fileName).sh")
}


private func executeProcess(_ command: String, _ arguments: [String]) {
    let task = Process()
    task.launchPath = command
    task.arguments = arguments
    task.standardOutput = Pipe()
    task.terminationHandler = { task in
        guard task.terminationStatus == 0
        else {
            NSLog("The process fail to operate. status = \(task.terminationStatus), reason = \(task.terminationReason)")
            return
        }
    }
    task.launch()
    task.waitUntilExit()
}
