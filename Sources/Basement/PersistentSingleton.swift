import Foundation

public protocol PeristentSingleton: Codable {
    static var urlName: String {get}
    
    init()
    
}

extension PeristentSingleton {
    public static var url: URL {fileSystem.documentsURL.appendingPathComponent(urlName,isDirectory: false).appendingPathExtension("json")}
    
    public static func load() -> Self {
        return FileManager.default.fileExists(atPath: url.path) ? fileSystem.load(this: Self.self, from: url) : .init()
    }

}
