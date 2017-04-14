import Foundation
import Kanna

public class XmlPath : DataPathExtractor{
    
    public let name = "xml"
    
    public func getPath(data: String, path: String) throws -> String?{
        if let doc = Kanna.XML(xml: data, encoding: .utf8) {
            var content = ""
            for node in doc.xpath(path){
                content += node.innerHTML!
            }
            return content
        }
        return nil
    }
}
