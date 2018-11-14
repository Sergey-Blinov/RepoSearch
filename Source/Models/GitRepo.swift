//
//  GitRepo.swift
//  RepoSearch
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import UIKit

enum RepoKey {
    static let fullName   = "full_name"
    static let language   = "language"
    static let stars      = "stargazers_count"
    static let URL        = "html_url"
}

enum CoderKey {
    static let name         = "name"
    static let urlString    = "urlString"
    static let devLanguage  = "devLanguage"
    static let starsValue   = "starsValue"
}

class GitRepo: NSObject, NSCoding {
    
    var name: String
    var urlString: String
    var devLanguage: String
    var starsValue: Int
    
    init?( _ object: [String: Any]?) {
        guard
            let dictionary = object,
            let name = dictionary[RepoKey.fullName] as? String,
            let urlString = dictionary[RepoKey.URL] as? String,
            let starsValue = dictionary[RepoKey.stars] as? Int,
            let devLanguage = dictionary[RepoKey.language] as? String
            else {
                return nil
        }
        
        self.name = name.trunc(length: MAX_NAME_LENGHTH)
        self.urlString = urlString
        self.starsValue = starsValue
        self.devLanguage = devLanguage
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: CoderKey.name) as! String
        self.urlString  = aDecoder.decodeObject(forKey: CoderKey.urlString) as! String
        self.starsValue = aDecoder.decodeInteger(forKey: CoderKey.starsValue)
        self.devLanguage = aDecoder.decodeObject(forKey: CoderKey.devLanguage) as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: CoderKey.name)
        aCoder.encode(self.urlString, forKey: CoderKey.urlString)
        aCoder.encode(self.devLanguage, forKey: CoderKey.devLanguage)
        aCoder.encode(self.starsValue, forKey: CoderKey.starsValue)
    }
}
