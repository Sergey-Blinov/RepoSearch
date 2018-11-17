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
    typealias GitRepoServiceCompletionHandler<T> = (Result<[T]>) -> Void
    
    func getRepoItems(page: Page, query: String, completionHandler: @escaping GitRepoServiceCompletionHandler<GitRepo>)
    func cancel()
}

class GitRepoService: GitRepoServiceProtocol {
    private var operations = [Operation?]()
    
    func getRepoItems(page: Page,
                      query: String,
                      completionHandler: @escaping GitRepoServiceCompletionHandler<GitRepo>) {
        let resource = GitRepoEndpoint.items(page: page, query: query)
        self.operations.append(GitRepoAPIClient.queueRequest(for: resource) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                case .success(let result):
                    completionHandler(.success(result.items))
                }
            }
        })
    }
    
    func cancel() {
        self.operations.forEach { $0?.cancel() }
    }
}

