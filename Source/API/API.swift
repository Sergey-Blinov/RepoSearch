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

    var provider: NetworkProvider { get }

    func getRepoItems(page: Page,
                      query: String,
                      success: @escaping (_ response: [GitRepo]) -> Void,
                      failure: @escaping (_ error: Error?) -> Void ) -> Void
    
    func cancel() -> Void
    
}
