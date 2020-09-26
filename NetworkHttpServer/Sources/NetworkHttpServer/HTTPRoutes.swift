//
//  File.swift
//  
//
//  Created by Augusto Cesar on 26/09/20.
//

import Foundation

public class HTTPRoutes {
    var allGetPathsWithRoutes: [String: HTTPRoute] = [:]
    var allPostPathsWithRoutes: [String: HTTPRoute] = [:]
    
    public func findRoute(as method: HTTPMethod, withPath path: String) -> HTTPRoute? {
        switch method {
        case .get:
            
            if let route = allGetPathsWithRoutes[path] {
                return route
            }
            break
        case .post:
            if let route = allPostPathsWithRoutes[path] {
                return route
            }
            break
        }
        
        return nil
    }
    
    //TODO: Support to parametrize the path
    
    public func on(on path: String, as method: HTTPMethod, action: @escaping ((_ body: HTTPRequest) -> HTTPResponse)) {
        if method == .get {
            allGetPathsWithRoutes[path] = HTTPGetRoute(on: path, method: method, handler: action)
        } else if method == .post {
            allPostPathsWithRoutes[path] = HTTPPostRoute(on: path, method: method, handler: action)
        }
    }
}
