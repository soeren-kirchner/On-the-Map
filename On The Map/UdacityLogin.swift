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
        let request = NSMutableURLRequest(url: URL(string: LoginConstants.SessionURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = """
            {
                "udacity": {
                    "username": "\(user)",
                    "password": "\(password)"
                }
            }
        """
        request.httpBody = httpBody.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = self.checkForErrors(data: data, response: response, error: error, completionHandler: completionHandler) {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
            }
        }
        task.resume()
    }
    
    func logout(completionHandler: @escaping UdacityDefaultCompletionHandler) {
        let request = NSMutableURLRequest(url: URL(string: LoginConstants.SessionURL)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = self.checkForErrors(data: data, response: response, error: error, completionHandler: completionHandler) {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
            }
        }
        task.resume()
    }
    
    func fetchMyPublicData (completionHandler: @escaping UdacityDefaultCompletionHandler) {
        guard let key = UdacityClient.shared.account?.key else {
            self.sendError("Fatal Error", domain: #function, completionHandler: completionHandler)
            return
        }
        let request = NSMutableURLRequest(url: URL(string: "\(LoginConstants.UserDataURL)\(key)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let data = self.checkForErrors(data: data, response: response, error: error, completionHandler: completionHandler) else {
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            self.convertDataWithCompletionHandler(newData) { data, error in
                
                guard error == nil else {
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
