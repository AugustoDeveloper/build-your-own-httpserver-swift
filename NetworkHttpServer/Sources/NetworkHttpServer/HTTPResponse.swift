//
//  File.swift
//  
//
//  Created by Augusto Cesar on 05/10/20.
//

import Foundation

public class HTTPResponse {
    public let content: String?
    public let protocolVersion: String
    public let contentType: String
    public let statusCode: HTTPStatusCode
    public var contentLength: Int { get { self.content?.count ?? 0 } }
    
    public init(statusCode: HTTPStatusCode, protocolVersion: String, contentType: String) {
        self.contentType = contentType
        self.protocolVersion = protocolVersion
        self.statusCode = statusCode
        self.content = ""
    }
    
    public init(statusCode: HTTPStatusCode, content: String?, protocolVersion: String, contentType: String) {
        self.content = content
        self.contentType = contentType
        self.protocolVersion = protocolVersion
        self.statusCode = statusCode
    }
    
    
    public func data(using encoding: String.Encoding) -> Data {
        let responseHeader = "\(protocolVersion) \(statusCode.rawValue) \(statusCode)"
        let serverHeader = "Server: SwiftHttpServerCLI/0.1"
        let contentTypeHeader = "Content-Type: \(contentType)"
        let contentLengthHeader = "Content-Length:\(contentLength)"
        let response = "\(responseHeader)\n\(serverHeader)\n\(contentTypeHeader)\n\(contentLengthHeader)\n\n\(content ?? "")"
        return response.data(using: encoding)!
    }
}
