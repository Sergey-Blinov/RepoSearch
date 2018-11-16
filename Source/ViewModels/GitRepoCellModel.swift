//
//  File.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

struct GitRepoCellModel {

    let name: String
    let stringURL: String
    let devLanguage: String
    let stars: String
    
    init(_ repoItem: GitRepo) {
        self.name = repoItem.name ?? ""
        self.stringURL = repoItem.url ?? ""
        self.stars = String(repoItem.starsCount ?? 0)
        self.devLanguage = repoItem.devLanguage ?? ""
    }
}
