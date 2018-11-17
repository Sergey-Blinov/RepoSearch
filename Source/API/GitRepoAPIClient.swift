//
//  GitRepoAPIClient.swift
//  RepoSearch
//
//  Created by Sergey on 11/17/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

class GitRepoAPIClient: APIClient {
    static let defaultHost = "api.github.com"
    static let defaultScheme = "https"
    static let instance = GitRepoAPIClient()

    var baseUrlComponents: URLComponents {
        var components = URLComponents()
        components.host = GitRepoAPIClient.defaultHost
        components.scheme = GitRepoAPIClient.defaultScheme
        
        return components
    }
    
    var session: URLSession {
        return URLSession.shared
    }
    
    private init() {}
    
    private let operationQueue = OperationQueue()
    
    static func queueRequest<T:EndPoint>(for resource: T, completion: @escaping (APIResult<T>) -> Void) -> Operation {
        let operation = NetworkOperation<T>(client: instance, resource: resource, completion: completion)
        defer { instance.operationQueue.addOperation(operation) }
        
        return operation
    }
}
