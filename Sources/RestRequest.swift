import Glibc
import Foundation
import Dispatch
import ZabbixModule

public class RestRequest {
    
    public static func call(verb: String = "GET", url: String, headers: Dictionary<String,String>? = nil,
                            body: String? = nil, parseFormat: String? = nil, parseResponse: Bool = true) throws -> (String?, Int, String) {
        
        
        var result: String?
        var statusCode = 0
        var resultFormat: String = ""
        var exception: Error?
        
        let config: URLSessionConfiguration! = URLSessionConfiguration.default
        let urlSession: URLSession! = URLSession(configuration: config)
        
        let HTTPHeaderField_ContentType  = "Content-Type"
        let ContentType_ApplicationJson  = parseFormat ?? "application/json"
        
        let callURL = URL.init(string: url)
        var request = URLRequest.init(url: callURL!)
        
        // See if it should be the default Zabbix.Timeout
        request.timeoutInterval = 15.0 // TimeoutInterval in Second
        request.addValue(ContentType_ApplicationJson, forHTTPHeaderField: HTTPHeaderField_ContentType)
        request.httpMethod = verb
        request.httpBody = body?.data(using: .utf8)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = urlSession //.dataTask(with: request) { (data,response,error) in
            .dataTask(with: request, completionHandler: { data, response, error in
            if let redirected = response?.url{
                // As of Swift 3.1.0, Redirects always fail with a generic error on Linux, thus making them unusable.
                Zabbix.log(message: "[zbx-rest] DEBUG Got redirected to \(response?.url)")
            }
            if error != nil{
                exception = error
                Zabbix.log(message: "[zbx-rest]: \(verb) to '\(url)' error: \(exception!.localizedDescription)")
            }
                
            guard response != nil else{
                // No response, so we cannot continue and process it. Early return with, hopefully, an exception
                // telling why we have no response data. If not, set e generic exception.
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
            }
                
            result = String(data: data!, encoding: .utf8)
            semaphore.signal() // at this point we're done and have the response data
        })
        
        dataTask.resume()
        semaphore.wait()
        
        if exception != nil {
            throw exception!
        }
        
        return (result, statusCode, resultFormat)
        
    }
}
