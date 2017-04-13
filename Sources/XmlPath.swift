import Foundation
import Kanna

public class XmlPath : DataPathExtractor{
    
    public let name = "xml"
    
    public func getPath(data: String, path: String) throws -> String?{
        if let doc = Kanna.XML(xml: data, encoding: .utf8) {
            //print(doc.title)
            
            // Search for nodes by XPath
            return "\(doc.xpath(path))"
            //for link in doc.xpath(path) {
            //print(link.text)
            //}
        }
        return nil
    }
}
