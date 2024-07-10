//
//  Obsevable.swift
//  MVVMmini
//
//  Created by 여누 on 7/11/24.
//

import Foundation

class Obsevable<T> {
    
    var closure : ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
}

