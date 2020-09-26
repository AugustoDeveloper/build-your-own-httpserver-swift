//
//  File.swift
//  
//
//  Created by Augusto Cesar on 26/09/20.
//

import Foundation

public protocol HTTPRoute {
    var method: HTTPMethod { get }
    var path: String { get }
    var routeHandler: ((HTTPRequest) -> HTTPResponse) { get set}
    
    func execute(request: HTTPRequest) -> HTTPResponse
}

class HTTPPostRoute : HTTPRoute {
    var routeHandler: ((HTTPRequest) -> HTTPResponse)
    
    var method: HTTPMethod
    var path: String
    
    init(on path: String, method: HTTPMethod, handler: @escaping ((HTTPRequest) -> HTTPResponse)) {
        self.path = path
        self.method = method
        self.routeHandler = handler
    }
    
    func execute(request: HTTPRequest) -> HTTPResponse {
        return routeHandler(request)
    }
}

class HTTPGetRoute : HTTPRoute {
    var routeHandler: ((HTTPRequest) -> HTTPResponse)
    
    var method: HTTPMethod
    
    var path: String
    
    init(on path: String, method: HTTPMethod, handler: @escaping ((HTTPRequest) -> HTTPResponse)) {
        self.path = path
        self.method = method
        self.routeHandler = handler
    }
    
    func execute(request: HTTPRequest) -> HTTPResponse {
        return routeHandler(request)
    }
}
