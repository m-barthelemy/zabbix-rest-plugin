//
//  FlexJsonHelper.swift
//  zabbix-mongo
//
//  Created by Matthieu Barthélemy on 5/16/16.
//
//

import Glibc
import Foundation
import SwiftyJSON
import POSIX

/// Quick helper to extract data or values from JSON using a path-like syntax, remotely inspired by XPath
public class JsonPath: DataPathExtractor{
    
    public let name = "json"
    
    enum PathError : Error {
        case BadPath(String)    // Invalid result path syntax
    }
    
    enum DataError : Error {
        case UnparseableJson(String)    // Unable to parse JSON returned by MongoDB
    }
    
    /// Gets the data located at specified path.
    /// - Parameter json: the JSON document to be searched
    /// - Parameter path: path of data to extract and return, path separator being '/'
    /// - Returns: the extracted data, as a string. Non single values (subdocuments, arrays)
    ///   are returned as JSON
    public func getPath(data: String, path: String) throws -> String? {
        
        
        var searchPath = path
        if searchPath.isEmpty {
            searchPath = "/"
        }
        
        let jdata:Data? = data.data(using: .utf8)
        guard jdata != nil else{
            throw DataError.UnparseableJson("Cannot parse Mongo result data")
        }
        
        let jsonObject : Any? = try JSONSerialization.jsonObject(with: jdata!, options: .mutableContainers)
        let jsonDoc = JSON(jsonObject!)
        
        let pathComponents = searchPath.components(separatedBy: "/")
        var pathSubscript:[JSONSubscriptType] = []
        
        for index:Int in 0..<Int(pathComponents.count) {
            
            let pathPart = String(pathComponents[index])!
            if pathPart.isEmpty {
                // path starting or ending with "/" is okay, ignore their null values
                if index == 0 || index == pathComponents.count - 1 {
                    continue
                }
                // we were asked to extract something//somethingelse, this is invalid
                else{
                    throw PathError.BadPath("Empty path component at position \(index)")
                }
            }
            
            // basic Xpath location syntax http://www.way2tutorial.com/xml/xpath_location_path_expression_with_examples.php
            // TODO: support XPath-like item[@attribute=....] selector
            // TODO: validate matches, make sure no weird values like /[0]blubla[heyho] are permitted
            let regex = try Regex("(\\w*)\\[([0-9]+)\\]$")
            if pathPart.matches(regex) {
                let matched = pathPart.groupsMatching(regex)
                
                if matched.count != 2 {
                    throw PathError.BadPath("Path component '\(pathPart)' is invalid.")
                }
                //if matched.count == 2 {
                    if !matched[0].isEmpty {
                        // for compatibility with Xpath we also accept "@attributename" like syntax
                        // even if it doesn't really make sense with JDON (no attributes so we treat it like a property)
                        let trimChars = CharacterSet(charactersIn: "@")
                        let property = matched[0].trimmingCharacters(in: trimChars)
                        pathSubscript.append(matched[0])
                    } // else path wants to find an array element by index (type /[i])
                    pathSubscript.append(Int(matched[1])!)
                //}
            }
            else{
                pathSubscript.append(pathPart)
            }
        }
        return jsonDoc[pathSubscript].rawString()
    }
    
}
