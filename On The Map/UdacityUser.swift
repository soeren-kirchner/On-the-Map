//
//  UdacityUser.swift
//  On The Map
//
//  Created by Sören Kirchner on 26.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import Foundation

struct UdacityUser {
    
    let key, firstname, lastname: String
    
    init?(dictionary: JSONDictionary) {
        guard let key = dictionary[UdacityClient.UserResponseKeys.key] as? String,
            let firstname = dictionary[UdacityClient.UserResponseKeys.firstname] as? String ,
            let lastname = dictionary[UdacityClient.UserResponseKeys.lastname] as? String
        else {
            print("ERROR in dictionary: \(dictionary)")
            return nil
        }
        self.key = key
        self.firstname = firstname
        self.lastname = lastname
    }
}
