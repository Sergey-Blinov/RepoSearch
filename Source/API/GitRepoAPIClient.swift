//
//  GitRepoAPIClient.swift
//  RepoSearch
//
//  Created by Sergey on 11/17/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

enum APIDefault {
    static let host = "api.github.com"
    static let scheme = "https"
}

class GitRepoAPIClient: APIClient {
    private var host: String
    private var scheme: String
    private var operationQueue: OperationQueue
    
    lazy var baseUrlComponents: URLComponents = {
        var components = URLComponents()
        components.host = host
        components.scheme = scheme
        
        return components
    }()
    
    var session: URLSession {
        return URLSession.shared
    }
    
    init(host: String = APIDefault.host,
         scheme: String = APIDefault.scheme,
         queue: OperationQueue = OperationQueue()) {
        self.host = host
        self.scheme = scheme
        self.operationQueue = queue
    }
    
    func queueRequest<T:EndPoint>(for endpoint: T, completion: @escaping (APIResult<T>) -> Void) -> Operation {
        let operation = NetworkOperation<T>(client: self, endpoint: endpoint, completion: completion)
        defer { self.operationQueue.addOperation(operation) }
        
        return operation
    }
}
