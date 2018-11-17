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
                      completionHandler: @escaping GitRepoServiceCompletionHandler<GitRepo>) {
        guard let urlString = self.urlStringWith(page, query: query) else { return }
         self.tasks.append(provider.withURL(urlString: urlString, body: nil, head: nil, method: .get) { result in
            switch result {
            case .success(let data):
                do {
                    let items = try JSONDecoder().decode(GitRepoDataModel.self, from: data).items
                    DispatchQueue.main.async { completionHandler(.success(items)) }
                } catch {
                    
                }
            case .failure(let error):
                DispatchQueue.main.async { completionHandler(.failure(error)) }
            }
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

