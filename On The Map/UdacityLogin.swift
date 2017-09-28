//
//  UdacityLogin.swift
//  On The Map
//
//  Created by Sören Kirchner on 10.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func udacityLogin(user: String, password:String, completionHandler: @escaping UdacityDefaultCompletionHandler) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let httpBody = "{\"udacity\": {\"username\": \"\(user)\", \"password\": \"\(password)\"}}"
        let httpBody = """
            {
                "udacity": {
                    "username": "\(user)",
                    "password": "\(password)"
                }
            }
        """
        print(httpBody)
        request.httpBody = httpBody.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = self.checkForErrors(data: data, response: response, error: error, completionHandler: completionHandler) {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
            }
        }
        task.resume()
    }
    
    func fetchMyPublicData (completionHandler: @escaping UdacityDefaultCompletionHandler) {
        print("fetchMyPublicData")
        guard let key = UdacityClient.shared.account?.key else {
            print("key is nil")
            return
        }
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(key)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let data = self.checkForErrors(data: data, response: response, error: error, completionHandler: completionHandler) else {
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            self.convertDataWithCompletionHandler(newData) { data, error in
                
                // TODO: test error! because of access though closure in closure
                
                guard error == nil else {
                    // TODO: handle error
                    print(error!)
                    self.sendError("could not convert data", domain: #function, completionHandler: completionHandler)
                    return
                }
                
                guard let userData = data as? JSONDictionary,
                    let user = userData["user"] as? JSONDictionary else {
                        self.sendError("something wrong with data", domain: #function, completionHandler: completionHandler)
                    return
                }
                
                guard let mySelf = UdacityUser(dictionary: user) else {
                    self.sendError("could not create user", completionHandler: completionHandler)
                    return
                }
                
                completionHandler(mySelf as AnyObject, nil)
            }
        }
        task.resume()
    }
    
}
