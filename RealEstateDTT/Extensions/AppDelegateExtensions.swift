//
//  AppDelegateExtensions.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 03/03/2022.
//

import Foundation
import UIKit

extension AppDelegate {
    
    static var shared: Self {
        UIApplication.shared.delegate as! Self
    }
    
}
