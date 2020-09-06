import Foundation

public let fileSystem = FileSystem()
public class FileSystem {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    public func save<T:Codable>(this: T, to: URL) {
        let data = try! encoder.encode(this)
        try! data.write(to: to)
    }
    
    public func load<T:Codable>(this: T.Type, from: URL) -> T {
        let data = try! Data(contentsOf: from)
        return try! decoder.decode(this, from: data)
    }
}
