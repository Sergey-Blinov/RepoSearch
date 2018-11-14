//
//  API.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

enum API {
    static let gitRepoServise = GitRepoService()
}

protocol GitRepoServiceProtocol: class {
    typealias GitRepoServiceCompletionHandler = ([GitRepo]?, Error?) -> Void

    var provider: NetworkProvider { get }

    func getRepoItems(page: Page, query: String, completionHandler: @escaping GitRepoServiceCompletionHandler)
    
    func cancel()
}
