//
//  ServerConnection.swift
//  
//
//  Created by Augusto Cesar on 19/09/20.
//

import Foundation
import Network

@available(macOS 10.14, *)
public class TCPClientConnection {
    let currentConnection: NWConnection
    let MTU = 65536
    let id: Int
    
    private static var nextId = -1
    var didStopCallback: ((Error?) -> Void)? = nil
    var didReceiveFrom: ((_ client: TCPClientConnection, _ data: Data?) -> Void)? = nil
    var didFail: ((_ client: TCPClientConnection, _ error: Error) -> Void)? = nil
    var didConnectionEnd: ((_ client: TCPClientConnection) -> Void)? = nil
    var didSendCompleted: ((_ client: TCPClientConnection, _ data: Data) -> Void)? = nil
    
    
    public init(nwConnection: NWConnection) {
        self.currentConnection = nwConnection
        self.id = TCPClientConnection.generateNewId()
    }
    
    private static func generateNewId() -> Int {
        self.nextId += 1
        return self.nextId
    }
    
    func start() {
        print("Connection \(self.id) will start")
        self.currentConnection.stateUpdateHandler = stateDidChange(to:)
        setup()
        self.currentConnection.start(queue: .main)
    }
    
    func stop() {
        self.currentConnection.cancel()
        print("connection \(self.id) will stop")
    }
    
    private func setup() {
        self.currentConnection.receive(minimumIncompleteLength: 1, maximumLength: MTU) {
            (data, _, isComplete, error) in
            if let didReceiveFrom = self.didReceiveFrom {
                didReceiveFrom(self, data)
            }
            if isComplete {
                self.connectionDidEnd()
            } else if let error = error {
                print("receiving error from connection")
                self.connectionDidFail(error: error)
            } else {
                self.setup()
            }
        }
    }
    
    private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .waiting(let error):
            self.connectionDidFail(error: error)
        case .failed(let error):
            print("connection state changed to failed")
            self.connectionDidFail(error: error)
        case .cancelled:
            print("connection was cancelled")
        case .ready:
            print("connection \(self.id) ready")
        default:
            break
        }
    }
    
    func send(data: Data) {
        self.currentConnection.send(content: data, completion: .contentProcessed { error in
            if let error = error {
                print("Was sent, but error occurred")
                self.connectionDidFail(error: error)
                return
            }
            
            if let didSendCompleted = self.didSendCompleted {
                didSendCompleted(self, data)
            }
            print("connection \(self.id) did send, data: \(data as NSData)")
        })
    }
    
    private func connectionDidFail(error: Error) {
        print("connection \(self.id) did fail, error: \(error)")
        if let didFail = self.didFail {
            didFail(self, error)
        }
    }
    
    private func connectionDidEnd() {
        print("connection \(self.id) did end")
        if let didConnectionEnd = self.didConnectionEnd {
            didConnectionEnd(self)
        }
    }
    
    private func stop(error: Error?) {
        self.currentConnection.stateUpdateHandler = nil
        self.didReceiveFrom = nil
        
        switch self.currentConnection.state {
        case .cancelled:
            break
        default:
            self.currentConnection.cancel()
        }
        
        if let didStopCallback = didStopCallback {
            self.didStopCallback = nil
            didStopCallback(error)
        }
    }
}
