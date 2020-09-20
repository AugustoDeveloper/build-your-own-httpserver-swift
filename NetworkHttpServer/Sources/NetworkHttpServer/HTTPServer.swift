//
//  File.swift
//  
//
//  Created by Augusto Cesar on 19/09/20.
//

import Foundation

@available(macOS 10.14, *)
public class HTTPServer: TCPServer {
    private var httpConnections:[Int: HTTPClientConnection] = [:]
    public override init(_ port: UInt16) {
        super.init(port)
        
        self.newClientConnected = didClientConnected(client:)
    }
    
    private func didClientConnected(client: TCPClientConnection) {
        let httpClient = HTTPClientConnection(fromTCP: client)
        httpClient.setup()
        
        self.httpConnections[httpClient.id] = httpClient
    }
}
