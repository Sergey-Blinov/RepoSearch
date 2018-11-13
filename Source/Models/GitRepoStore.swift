//
//  GitRepoStore.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

class GitRepoStore {
    
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
                let requestWorkItem = DispatchWorkItem { [weak self] in
                    group.enter()
                    guard let strongSelf = self else { return }
                    strongSelf.gitRepoService.getRepoItems(page: page,
                                                           query: query,
                                                           success: { (items) in
                                                            collection.append(contentsOf: items)
                                                            group.leave()

                    }, failure: failure)
                }
                
                return requestWorkItem
        }
        
        for item in self.workItems {
            if item.isCancelled { break }
            DispatchQueue.global().async(group: group, execute:  item)
        }
        
        group.notify(queue: .main) { [weak self] in
            let items = collection.sorted { $0.starsValue > $1.starsValue }
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
        storage.gitItems = items
    }
    
    func loadItems() -> [GitRepo]? {
        return storage.gitItems
    }
    
    func clearItems() {
        UserDefaults.standard.removeObject(forKey: REPO_ITEMS)
    }
}
