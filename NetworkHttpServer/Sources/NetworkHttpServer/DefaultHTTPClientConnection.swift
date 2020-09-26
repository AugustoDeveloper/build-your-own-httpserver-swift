//
//  File.swift
//  
//
//  Created by Augusto Cesar on 19/09/20.
//

import Foundation

@available(macOS 10.14, *)
public class DefaultHTTPClientConnection {
    var id: Int { get { return self.currentTCPClientConnection.id } }
    let currentTCPClientConnection: TCPClientConnection
    let interpreter: HTTPInterpreter
    let routes: HTTPRoutes
    
    public init(fromTCP client: TCPClientConnection, interpreter: HTTPInterpreter, routes: HTTPRoutes) {
        self.currentTCPClientConnection = client
        self.interpreter = interpreter
        self.routes = routes
    }
    
    public func setup() {
        self.currentTCPClientConnection.didReceiveFrom = didReceive(from: data:)
        self.currentTCPClientConnection.didConnectionEnd = didConnectionEndFrom(client: )
        self.currentTCPClientConnection.didFail = didConnectionFailFrom(to: error:)
        self.currentTCPClientConnection.didSendCompleted = didCompletedSent(to: data:)
    }
    
    private func didCompletedSent(to client: TCPClientConnection, data: Data) {
        self.currentTCPClientConnection.stop()
    }
    
    private func didConnectionFailFrom(to client: TCPClientConnection, error: Error) {
        self.currentTCPClientConnection.stop()
    }
    
    private func didReceive(from client: TCPClientConnection, data: Data?) {
        if let data = data, !data.isEmpty {
            //TODO: Check request is ok on HTTP Request Rules
            
            let request = interpreter.interpret(raw: String(data: data, encoding: .utf8)!)
            if let request = request {
                if let route = self.routes.findRoute(as: request.method, withPath: request.path) {
                    let response = route.execute(request: request)
                    client.send(data: response.data(using: .utf8))
                    return
                }
            }
            
            let content = "<h1>Bad Request</h1>"
            let responseHeader = "HTTP/1.0 400 BadRequest"
            let serverHeader = "Server: SwiftHttpServerCLI/0.1"
            let contentTypeHeader = "Content-Type: text/html; charset=utf-8"
            let contentLengthHeader = "Content-Length:\(content.count)"
            let response = "\(responseHeader)\n\(serverHeader)\n\(contentTypeHeader)\n\(contentLengthHeader)\n\n\(content)"
            
            client.send(data: response.data(using: .utf8)!)
            print("HTTP Server Response \n\(response)")
        } else {
            //If client send a request with empty message, should we closed connection from it?
            client.stop()
        }
    }
    
    private func didConnectionEndFrom(client: TCPClientConnection) {
        client.stop()
    }
}
