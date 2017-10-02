//
//  Student.swift
//  On The Map
//
//  Created by Sören Kirchner on 11.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import Foundation

//struct StudentBaseInformation {
//    let objectID, firstName, lastName, mapString, mediaURL: String
//    let latitude, longitude: Double
//}

struct Student {
    let objectId, uniqueKey, firstName, lastName, mapString, mediaURL: String
    let latitude, longitude: Double
    let createdAt, updatedAt: Date
    
    init?(dictionary: JSONDictionary) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat=UdacityClient.Constants.StudentsDateFormat
        
        guard let objectId = dictionary[UdacityClient.StudentResponseKeys.objectId] as? String,
            let uniqueKey = dictionary[UdacityClient.StudentResponseKeys.uniqueKey] as? String,
            let firstName = dictionary[UdacityClient.StudentResponseKeys.firstName] as? String,
            let lastName = dictionary[UdacityClient.StudentResponseKeys.lastName] as? String,
            let mapString = dictionary[UdacityClient.StudentResponseKeys.mapString] as? String,
            let mediaURL = dictionary[UdacityClient.StudentResponseKeys.mediaURL] as? String,
            let latitude = dictionary[UdacityClient.StudentResponseKeys.latitude] as? Double,
            let longitude = dictionary[UdacityClient.StudentResponseKeys.longitude] as? Double,
            let createdAtString = dictionary[UdacityClient.StudentResponseKeys.createdAt] as? String,
            let createdAt = dateFormatter.date(from: createdAtString),
            let updatedAtString = dictionary[UdacityClient.StudentResponseKeys.updatedAt] as? String,
            let updatedAt = dateFormatter.date(from: updatedAtString)
        else {
            print("ERROR in dictionary: \(dictionary)")
            return nil
        }
        
        // String Types
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
    
        // Double Types
        self.latitude = latitude
        self.longitude = longitude
        
        // Date Types
        self.createdAt = createdAt
        self.updatedAt = updatedAt        
    }
}
