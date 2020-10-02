import Foundation

class ScriptGenerator {
    let urls : [URL]
    
    init(_ urls: [URL]) {
        self.urls = urls
    }
    
    func saveToFile(_ url: URL) -> Bool {
        let data = generateData()
        do {
            try data.write(to: url)
            return true
        } catch let error as NSError {
            let alert = AlertDialog(error)
            alert.showDialogModal()
            return false
        }
    }
    
    private func generateData() -> Data {
        var content = Data.init()
        content.append("#!/bin/bash\n".data(using: .ascii)!)    // shebang
        
        for url in self.urls {
            content.append(#"mv -f ""#.data(using: .ascii)!)
            content.append(url.path.replacingOccurrences(of: "\"", with: "\\\"").data(using: .utf8)!)
            content.append(#"" ""#.data(using: .ascii)!)
            content.append(url.path.precomposedStringWithCanonicalMapping.replacingOccurrences(of: "\"", with: "\\\"").data(using: .utf8)!)
            content.append("\"\n".data(using: .ascii)!)
        }
        
        return content
    }
}
