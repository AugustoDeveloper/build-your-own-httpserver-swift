//
//  File.swift
//  
//
//  Created by Augusto Cesar on 19/09/20.
//

import Foundation

@available(macOS 10.14, *)
public class HTTPClientConnection {
    var id: Int { get { return self.currentTCPClientConnection.id } }
    let currentTCPClientConnection: TCPClientConnection
    
    public init(fromTCP client: TCPClientConnection) {
        currentTCPClientConnection = client
    }
    
    public func setup() {
        self.currentTCPClientConnection.didReceiveFrom = didClientReceive(from: data:)
        self.currentTCPClientConnection.didConnectionEnd = didClientConnectionEnd(client: )
        self.currentTCPClientConnection.didFail = didClientConnectionFail(to: error:)
        self.currentTCPClientConnection.didSendCompleted = didClientCompletedSent(to: data:)
    }
    
    private func didClientCompletedSent(to client: TCPClientConnection, data: Data) {
        self.currentTCPClientConnection.stop()
    }
    
    private func didClientConnectionFail(to client: TCPClientConnection, error: Error) {
        self.currentTCPClientConnection.stop()
    }
    
    private func didClientReceive(from client: TCPClientConnection, data: Data?) {
        if let data = data, !data.isEmpty {
            //TODO: Validate format message from tcp
            
        }
        
        client.send(data: badRequestTextFormatted.data(using: .utf8)!)
    }
    
    private func didClientConnectionEnd(client: TCPClientConnection) {
        client.stop()
    }
}
