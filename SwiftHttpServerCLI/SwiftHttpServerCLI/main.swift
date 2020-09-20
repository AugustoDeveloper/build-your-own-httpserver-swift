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
try! server.start()
RunLoop.current.run()
