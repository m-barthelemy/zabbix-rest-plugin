
import Glibc
import Foundation
import Dispatch
import ZabbixModule

public class RestMetrics {

    // rest.request[method=GET, URL, headers={}, body=null, respPath [,forormat=auto|json|xml|html, strictSsl=1=1]]
    // rest.status[method=GET, URL, headers={}, body=null, responseFormat=auto, responseParsedPath]
    // rest.diff[method=GET, URL, headers={}, body=null, responseFormat=auto, responseParsedPath]
    // rest.discovery[method=GET, URL, headers={}, body=null, respFormat=auto, respPath[, sslStrict=1]]

    public static func request(parameters: Array<String> ) throws -> String {
        
        let (verb, url, path) = try getParams(parameters)
        
        let (responseBody, _, format) = try RestRequest.call(verb: verb, url: url)
        
        let extractor = try ResponseParseHelperHelper.factory(for: format)
        
        return try extractor.getPath(data: responseBody, path: path) ?? ""
    }
    
    public static func status(parameters: Array<String> ) throws -> String {

        let (verb, url, path) = try getParams(parameters)
        
        let (_, statusCode, _) = try RestRequest.call(verb: verb, url: url, parseResponse: false)
        
        return "\(statusCode)"
    }
    

    private static func getParams(_ zbxParams: Array<String>) throws -> (String, String, String) {
        var verb: String = "GET"
        var url: String
        var path: String = "/"
        
        switch zbxParams.count  {
            
        case 1:
            url = zbxParams[0]
            
        case 2:
            if !zbxParams[0].isEmpty{
                verb = zbxParams[0]
            }
            url = zbxParams[1]
        case 3:
            if !zbxParams[0].isEmpty{
                verb = zbxParams[0]
            }
            url = zbxParams[1]
            if !zbxParams[2].isEmpty{
                path = zbxParams[2]
            }
        default:
            throw RestModuleError.BadParameters("\(zbxParams.count) parameters were given, need at least 1 and at most 4")
        }
        return (verb, url, path)
        
    }
}
