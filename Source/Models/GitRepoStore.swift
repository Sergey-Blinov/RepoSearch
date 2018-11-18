//
//  GitRepoStore.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

typealias CompletionHandler<T> = (Result<[T]>) -> Void

class GitRepoStore {
    private var gitRepoService: GitRepoServiceProtocol
    private var storage: LocalStorage
    
    init(service: GitRepoServiceProtocol, storage: LocalStorage = LocalStorage.shared) {
        self.gitRepoService = service
        self.storage = storage
    }
    
    func getRepoItems(query: String, completionHandler: @escaping CompletionHandler<GitRepo>)  {
        var collection = [GitRepo]()
        
        let completionOperation = BlockOperation {
            let items = collection.sorted { $0.starsCount! > $1.starsCount! }
            completionHandler(.success(items))
            self.clearItems()
            self.saveItems(items: items)
        }
        
        let pages = Array(1...PAGE_COUNT) .map { (pageIndex: Int) -> (Page) in return Page(index: pageIndex, perPage: PER_PAGE) }
        for page in pages {
            let operation = self.gitRepoService.getRepoItems(page: page, query: query, completionHandler: {  result in
                switch result {
                case .success(let items):
                    collection.append(contentsOf: items)
                case .failure(let error):
                    completionHandler(.failure(error))
                    break
                }
            })
            
            completionOperation.addDependency(operation)
        }
        
        OperationQueue.main.addOperation(completionOperation)
    }
    
    func cancelSearch() {
        self.gitRepoService.cancel()
    }
    
    func saveItems(items: [GitRepo]) {
        self.storage.gitItems = items
    }
    
    func loadItems() -> [GitRepo]? {
        return self.storage.gitItems
    }
    
    func clearItems() {
        self.storage.clearItems()
    }
}
