//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Sören Kirchner on 25.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import Foundation
import CoreLocation

extension UdacityClient {
    
    func fetchStudents(completionHandler: @escaping UdacityDefaultCompletionHandler) {
        
        let parameters = [UdacityClient.StudentParameterKeys.order: UdacityClient.StudentParameter.updatedAtDESC]
        taskForGETAndPOST(Methods.Students, parameters: parameters as ParametersArray) { (results, error) in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            var students = [Student] ()
            
            guard
                let results = results as? JSONDictionary,
                let resultsArray = results["results"] as? JSONArray
                else {
                    completionHandler(nil, NSError(domain: "fetchStudents", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Students"]))
                    return
            }
            
            for (index, item) in resultsArray.enumerated() {
                guard let student = Student(dictionary: item) else {
                    // print error to console only
                    print("could not create and append student at index: \(index). Incorrect keys.")
                    continue
                }
                
                students.append(student)
            }
            completionHandler(students as AnyObject, nil)
        }
    }
    
    func fetchStudent(_ id: String, completionHandler: @escaping UdacityDefaultCompletionHandler) {
        
        let parameters = [UdacityClient.StudentParameterKeys.wherekey:"{\"\(UdacityClient.StudentParameterJSONBodyKey.uniqueKey)\":\"\(id)\"}",
            UdacityClient.StudentParameterKeys.order: UdacityClient.StudentParameter.updatedAtDESC]
        
        taskForGETAndPOST(Methods.Students, parameters: parameters as ParametersArray) { (results, error) in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            guard
                let results = results as? JSONDictionary,
                let resultsArray = results["results"] as? JSONArray else {
                    completionHandler(nil, NSError(domain: "fetchStudent", code: 100, userInfo: [NSLocalizedDescriptionKey: "Data corrupt"]))
                    return
            }
            
            guard resultsArray.count > 0 else {
                print("resultArray without value")
                completionHandler(nil, NSError(domain: "fetchStudent", code: 101, userInfo: [NSLocalizedDescriptionKey: "User still not exist"]))
                return
            }
                
            guard let mySelf = Student(dictionary: resultsArray[0])
                else {
                    completionHandler(nil, NSError(domain: "fetchStudent", code: 102, userInfo: [NSLocalizedDescriptionKey: "Could not evaluate json student data"]))
                    return
            }
            completionHandler(mySelf as AnyObject, nil)
        }
    }
    
    func add(location: CLLocation, mapString: String, mediaURL: String, completionHandler: @escaping UdacityDefaultCompletionHandler) {
        print("adding student")
        addOrUpdate(location: location, mapString: mapString, mediaURL: mediaURL, httpMethod: "POST", completionHandler: completionHandler)
    }
    
    func update(objectID: String, location: CLLocation, mapString: String, mediaURL: String, completionHandler: @escaping UdacityDefaultCompletionHandler) {
        print("updating")
        addOrUpdate(objectId: objectID, location: location, mapString: mapString, mediaURL: mediaURL, httpMethod: "PUT", completionHandler: completionHandler)
    }
    
    func addOrUpdate(objectId: String = "", location: CLLocation, mapString: String, mediaURL: String, httpMethod: String, completionHandler: @escaping UdacityDefaultCompletionHandler) {

        guard let account = UdacityClient.shared.account else {
            completionHandler(nil, NSError(domain: "updateInformation", code: 1, userInfo: [NSLocalizedDescriptionKey: "No Account Data"]));
            return
        }

        guard let user = UdacityClient.shared.user else {
            completionHandler(nil, NSError(domain: "updateInformation", code: 1, userInfo: [NSLocalizedDescriptionKey: "No User Data"]));
            return
        }

        let jsonBody = """
            {
                "uniqueKey": "\(account.key)",
                "firstName": "\(user.firstname)",
                "lastName": "\(user.lastname)",
                "mapString": "\(mapString)",
                "mediaURL": "\(mediaURL)",
                "latitude": \(location.coordinate.latitude),
                "longitude": \(location.coordinate.longitude)
            }
        """

        let method = Methods.Students + (httpMethod == "POST" ? "" : "/" + objectId)

        taskForGETAndPOST(method, httpMethod: httpMethod, jsonBody: jsonBody) { result, error in
            completionHandler(result, error)
        }
    }
}
