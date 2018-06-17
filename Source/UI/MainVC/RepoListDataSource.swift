//
//  GitRepoListDataSource.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import UIKit

protocol  GitRepoListDataSourceDelegate: class {
    func currentTableView() -> UITableView
    func beginLoadItems() -> Void
    func endLoadItems() -> Void
    func loadingError(error: Error?) -> Void
    func didSelect(_ item: GitRepo) -> Void
}

class GitRepoListDataSource: NSObject {
    
    private weak var tableView: UITableView!
    private var gitRepoStore: GitRepoStore!
    var items: [GitRepo] = []
    
    weak var delegate: GitRepoListDataSourceDelegate?
    
    init(delegate: GitRepoListDataSourceDelegate) {
        super.init()
        self.gitRepoStore = GitRepoStore.init(service: API.gitRepoServise)
        self.configure(delegate)
        guard let repoItems = self.gitRepoStore.loadItems() else { return }
        self.items = repoItems
        self.tableView.reloadData()
    }
    
    func cancelSearch() -> Void {
        self.gitRepoStore.cancelSearch()
    }
    
    func clearItems() -> Void {
        self.items = [GitRepo]()
        self.tableView.reloadData()
        self.gitRepoStore.clearStore()
    }
    
    func searchRepositories(_ query: String) -> Void {
        guard let delegate = self.delegate else { return }
        delegate.beginLoadItems()
        self.clearItems()
        
        self.gitRepoStore.getRepoItems(query: query,
                                       success: { [weak self] (items) in
                                        delegate.endLoadItems()
                                        guard let strongSelf = self else { return }
                                        strongSelf.insert(items)
        }) { (error) in
            DispatchQueue.main.async {
                delegate.endLoadItems()
                delegate.loadingError(error: error)
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
        let cellModel = GitRepoCellModel.init(item)
        cell.fillWith(cellModel)
        
        return cell
    }
}

extension GitRepoListDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let delegate = self.delegate else { return }
        let item = self.items[indexPath.row]
        delegate.didSelect(item)
    }
}

// MARK: - Private functions

private extension GitRepoListDataSource {
    
    private func insert(_ items:[GitRepo]) {
        for object in items {
            self.items.insert(object, at: self.items.count)
            self.insertRow(index: self.items.count - 1)
        }
    }
    
    private func insertRow(index:Int) {
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        self.tableView.endUpdates()
    }
    
    private  func configure( _ delegate: GitRepoListDataSourceDelegate) {
        self.tableView = delegate.currentTableView()
        self.delegate = delegate
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }
}
