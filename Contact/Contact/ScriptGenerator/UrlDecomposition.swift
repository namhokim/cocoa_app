import Foundation

class UrlDecomposition {
    let url : URL
    var lastPart : String {
        get {
            return url.lastPathComponent
        }
    }
    
    var pathPart : String {
        get {
            var fullPath = url.path
            let range = fullPath.index(fullPath.endIndex, offsetBy: -lastPart.count)..<fullPath.endIndex
            fullPath.removeSubrange(range)
            return fullPath
        }
    }
    
    init(_ url: URL) {
        self.url = url
    }
}

// https://forums.swift.org/t/checking-if-a-url-is-a-directory/13842
// https://stackoverflow.com/questions/24208728/check-if-nsurl-is-a-directory
extension URL {
    var isDirectory: Bool {
        let values = try? resourceValues(forKeys: [.isDirectoryKey])
        return values?.isDirectory ?? false
    }
}
