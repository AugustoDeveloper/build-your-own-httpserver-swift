//
//  File.swift
//  
//
//  Created by Augusto Cesar on 26/09/20.
//

import Foundation
public class HTTPRequest {
    let method: HTTPMethod
    let path: String
    let protocolVersion: String
    var content: String = ""
    var headers: [String: Any?] = [:]
    var fromRoute: [String: Any?] = [:]
    var fromQuery: [String: String?] = [:]
    
    init(on path: String, withmethod method: HTTPMethod, andProtocol protocolVersion: String) {
        self.path = path
        self.method = method
        self.protocolVersion = protocolVersion
    }
    
    init(on path: String, withmethod method: HTTPMethod, andHeaders headers: [String: Any?], andProtocol protocolVersion: String, content: String?) {
        self.path = path
        self.method = method
        self.headers = headers
        self.protocolVersion = protocolVersion
    }
}
