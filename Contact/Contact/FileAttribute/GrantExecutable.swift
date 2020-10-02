import Foundation

func grantExecutable(_ target: URL) {
    let taskChmod = Process()
    taskChmod.launchPath = "/bin/chmod"
    taskChmod.arguments = ["+x", target.path]
    taskChmod.terminationHandler = { task in
        guard task.terminationStatus == 0
        else {
            let errorMsg = "The process fail to operate. \(task.terminationStatus)"
            let dialog = AlertDialog(errorMsg)
            dialog.showDialogModal()
            return
        }
    }
    taskChmod.launch()
}
