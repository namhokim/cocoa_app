import Cocoa

class SaveDialog {
    let panel: NSSavePanel
    
    init() {
        panel = NSSavePanel()
        
        panel.title = NSLocalizedString("Save to create", comment: "enableFileMenuItems")
        panel.nameFieldStringValue = UUID.init().uuidString
        panel.isExtensionHidden = false
        panel.prompt = NSLocalizedString("Create", comment: "enableFileMenuItems")
        panel.allowedFileTypes = ["sh"]
        panel.directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
    }
    
    func showModal() -> URL? {
        let fileManager = FileManager.default
        
        if (panel.runModal() == NSApplication.ModalResponse.OK) {
            let fileWithExtensionURL = self.panel.url!  //  May test that file does not exist already
            if fileManager.fileExists(atPath: fileWithExtensionURL.path) {
            } else {
                return panel.url
            }
        }
        
        return nil
    }
}
