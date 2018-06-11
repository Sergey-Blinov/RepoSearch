//
//  GitRepoStore.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

class GitRepoStore {
    
    private let gitRepoService = API.gitRepoServise
    private var workItems = [DispatchWorkItem]()
    
    func getRepoItems(query: String,
                      success: @escaping (_ response: [GitRepo]) -> Void,
                      failure: @escaping (_ error: Error?) -> Void ) -> Void {
        let group = DispatchGroup()
        var collection = [GitRepo]()
        
        self.workItems = Array(1...PAGE_COUNT)
            .map { (pageIndex: Int) -> (Page) in
                return Page(index: pageIndex, perPage: PER_PAGE)
            }
            .map { (page: Page) -> (DispatchWorkItem) in
                let requestWorkItem = DispatchWorkItem { [weak self] in
                    group.enter()
                    guard let strongSelf = self else { return }
                    strongSelf .gitRepoService.getRepoItems(page: page,
                                                            query: query,
                                                            success: { (items) in
                                                                collection.append(contentsOf: items)
                                                                group.leave()
                                                                
                    }, failure: { (error) in
                        failure(error)
                    })
                }
                
                return requestWorkItem
        }
        
        for item in workItems {
            if (item.isCancelled) {
                break
            }
            DispatchQueue.global().async(group: group, execute:  item)
        }
        
        group.notify(queue: .main) { [weak self] in
            let items = collection.sorted { $0.starsValue > $1.starsValue }
            guard let strongSelf = self else { return }
            strongSelf.clearStore()
            strongSelf.saveItems(items: items)
            success(items)
        }
    }
    
    func cancelSearch() -> Void {
        self.gitRepoService.cancel()
        self.workItems.forEach { (item) in
            item.cancel()
        }
    }
    
    func saveItems(items: [GitRepo]) {
        let placesData = NSKeyedArchiver.archivedData(withRootObject: items)
        UserDefaults.standard.set(placesData, forKey: REPO_ITEMS)
    }
    
    func loadItems() -> [GitRepo]? {
        guard let placesData = UserDefaults.standard.object(forKey: REPO_ITEMS) as? NSData,
            let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [GitRepo]
            else {
                return nil
        }
        
        return placesArray
    }
    
    func clearStore() -> Void {
        UserDefaults.standard.removeObject(forKey: REPO_ITEMS)
    }
}
