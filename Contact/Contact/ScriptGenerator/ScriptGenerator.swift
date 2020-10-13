import Foundation

class ScriptGenerator {
    let urls: [URL]
    
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
        content.append(generateShebang())
        content.append(generateRenameScript(self.urls))
        return content
    }
    
    private func generateShebang() -> Data {
        var content = Data.init()
        content.append("#!/bin/bash\n".data(using: .ascii)!)
        return content
    }
    
    private func generateRenameScript(_ urls: [URL]) -> Data {
        var content = Data.init()
        
        for url in urls {
            if url.isDirectory && !url.path.hasSuffix(".app") {
                let subpaths = try! FileManager.default.contentsOfDirectory(atPath: url.path)
                let subUrls = stringsToUrls(subpaths, basePath: url.path)
                content.append(generateRenameScript(subUrls))
            }
            
            if url.isHidden {   // eg. .DS_Store
                continue
            }
            
            let decomp = UrlDecomposition(url)
            let path = decomp.pathPart.replacingOccurrences(of: "\"", with: "\\\"")
            let file = decomp.lastPart.replacingOccurrences(of: "\"", with: "\\\"")
            
            content.append(#"mv -f ""#.data(using: .ascii)!)
            content.append(path.data(using: .utf8)!)
            content.append(file.data(using: .utf8)!)
            content.append(#"" ""#.data(using: .ascii)!)
            content.append(path.data(using: .utf8)!)
            content.append(file.precomposedStringWithCanonicalMapping.data(using: .utf8)!)
            content.append("\"\n".data(using: .ascii)!)
        }
        
        return content
    }
    
}

extension URL {
    /// `true` is hidden (invisible) or `false` is not hidden (visible)
    var isHidden: Bool {
        get {
            return (try? resourceValues(forKeys: [.isHiddenKey]))?.isHidden == true
        }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.isHidden = newValue
            do {
                try setResourceValues(resourceValues)
            } catch {
                print("isHidden error:", error)
            }
        }
    }
}
