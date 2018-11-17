//
//  APIClient.swift
//  Generik API Client
//
//  Created by Sergey on 11/17/18.
//  Copyright © 2018 sblinov.com. All rights reserved.
//

import Foundation

enum APIResult<T: EndPoint> {
    case failure(error: APIError)
    case success(result: T.Response)
}

protocol APIClient {
    var baseUrlComponents: URLComponents { get }
    var session: URLSession { get }
    
    func buildRequest<T:EndPoint>(for resource: T) -> URLRequest?
    func buildUrl<T:EndPoint>(for resource: T) -> URL?
    func cancelAllTasks()
    func sendRequest<T:EndPoint>(for resource: T, completion: @escaping (APIResult<T>) -> Void)
}

extension APIClient {
    
    func buildRequest<T:EndPoint>(for resource: T) -> URLRequest? {
        guard let url = buildUrl(for: resource) else {
            // TODO: add log
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.httpBody
        
        resource.additionalHeaders?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    func buildUrl<T:EndPoint>(for resource: T) -> URL? {
        guard
            let baseUrl = baseUrlComponents.url,
            var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
            else {
                  // TODO: add log
                return nil
        }
        
        components.path = baseUrlComponents.path.appending(resource.path)
        components.queryItems = resource.queryItems
        
        return components.url
    }
    
    func cancelAllTasks() {
        session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    func sendRequest<T:EndPoint>(for resource: T, completion: @escaping (APIResult<T>) -> Void) {
        guard let request = buildRequest(for: resource) else {
            completion(.failure(error: APIError.client))
            return
        }
        
        // TODO: add log
        
        let task = session.dataTask(with: request) { data, response, error in
            // TODO: add log
            
            let failWithError: (APIError) -> Void = { localizedError in
                // TODO: add log
                completion(.failure(error: localizedError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                failWithError(APIError.unrecognizedFormat)
                return
            }
            
            let statusCode = httpResponse.statusCode
            guard statusCode == 200 else {
                let localizedDescription = resource.localizedErrorDescription(forStatusCode: APIError.HttpStatusCode(statusCode: statusCode))
                failWithError(APIError.network(statusCode: statusCode, localizedDescription: localizedDescription))
                return
            }
            
            guard let data = data else {
                failWithError(APIError.noData)
                return
            }
            
            do {
                completion(.success(result: try JSONDecoder().decode(T.Response.self, from: data)))
            } catch let error as NSError {
                failWithError(APIError.decoding(reason: error.userInfo))
                return
            }
        }
        
        task.resume()
    }
}
