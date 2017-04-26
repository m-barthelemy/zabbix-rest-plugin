import Foundation


enum FormatError : Error {
    case UnsupportedDataFormat(String)
}

enum ResponseParseHelperHelper {
    
    static let formats = ["html","json","xml"]
    
    static func factory(for responseFormat: String) throws -> DataPathExtractor {
        if let val =  self.formats.filter({ responseFormat.hasSuffix($0) }).first {
            switch val {
                case "json":
                    return JsonPath()
                case "xml":
                    return XmlPath()
                case "html":
                    return HtmlPath()
                default:
                    throw FormatError.UnsupportedDataFormat("Unsupported response format \(responseFormat)")
            }
        }
        
        throw FormatError.UnsupportedDataFormat("Unsupported response format \(responseFormat)")
    }
    
}
