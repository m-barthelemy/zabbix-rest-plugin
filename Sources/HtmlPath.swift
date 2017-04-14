import Foundation
import Kanna

public class HtmlPath : DataPathExtractor{
    
    public let name = "html"
    
    public func getPath(data: String, path: String) throws -> String?{
        if let doc = HTML(html: data, encoding: .utf8) {
            var content = ""
            for node in doc.xpath(path){
                content += node.innerHTML!
            }
            return content
           
        }
        
        return nil
    }
}
