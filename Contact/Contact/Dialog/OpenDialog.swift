import Cocoa

class OpenDialog {
    let panel: NSOpenPanel
    
    init() {
        panel = NSOpenPanel()
        
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.resolvesAliases = false
        panel.allowsMultipleSelection = true
    }
    
    func showModal() -> [URL] {
        if (panel.runModal() == NSApplication.ModalResponse.OK) {
            if (panel.urls.count > 0) {
                return panel.urls
            }
        }
        return []
    }
}
