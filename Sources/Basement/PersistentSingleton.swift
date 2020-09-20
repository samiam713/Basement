import Foundation

// a protocol an object implements if it is loaded from filesystem at program launch time and saved at program termination time
public protocol PersistentObject: Codable {
    static var singleton: Self {get}
    static var uniquePath: String {get}
    static func loadNew() -> Self
}

extension PersistentObject {
    
    public static func uniqueURL() -> URL {fileSystem.jsonURL(fromPath: uniquePath)}
    
    public func save() {
        fileSystem.save(this: self, to: Self.uniqueURL())
    }
    
    public static func load() -> Self {
        let url = uniqueURL()
        return FileManager.default.fileExists(atPath: url.path) ? fileSystem.load(this: Self.self, from: url) : loadNew()
    }
}
