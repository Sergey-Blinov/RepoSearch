//
//  File.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

struct GitRepoViewModel {
    let repoItem: GitRepo
    
    var name: String {
        return repoItem.name ?? ""
    }
    
    var stringURL: String {
        return repoItem.url ?? ""
    }
    
    var devLanguage: String {
        return repoItem.devLanguage ?? ""
    }
    
    var stars: String {
        return String(repoItem.starsCount ?? 0)
    }
    
    init(_ repoItem: GitRepo) {
        self.repoItem = repoItem
    }
}
