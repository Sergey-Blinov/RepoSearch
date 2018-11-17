//
//  RequestMethod.swift
//  RequestMethod
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error?)
}

protocol NetworkProvider {
    typealias CompletionHandler<T> = (Result<T>) -> Void
    
    func withURL(urlString: String,
                 body: [String : AnyObject]?,
                 head: [String : AnyObject]?,
                 method: HTTPMethod,
                 completionHandler: @escaping CompletionHandler<Data>) -> URLSessionDataTask?
}

class RequestsProvider: NSObject, URLSessionDelegate, NetworkProvider {

    static let shared = RequestsProvider()

    private var session: URLSession

    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.session = session
    }
    
    func withURL(urlString: String,
                 body: [String : AnyObject]?,
                 head: [String : AnyObject]?,
                 method: HTTPMethod,
                 completionHandler: @escaping CompletionHandler<Data>) -> URLSessionDataTask? {

        guard let url = URL(string: urlString) else {
            let error = NSError.init(domain: "Incorrect url", code: 0, userInfo: nil)
            print(error.localizedDescription)
            completionHandler(.failure(error))
            return nil
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        if let bodyObject = body,
            let data = try? JSONSerialization.data(withJSONObject: bodyObject as Any, options: .prettyPrinted),
            let httPBodyString = String(data: data, encoding: String.Encoding.utf8) {
            request.httpBody = httPBodyString.data(using: .utf8)!
        }
        
        let task = session.dataTask(with: request) { dataObject, response, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "Error load data")
                completionHandler(.failure(error))
                return
            }
            
            guard let data = dataObject else {
                print("Error load data")
                completionHandler(.failure(error))
                return
            }
            
            completionHandler(.success(data))
        }
        
        task.resume()
        
        return task
    }
    
}

