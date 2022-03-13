//
//  Observable.swift
//  RealEstateTestApp
//
//  Created by Patrick Rugebregt on 04/03/2022.
//

import Foundation

class Observable<T> {
    
    /// Boxing class for MVVM reactive pattern
    /// Using generics for reusability
    var value: T {
        didSet {
            listener?(value)
            NotificationCenter.default.post(name: .updateHouses, object: nil, userInfo: ["houses":value])
        }
    }
    
    /// closure to set value 
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    /// binding method for viewcontrollers
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
    
}
