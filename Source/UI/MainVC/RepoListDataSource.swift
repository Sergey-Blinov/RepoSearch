//
//  GitRepoListDataSource.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import UIKit

protocol GitRepoLoadingDelegate: class {
    func beginLoadItems()
    func endLoadItems(_ error: Error?)
}

class GitRepoListDataSource: NSObject {
    
    weak var tableView: UITableView?
    
    private var gitRepoStore: GitRepoStore!
    var didSelect: ((GitRepoViewModel) -> Void)?
    var items: [GitRepo] = []
    
    weak var loadingDelegate: GitRepoLoadingDelegate?
    
    init(tableView: UITableView, loadingDelegate: GitRepoLoadingDelegate, store: GitRepoStore = GitRepoStore(service: API.gitRepoServise)) {
        super.init()
        self.gitRepoStore = store
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.loadingDelegate = loadingDelegate
        guard let repoItems = self.gitRepoStore.loadItems() else { return }
        self.items = repoItems
        self.tableView?.reloadData()
    }
    
    func cancelSearch() -> Void {
        self.gitRepoStore.cancelSearch()
    }
    
    func clearItems() -> Void {
        self.items = [GitRepo]()
        self.gitRepoStore.clearItems()
        self.tableView?.reloadData()
    }
    
    func searchRepositories(_ query: String) -> Void {
        self.loadingDelegate?.beginLoadItems()
        self.clearItems()
        self.gitRepoStore.getRepoItems(query: query) { [weak self] result in
            self?.loadingDelegate?.endLoadItems(nil)
            guard let strongSelf = self else { return }
            switch result {
            case .success(let items):
                strongSelf.insert(items)
            case .failure(let error):
                strongSelf.loadingDelegate?.endLoadItems(error)
            }
        }
    }
}

extension GitRepoListDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.className) as! RepoTableViewCell
        let item = self.items[indexPath.row]
        let cellModel = GitRepoViewModel(item)
        cell.fillWith(cellModel)
        
        return cell
    }
}

extension GitRepoListDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = GitRepoViewModel(self.items[indexPath.row])
        self.didSelect?(item)
    }
}

// MARK: - Private functions

private extension GitRepoListDataSource {
    
     func insert(_ items:[GitRepo]) {
        for object in items {
            self.items.insert(object, at: self.items.count)
            self.insertRow(index: self.items.count - 1)
        }
    }
    
    func insertRow(index: Int) {
        self.tableView?.beginUpdates()
        self.tableView?.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        self.tableView?.endUpdates()
    }
}
