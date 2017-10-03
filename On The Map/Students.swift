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
    private var iteratorIndex: Int = 0
    
    // MARK: shared Instance (Singleton)
    
    static let shared = Students()
    
    var count: Int {
        get {
            return studentsArray.count
        }
    }
    
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
    
    func replace(by students: [Student]) {
        studentsArray = students
    }
    
    
    
}

extension Students: Sequence, IteratorProtocol {
    
    func makeIterator() -> Students {
        iteratorIndex = 0
        return self
    }
    
    func next() -> Student? {
        if iteratorIndex >= studentsArray.count {
            return nil
        }
        let currentStudent = studentsArray[iteratorIndex]
        iteratorIndex += 1
        return currentStudent
    }
}

