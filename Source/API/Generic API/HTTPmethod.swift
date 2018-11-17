//
//  HTTPmethod.swift
//  Generik API Client
//
//  Created by Sergey on 11/17/18.
//  Copyright © 2018 sblinov.com. All rights reserved.
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
