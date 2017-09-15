//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Sören Kirchner on 10.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = ""
        static let StudentsDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
    
    // MARK: Methods
    
    struct Methods {
        static let Students = "/parse/classes/StudentLocation"
    }
    
    // MARK: Students
    
    struct StudentResponseKeys {
        static let objectId = "objectId" // value: String
        static let uniqueKey = "uniqueKey" // value: String
        static let firstName = "firstName" // value: String
        static let lastName = "lastName" // value: String
        static let mapString = "mapString" // value: String
        static let mediaURL = "mediaURL" // value: String
        static let latitude = "latitude" // value: Double
        static let longitude = "longitude" // value: Double
        static let createdAt = "createdAt" // value: Date
        static let updatedAt = "updatedAt" // value: Date
    }
    
}
