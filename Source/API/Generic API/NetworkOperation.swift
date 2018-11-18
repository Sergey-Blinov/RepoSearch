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
    private let endpoint: T
    
    init(client: APIClient, endpoint: T, completion: @escaping (APIResult<T>) -> Void) {
        self.completion = completion
        self.client = client
        self.endpoint = endpoint
        super.init()
    }
    
    override func main() {
        client.sendRequest(for: endpoint) { result in
            Thread.isMainThread ? self.completion(result) : DispatchQueue.main.async { self.completion(result) }
            self.state = .finished
        }
    }
}
