//
//  HTTPMethod.swift
//  RepoSearch
//
//  Created by Sergey on 11/15/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post
    case put
    case get
    case delete
    case patch
    
    var name: String {
        return rawValue.uppercased()
    }
}
