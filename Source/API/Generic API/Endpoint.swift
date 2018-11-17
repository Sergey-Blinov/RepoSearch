//
//  Endpoint.swift
//  Generik API Client
//
//  Created by Sergey on 11/17/18.
//  Copyright © 2018 sblinov.com. All rights reserved.
//

import Foundation

protocol EndPoint {
    associatedtype Response: Codable
    
    var additionalHeaders: [String: String]? { get }
    var httpBody: Data? { get }
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    
    func localizedErrorDescription(forStatusCode statusCode: APIError.HttpStatusCode) -> String?
}
