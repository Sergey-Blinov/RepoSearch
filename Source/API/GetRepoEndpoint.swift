//
//  GetRepoEndpoint.swift
//  RepoSearch
//
//  Created by Sergey on 11/17/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

enum GitRepoConstants {
    static let searchQuery = "q"
    static let order = "order"
    static let sort = "sort"
    static let stars = "stars"
    static let page = "page"
    static let perPage = "per_page"
    static let desc = "desc"
    static let items = "items"
}

enum GitRepoEndpoint: EndPoint {
    case items(page: Page, query: String)
}

extension GitRepoEndpoint {
    typealias Response = GitRepoDataModel
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/search/repositories"
    }
    
    var additionalHeaders: [String: String]? {
        return nil
    }
    
    var httpBody: Data? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .items(page,query):
            return queryItems(page, query: query)
        }
    }
    
    func localizedErrorDescription(forStatusCode statusCode: APIError.HttpStatusCode) -> String? {
        return nil
    }
    
    private func queryItems( _ page: Page, query: String) -> [URLQueryItem]? {
        var parameters: [String : String] {
            return [GitRepoConstants.searchQuery : query,
                    GitRepoConstants.page : String(page.index),
                GitRepoConstants.perPage : String(page.perPage),
                GitRepoConstants.order : GitRepoConstants.desc,
                GitRepoConstants.sort : GitRepoConstants.stars]
        }
        
        return parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
