//
//  ViewController.swift
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var activityIndicatorView: UIActivityIndicatorView!
    var searchController: UISearchController!
    var dataSource: GitRepoListDataSource!
    var selectedItemUrlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = MAINVC_TITLE
        self.setupTableView()
        self.dataSource = GitRepoListDataSource.init(delegate: self)
        self.setupSearchController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? RepoWebViewVC,
            let popoverPresentationController = controller.popoverPresentationController,
            let urlString = self.selectedItemUrlString {
            controller.stringUrl = urlString
            segue.destination.popoverPresentationController?.delegate = self
            popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            popoverPresentationController.sourceView = self.tableView
            popoverPresentationController.sourceView?.center = self.tableView.center
        }
    }
}

extension MainVC: GitRepoListDataSourceDelegate {

    var currentTableView: UITableView {
        return self.tableView
    }

    func loadingError(error: Error?) {
        self.stopShowActivity()
        var message = ERROR_MESSAGE
        
        if let error = error {
            message = error.localizedDescription
        }
        
        self.presentAlert(title: ERROR,
                          message: message, okHandler: nil, cancelHandler: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.dataSource.cancelSearch()
        self.dataSource.searchRepositories(text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dataSource.cancelSearch()
        self.stopShowActivity()
    }
}

extension MainVC: UISearchBarDelegate {
    
    func beginLoadItems() {
        self.activityIndicatorView.startAnimating()
    }
    
    func endLoadItems() {
        self.activityIndicatorView.stopAnimating()
    }
    
    func didSelect(_ item: GitRepo) {
        self.presenSelectedItem(item)
    }
}

extension MainVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - Private functions

private extension MainVC {
    
    func stopShowActivity() -> Void {
        if self.activityIndicatorView.isAnimating {
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    func setupSearchController() -> Void  {
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = self.searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            self.navigationItem.titleView = self.searchController.searchBar
        }
        self.definesPresentationContext = true
    }
    
    func setupTableView() -> Void {
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.tableView.backgroundView = activityIndicatorView
    }
    
    func presenSelectedItem(_ item: GitRepo) -> Void {
        self.selectedItemUrlString = item.urlString
        self.performSegue(withIdentifier:RepoWebViewVC.className, sender: self)
    }
}
