
import Glibc
import Foundation
import Dispatch
import ZabbixModule

public class RestMetrics {

    // rest.request[method=GET, URL, respPath [,format=json|xml|html, headers={}, body=null]
    // rest.status[method=GET, URL, headers={}, body=null, responseFormat=auto, responseParsedPath]
    // rest.diff[method=GET, URL, headers={}, body=null, responseFormat=auto, responseParsedPath]
    // rest.discovery[method=GET, URL, headers={}, body=null, respFormat=auto, respPath[, sslStrict=1]]

    public static func request(parameters: Array<String> ) throws -> String {
        
        let (verb, url, path, format, headers, body) = try getParams(parameters)
        
        let (responseBody, _, responseFormat) = try RestRequest.call(verb: verb, url: url, body: body)
        guard responseBody != nil else{
            return String()
        }
        
        var finalFormat: String
        if format != nil && !format!.isEmpty{
            finalFormat = format!
        }
        else{
            finalFormat = responseFormat
        }
        let extractor = try ResponseParseHelperHelper.factory(for: finalFormat)
        
        return try extractor.getPath(data: responseBody!, path: path)?
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            ?? ""
    }
    
    public static func status(parameters: Array<String> ) throws -> String {

        let (verb, url, _, _, _, _) = try getParams(parameters)
        
        let (_, statusCode, _) = try RestRequest.call(verb: verb, url: url, parseResponse: false)
        
        return "\(statusCode)"
    }
    

    private static func getParams(_ zbxParams: Array<String>) throws -> (String, String, String, String?, Dictionary<String,String>, String?) {
        
        var verb: String = "GET"
        var url: String
        var path: String = "/"
        var format: String?
        var headers: Dictionary<String,String>
        var body: String?
        
        switch zbxParams.count {
            case 6:
                if !zbxParams[5].isEmpty {
                    body = zbxParams[5]
                }
                fallthrough
            case 5:
                if !zbxParams[4].isEmpty {
                    let headersData = zbxParams[4].data(using: .utf8)
                    headers = try getHeaders(headersData)
                }
                fallthrough
            case 4:
                if !zbxParams[3].isEmpty {
                    format = zbxParams[3]
                }
                fallthrough
            case 3:
                if !zbxParams[2].isEmpty {
                    path = zbxParams[2]
                }
                fallthrough
            case 2:
                if !zbxParams[0].isEmpty {
                    verb = zbxParams[0]
                }
                url = zbxParams[1]
            case 1:
                url = zbxParams[0]
            default:
                throw RestModuleError.BadParameters("\(zbxParams.count) parameters were given, need at least 1 and at most 6")
        }
        
        return (verb, url, path, format, headers, body)
        
    }
    
    private func getHeaders(_ data: Data?) throws -> [String : String] {
        var headers = [String : String]()
        if data == nil{
            return headers
        }
        return headers
    }
}
