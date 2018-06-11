//
//  GitRepoService.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

struct GitRepoConstants {
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

class GitRepoService {
    
    private var tasks = [URLSessionDataTask?]()
    
    func getRepoItems(page: Page,
                      query: String,
                      success: @escaping (_ response: [GitRepo]) -> Void,
                      failure: @escaping (_ error: Error?) -> Void ) -> Void {
        guard let urlString =  self.urlStringWith(page, query: query) else { return }
        self.tasks.append(RequestsManager.sharedInstance().withURL(urlString: urlString,
                                                                   body: nil,
                                                                   head: nil,
                                                                   method: RequestMethod.Get,
                                                                   success: { (object) in
                                                                    if let dictionary = object as? [String : AnyObject],
                                                                        let array = dictionary[GitRepoConstants.items] as? [[String : AnyObject]] {
                                                                        var items = [GitRepo]()
                                                                        let closure: ([String: Any]) -> GitRepo?
                                                                        closure = { dictionary in return GitRepo(dictionary) }
                                                                        items = array.compactMap(closure)
                                                                        
                                                                        DispatchQueue.main.async {
                                                                            success(items)
                                                                        }
                                                                        
                                                                    } else {
                                                                        failure(nil)
                                                                    }
        }) { (error) in
            failure(error)
        })
    }
    
    func cancel() {
        self.tasks.forEach { (task) in
            guard let task = task else { return }
            task.cancel()
        }
    }
}

private extension GitRepoService {
    
    private func urlStringWith( _ page: Page, query: String) -> String? {
        
        var parameters: [String : String] {
            return [GitRepoConstants.searchQuery : query,
                    GitRepoConstants.page : "\(page.index)",
                GitRepoConstants.perPage : "\(page.perPage)",
                GitRepoConstants.order : GitRepoConstants.desc,
                GitRepoConstants.sort : GitRepoConstants.stars]
        }
        
        guard var urlComponents = URLComponents(string: GitRepoConstants.baseURL) else { return "" }
        urlComponents.queryItems = parameters
            .map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return urlComponents.url?.absoluteString
    }
}

