//
//  UdacityLogin.swift
//  On The Map
//
//  Created by Sören Kirchner on 10.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func udacityLogin(user: String, password:String, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
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
            
//            func sendError(_ error: String) {
//                print(error)
//                let userInfo = [NSLocalizedDescriptionKey : error]
//                completionHandler(nil, NSError(domain: "udacityLogin", code: 1, userInfo: userInfo))
//            }
            
//            guard (error == nil) else {
//                self.sendError("There was an error with your request: \(error!)", completionHandler: completionHandler)
//                return
//            }
//
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                self.sendError("Your request returned a status code other than 2xx!", completionHandler: completionHandler)
//                return
//            }
//
//            guard let data = data else {
//                self.sendError("No data were returned by the request!", completionHandler: completionHandler)
//                return
            //            }
            
            if let data = self.checkForErrors(data: data, response: response, error: error, completionHandler: completionHandler) {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
            }
        }
        task.resume()
    }
    
    func fetchMyPublicData (completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        print("fetchMyPublicData")
        guard let key = UdacityClient.shared.account?.key else {
            print("key is nil")
            return
        }
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(key)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            print(error)
            
//            func sendError(_ error: String) {
//                print(error)
//                let userInfo = [NSLocalizedDescriptionKey : error]
//                completionHandler(nil, NSError(domain: "udacityLogin", code: 1, userInfo: userInfo))
//            }
            
//            guard error == nil else {
//                print("error")
//                return
//            }
//
//            guard let data = data else {
//                self.sendError("No data were returned by the request!", completionHandler: completionHandler)
//                return
//            }
            
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
                    print(error)
                    self.sendError("could not convert data", completionHandler: completionHandler)
                    return
                }
                
                guard let userData = data as? JSONDictionary,
                    let user = userData["user"] as? JSONDictionary else {
                    print("something wrong with data")
                    return
                }
                
                if let user = UdacityUser(dictionary: user) {
                    print(user)
                }
                else {
                    print("something went wrong")
                }
            }
        }
        task.resume()
    }
    
}
