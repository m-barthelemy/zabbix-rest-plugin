import Foundation
import Kanna

public class HtmlPath : DataPathExtractor{
    
    public let name = "html"
    
    public func getPath(data: String, path: String) throws -> String?{
        if let doc = HTML(html: data, encoding: .utf8) {
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
