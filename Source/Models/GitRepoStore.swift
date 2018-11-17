//
//  GitRepoStore.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

protocol Store { }

class GitRepoStore: Store {
    
    private var gitRepoService: GitRepoServiceProtocol
    private var workItems = [DispatchWorkItem]()
    private var storage: LocalStorage
    
    init(service: GitRepoServiceProtocol, storage: LocalStorage = LocalStorage.shared) {
        self.gitRepoService = service
        self.storage = storage
    }
    
    func getRepoItems(query: String,
                      success: @escaping (_ response: [GitRepo]) -> Void,
                      failure: @escaping (_ error: Error?) -> Void) -> Void {
        let group = DispatchGroup()
        var collection = [GitRepo]()
        
        self.workItems = Array(1...PAGE_COUNT)
            .map { (pageIndex: Int) -> (Page) in return Page(index: pageIndex, perPage: PER_PAGE) }
            .map { (page: Page) -> (DispatchWorkItem) in
                
                let requestWorkItem = DispatchWorkItem(qos: .background) { [weak self] in
                    group.enter()
                    guard let strongSelf = self else { return }
                    strongSelf.gitRepoService.getRepoItems(page: page,
                                                           query: query) { result in
                                                            group.leave()
                                                            switch result {
                                                            case .success(let items):
                                                                collection.append(contentsOf: items)
                                                            case .failure(_):
                                                                break
                                                            }
                    }
                }
                
                return requestWorkItem
        }

        self.workItems.forEach { if !$0.isCancelled { $0.perform() }}

        group.notify(queue: .main) { [weak self] in
            let items = collection.sorted { $0.starsCount! > $1.starsCount! }
            guard let strongSelf = self else { return }
            strongSelf.clearItems()
            strongSelf.saveItems(items: items)
            success(items)
        }
    }
    
    func cancelSearch() {
        self.gitRepoService.cancel()
        self.workItems.forEach { $0.cancel() }
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
