//
//  File.swift
//  
//
//  Created by Augusto Cesar on 26/09/20.
//

import Foundation

public class HTTPInterpreter {
    private func createRequest(from rawRequest: inout String) -> HTTPRequest? {
        let firstBreakLine = rawRequest.firstIndex(of: "\r\n")!
        let firstline = rawRequest.prefix(upTo: firstBreakLine)
        let headSpaces = firstline.split(separator: " ")
        if headSpaces.count == 3  {
            let method: HTTPMethod = headSpaces[0].lowercased() == "get" ? .get : .post
            let path = String(headSpaces[1])
            let httpProtocolVersion = String(headSpaces[2])
            
            rawRequest.removeSubrange(rawRequest.startIndex...firstBreakLine)
            return HTTPRequest(on: path, withmethod: method, andProtocol: httpProtocolVersion)
        }
        
        return nil
    }
    
    private func readRequestHeader(from rawRequest: inout String) -> [String: Any?] {
        var headers: [String: Any?] = [:]
        while rawRequest.contains("\r\n") {
            let firstBreakLine = rawRequest.firstIndex(of: "\r\n")!
            let content = String(rawRequest.prefix(upTo: firstBreakLine))
            rawRequest.removeSubrange(rawRequest.startIndex...firstBreakLine)
            
            if content == "" {
                break
            }
            
            if let indexTwoDots = content.firstIndex(of: ":")  {
                let headerKey  = content.prefix(upTo: indexTwoDots)
                let headerValue = content.suffix(from: indexTwoDots)
                
                if !headerKey.isEmpty {
                    headers[String(headerKey)] = String(headerValue)
                }
            }
        }
        
        return headers
    }

    public func interpret(raw rawRequest: String) -> HTTPRequest? {
        var textRequest = rawRequest
        
        let request = createRequest(from: &textRequest)
        request?.headers = readRequestHeader(from: &textRequest)
        request?.content = textRequest
        
        return request
    }
}
