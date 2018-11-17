//
//  NetworkOperation.swift
//  Generik API Client
//
//  Created by Sergey on 11/17/18.
//  Copyright © 2018 sblinov.com. All rights reserved.
//

import Foundation

class NetworkOperation<T:EndPoint>: AsynchronousOperation {
    private let completion: (APIResult<T>) -> Void
    private let client: APIClient
    private let resource: T
    
    init(client: APIClient, resource: T, completion: @escaping (APIResult<T>) -> Void) {
        self.completion = completion
        self.client = client
        self.resource = resource
        super.init()
    }
    
    override func main() {
        client.sendRequest(for: resource) { result in
            Thread.isMainThread ? self.completion(result) : DispatchQueue.main.async { self.completion(result) }
            self.state = .finished
        }
    }
}
