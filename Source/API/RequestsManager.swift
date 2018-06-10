//
//  RequestMethod.swift
//  RequestMethod
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case Post = "POST"
    case Get  = "GET"
    case Put  = "PUT"
}

class RequestsManager: NSObject, URLSessionDelegate {
    var session = URLSession();
    var configuration = URLSessionConfiguration();

    private static let _sharedInstance = RequestsManager()
    
    class func sharedInstance() -> RequestsManager {
        return _sharedInstance
    }

    override init() {
        super.init()
        self.configuration = URLSessionConfiguration.default
        self.session = URLSession.init(configuration: self.configuration,
                                       delegate: nil,
                                       delegateQueue: nil)
    }
    
    public func withURL(urlString: String,
                        body: [String : AnyObject]?,
                        head: [String : AnyObject]?,
                        method: RequestMethod,
                        success: @escaping (_ response: AnyObject?) -> Void,
                        failure: @escaping (_ error: Error?) -> Void ) -> URLSessionDataTask? {
        
        if let url = NSURL(string: urlString) {
            var  request = URLRequest(url: url as URL)
            request.timeoutInterval = 30
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if  let bodyObject = body,
                let data = try? JSONSerialization.data(withJSONObject: bodyObject as Any, options: .prettyPrinted),
                let httPBodyString = String(data: data, encoding: String.Encoding.utf8) {
                request.httpBody = httPBodyString.data(using: .utf8)!
            }

            let task = session.dataTask(with: request, completionHandler: {(dataObject, response, error) in
                
                if ((error) != nil) {
                    print(error?.localizedDescription as Any)
                    failure(error)
                }
                
                if ((dataObject) != nil) {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: dataObject!, options: []) as? [String: AnyObject] {
                            print(jsonObject)
                            success(jsonObject as AnyObject?)
                        }
                        
                    } catch {
                        print(error.localizedDescription)
                        failure(error)
                    }
                }
            })
            
            task.resume()
            
            return task
            
        }else {
            let error = NSError.init(domain: "Incorrect url", code: 0, userInfo: nil)
            print(error.localizedDescription)
            
            failure(error)
        }
        
        return nil
    }
    
}
