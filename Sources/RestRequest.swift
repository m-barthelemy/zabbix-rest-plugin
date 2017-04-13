import Glibc
import Foundation
import Dispatch
import ZabbixModule

public class RestRequest {
    
    public static func call(verb: String = "GET", url: String, headers: Dictionary<String,String>? = nil, body: String? = nil, parseFormat: String? = nil, parseResponse: Bool = true) throws -> (String, Int, String) {
        
        
        var result: String = ""
        var statusCode = 0
        var resultFormat: String = ""
        var exception: Error?
        
        var config: URLSessionConfiguration!
        var urlSession: URLSession!
        
        config = URLSessionConfiguration.default //URLSessionConfiguration.ephemeral
        urlSession = URLSession(configuration: config)
        
        let HTTPHeaderField_ContentType  = "Content-Type"
        let ContentType_ApplicationJson  = "application/json"
        
        let callURL = URL.init(string: url)
        var request = URLRequest.init(url: callURL!)
        
        // See if it should be the default Zabbix.Timeout
        request.timeoutInterval = 10.0 // TimeoutInterval in Second
        request.addValue(ContentType_ApplicationJson, forHTTPHeaderField: HTTPHeaderField_ContentType)
        request.httpMethod = verb
        request.httpBody = body?.data(using: .utf8)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = urlSession //.dataTask(with: request) { (data,response,error) in
            .dataTask(with: request, completionHandler: { data, response, error in
            if let redirected = response?.url{
                Zabbix.log(message: "[zbx-rest] DEBUG Got redirected to \(response?.url)")
            }
            if error != nil{
                exception = error
                Zabbix.log(message: "[zbx-rest]: \(verb) to '\(url)' error: \(exception!.localizedDescription)")
                //semaphore.signal()
            }
            guard response != nil else{
                Zabbix.log(message: "[zbx-rest] DEBUG Response is NIL")
                if exception == nil{
                    exception = RestModuleError.BadResponseFormat("Got null response")
                }
                semaphore.signal()
                return
            }
                
            let contentLength = response!.expectedContentLength
            
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                let responseType = httpResponse.allHeaderFields["Content-Type"]
            }
                
            Zabbix.log(message: "[zbx-rest]: \(verb) to '\(url)' returned HTTP \(statusCode), content type \(response!.mimeType), size \(contentLength) B")
            
            if let format = response!.mimeType {
                resultFormat = format
                Zabbix.log(message: "[zbx-rest] DEBUG respFormat=\(resultFormat)")
                
                /*if self.formats.filter({ resultFormat.hasSuffix($0) }).count == 0 && parseFormat == nil {
                    
                    exception = RestModuleError.BadResponseFormat("Response Content-Type '\(resultFormat)' is unsupported.")
                    Zabbix.log(message: "[zbx-rest] DEBUG exception= \(exception)")
                    semaphore.signal()
                }*/
            }
            
            /*do {
                let resultJson : Any? = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print("JSON Result=",resultJson!)
                result = "\(resultJson)"
            } catch {
                exception = error
                //return
            }*/
            semaphore.signal() // at this point we're done and have the response data
            
        })
        
        dataTask.resume()
        semaphore.wait()
        //Zabbix.log(message: "[zbx-rest]: DEBUG after semaphore.wait()")
        if exception != nil {
            throw exception!
        }
        return (result, statusCode, resultFormat)
        
    }
}
