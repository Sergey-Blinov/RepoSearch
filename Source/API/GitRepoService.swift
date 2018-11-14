//
//  GitRepoService.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

enum GitRepoConstants {
    static let baseURL  = "https://api.github.com/search/repositories?"
    static let searchQuery = "q"
    static let order = "order"
    static let sort = "sort"
    static let stars = "stars"
    static let page = "page"
    static let perPage = "per_page"
    static let desc = "desc"
    static let items = "items"
}

class GitRepoService: GitRepoServiceProtocol {

    private var tasks = [URLSessionDataTask?]()

    var provider: NetworkProvider {
        return RequestsProvider.shared
    }
    
    func getRepoItems(page: Page,
                      query: String,
                      completionHandler: @escaping GitRepoServiceCompletionHandler) {
        guard let urlString =  self.urlStringWith(page, query: query) else { return }
        self.tasks.append(provider.withURL(urlString: urlString, body: nil, head: nil, method: .get) { object, error in
            guard let dictionary = object as? [String : AnyObject],
                let array = dictionary[GitRepoConstants.items] as? [[String : AnyObject]] else {
                    completionHandler(nil,error)
                    return
            }
            let items = array.compactMap { dictionary in return GitRepo(dictionary) }
            DispatchQueue.main.async { completionHandler(items , error) }
        })
    }
    
    func cancel() {
        self.tasks.forEach { $0?.cancel() }
    }
}

private extension GitRepoService {
    func urlStringWith( _ page: Page, query: String) -> String? {
        var parameters: [String : String] {
            return [GitRepoConstants.searchQuery : query,
                    GitRepoConstants.page : "\(page.index)",
                GitRepoConstants.perPage : "\(page.perPage)",
                GitRepoConstants.order : GitRepoConstants.desc,
                GitRepoConstants.sort : GitRepoConstants.stars]
        }
        
        guard var urlComponents = URLComponents(string: GitRepoConstants.baseURL) else { return "" }
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return urlComponents.url?.absoluteString
    }
}

