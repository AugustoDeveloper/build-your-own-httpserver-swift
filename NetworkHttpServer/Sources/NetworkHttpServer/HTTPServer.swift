//
//  File.swift
//  
//
//  Created by Augusto Cesar on 19/09/20.
//

import Foundation

@available(macOS 10.14, *)
public class HTTPServer: TCPServer {
    private var httpConnections:[Int: DefaultHTTPClientConnection] = [:]
    public private(set) var routes: HTTPRoutes
    
    public override init(_ port: UInt16) {
        self.routes = HTTPRoutes()
        super.init(port)
        
        self.newClientConnected = didClientConnected(client:)
    }
    
    private func didClientConnected(client: TCPClientConnection) {
        let httpClient = DefaultHTTPClientConnection(fromTCP: client, interpreter: HTTPInterpreter(), routes: routes)
        httpClient.setup()
        
        self.httpConnections[httpClient.id] = httpClient
    }    
}
