import Foundation

func stringsToUrls(_ strings: [String]) -> [URL] {
    var urls : [URL] = []
    for str in strings{
        urls.append(URL(fileURLWithPath: str))
    }
    return urls
}

func stringsToUrls(_ strings: [String], basePath: String) -> [URL] {
    var urls : [URL] = []
    for str in strings{
        urls.append(URL(fileURLWithPath: "\(basePath)/\(str)"))
    }
    return urls
}
