//
//  Students.swift
//  On The Map
//
//  Created by Sören Kirchner on 03.10.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import Foundation

class Students {
    
    private var studentsArray = [Student] ()
    
    // MARK: shared Instance (Singleton)
    
    static let shared = Students()
    
    func append(student: Student) {
        studentsArray.append(student)
    }
    
    func get(atIndex: Int) -> Student{
        return studentsArray[atIndex]
    }
    
    func enumerated() -> EnumeratedSequence<[Student]> {
        return studentsArray.enumerated()
    }
    
    func removeAll() {
        studentsArray.removeAll()
    }
    
}
