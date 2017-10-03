//
//  UdacityClient.swift
//  On The Map
//
//  Created by Sören Kirchner on 10.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import Foundation
import MapKit

typealias UdacityDefaultCompletionHandler = (_ result: AnyObject?, _ error: NSError?) -> Void

final class UdacityClient: NSObject {
    
    // MARK: shared Instance (Singleton)
    
    private override init() {}
    static let shared = UdacityClient()

    // MARK: - Properties
    
    var session = URLSession.shared
    var account: UdacityAccount? = nil
    var user: UdacityUser? = nil
       
    func taskForGETAndPOST(_ method: String, httpMethod: String = "GET", parameters: ParametersArray? = nil, jsonBody: String? = nil, completionHandler: @escaping UdacityDefaultCompletionHandler) {
        
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.httpMethod = httpMethod
        
        if let jsonBody = jsonBody {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        }
       
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let data = self.checkForErrors(data: data, response: response, error: error, completionHandler: completionHandler) {
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandler)
            }
        }
        task.resume()
    }
    
    // MARK: helpers
    
    func checkForErrors(data: Data?, response: URLResponse?, error: Error?, domainForError: String = #function, completionHandler: UdacityDefaultCompletionHandler) -> Data? {
        guard (error == nil) else {
            self.sendError("There was an error with your request: \(error!)", domain: domainForError, completionHandler: completionHandler)
            return nil
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            self.sendError("Your request returned a status code other than 2xx!", domain: domainForError, completionHandler: completionHandler)
            return nil
        }
        
        guard let data = data else {
            self.sendError("No data was returned by the request!", domain: domainForError, completionHandler: completionHandler)
            return nil
        }
        return data
    }
    
    func sendError(_ error: String, domain: String = #function, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        print("ERROR: \(error)")
        print("IN DOMAIN: \(domain)")
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandler(nil, NSError(domain: domain, code: 1, userInfo: userInfo))
    }
    
    // given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    private func udacityURLFromParameters(_ parameters: ParametersArray?, withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
}
