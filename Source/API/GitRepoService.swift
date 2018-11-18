//
//  GitRepoService.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

protocol GitRepoServiceProtocol: class {
    func getRepoItems(page: Page, query: String, completionHandler: @escaping CompletionHandler<GitRepo>) -> Operation
    func cancel()
}

class GitRepoService: GitRepoServiceProtocol {
    private var operations = [Operation?]()
    
    func getRepoItems(page: Page,
                      query: String,
                      completionHandler: @escaping CompletionHandler<GitRepo>) -> Operation {
        let resource = GitRepoEndpoint.items(page: page, query: query)
        let operation = API.gitRepoClient.queueRequest(for: resource) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let result):
                completionHandler(.success(result.items))
            }
        }
        operations.append(operation)
        
        return operation
    }
    
    func cancel() {
        self.operations.forEach { $0?.cancel() }
    }
}

