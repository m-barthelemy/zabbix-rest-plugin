import Foundation

protocol DataPathExtractor{
    
    var name: String {get}
    func getPath(data: String, path: String) throws -> String?
    
}
