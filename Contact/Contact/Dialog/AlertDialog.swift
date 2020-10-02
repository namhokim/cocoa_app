import Cocoa

class AlertDialog {
    let alert : NSAlert
    
    init(_ error: NSError) {
        alert = NSAlert()
        
        alert.messageText = "Failed"
        alert.informativeText = error.localizedDescription
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
    }
    
    init(_ message: String) {
        alert = NSAlert()
        
        alert.messageText = "Failed"
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
    }
    
    func showDialogModal() {
        alert.runModal()
    }
}
