//
//  main.swift
//  SwiftHttpServerCLI
//
//  Created by Augusto Cesar on 18/09/20.
//  Copyright © 2020 aucamana. All rights reserved.
//

import Foundation
import NetworkHttpServer
 
let server = HTTPServer(8081)
server.routes.on(on: "/echo", as: .get) { request in
    return HTTPResponse(statusCode: .OK, content: "<h1>Echo</h1><h2>Echo</h2><h3>Echo</h3><h4>Echo</h4>", protocolVersion: "HTTP/1.1", contentType: "text/html")
}
server.routes.on(on: "/echo", as: .post) { request in
    return HTTPResponse(statusCode: .OK, content: "<h1>Echo</h1><h2>Echo</h2><h3>POST Echo</h3><h4>Echo</h4>", protocolVersion: "HTTP/1.1", contentType: "text/html")
}
try! server.start()

//TODO: Study about multthread app, cause below code using this topic
RunLoop.current.run()
