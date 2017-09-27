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
    
    func fetchStudents(completionHandler: @escaping (_ result: [Student]?, _ error: NSError?) -> Void) {
        
        let parameters = ParametersArray ()
        _ = taskForGETAndPOST(Methods.Students, parameters: parameters as ParametersArray) { (results, error) in
            
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
                if let student = Student(dictionary: item) {
                    students.append(student)
                }
                else {
                    print("could not create and append student at index: \(index). Incorrect keys.")
                }
            }
            completionHandler(students, nil)
        }
    }
    
    func fetchStudent(_ id: String, completionHandler: @escaping (_ result: Student?, _ error: NSError?) -> Void) {
        
        print("fetchStudent called with ID: \(id)")
        
        let parameters = [UdacityClient.StudentParameterKeys.wherekey:"{\"\(UdacityClient.StudentParameterJSONBodyKey.uniqueKey)\":\"\(id)\"}"]
        print(parameters)
        
        _ = taskForGETAndPOST(Methods.Students, parameters: parameters as ParametersArray) { (results, error) in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            print(results)
            guard
                let results = results as? JSONDictionary,
                let resultsArray = results["results"] as? JSONArray,
                //let firstEntry = resultsArray[0] as? JSONDictionary,
                let mySelf = Student(dictionary: resultsArray[0])
                else {
                    completionHandler(nil, NSError(domain: "fetchStudent", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not evaluate json student data"]))
                    return
            }
            completionHandler(mySelf, nil)
        }
        
    }
    
    func add(student: Student, location: CLLocation, mapString: String, mediaURL: String, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        print("adding Student: \(student)")
        let jsonBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(location.coordinate.latitude), \"longitude\": \(location.coordinate.longitude)}"
        print(jsonBody)
        let parameters = ParametersArray ()
        let _ = taskForPOSTMethod(Methods.Students, parameters: parameters, jsonBody: jsonBody) { result, error in
            
            print(error)
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            print(result)
            // TODO: Continue Implementation
            
        }
    }
    
    
}
