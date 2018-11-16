//
//  GitRepo.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import UIKit

struct GitRepoDataModel: Codable {
    let items: [GitRepo]
}

struct GitRepo: Codable {
    let name: String?
    let devLanguage: String?
    let url: String?
    let starsCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "full_name"
        case devLanguage = "language"
        case url = "html_url"
        case starsCount = "stargazers_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try? values.decode(String.self, forKey: .name)
        devLanguage =  try? values.decode(String.self, forKey: .devLanguage)
        url = try? values.decode(String.self, forKey: .url)
        starsCount = try? values.decode(Int.self, forKey: .starsCount)
    }
}

