import Network

@available(macOS 10.14, *)
public class TCPServer {
    let port: NWEndpoint.Port
    let listener: NWListener
    
    private var connectionById: [Int: TCPClientConnection] = [:]
    public var newClientConnected: ((TCPClientConnection) -> Void)? = nil
    
    public init(_ port: UInt16) {
        self.port = NWEndpoint.Port(rawValue: port)!
        self.listener = try! NWListener.init(using: .tcp, on: self.port)
    }
    
    public func start() throws {
        print("Server starting on \(self.port)...")
        self.listener.stateUpdateHandler = self.stateDidChange(to:)
        self.listener.newConnectionHandler = self.didAccept(nwConnection:)
        self.listener.start(queue: .main)
    }
    
    private func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .ready:
            print("Server ready...")
        case .failed(let error):
            print("Sever Failure, error: \(error.localizedDescription)")
            exit(EXIT_FAILURE)
        default:
            break
        }
    }
    
    private func didAccept(nwConnection: NWConnection) {
        let connection = TCPClientConnection(nwConnection: nwConnection)
        self.connectionById[connection.id] = connection
        
        connection.didStopCallback = { _ in
            self.connectionDidStop(connection)
        }
        
        connection.start()
        if let newClientConnected = newClientConnected {
            newClientConnected(connection)
        }
        
        print("server did open connection \(connection.id)")
    }
    
    private func connectionDidStop(_ connection: TCPClientConnection) {
        self.connectionById.removeValue(forKey: connection.id)
        print("server did close connection \(connection.id)")
    }
    
    private func stop() {
        self.newClientConnected = nil
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        
        for connection in self.connectionById.values {
            connection.didStopCallback = nil
            connection.stop()
        }
    }
}
