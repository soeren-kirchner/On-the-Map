//
//  UdacityAccount.swift
//  On The Map
//
//  Created by Sören Kirchner on 23.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import Foundation

struct UdacityAccount {
    
    let key: String
    let registered: Bool
    
    init?(dictionary: JSONDictionary) {
        print(dictionary)
        guard let key = dictionary["key"] as? String,
            let registered = dictionary["registered"] as? Bool
        else {
            return nil
        }
        self.key = key
        self.registered = registered
    }
    
}
