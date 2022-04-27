//
//  Logger+CustomInit.swift
//  
//
//  Created by Jonas Richard Richter on 22.01.22.
//

import Foundation
import Logging

internal extension Logger {
    
    init(for className: String) {
        self.init(label: "eu.jonasrichter.CampusDualKit.\(className)")
    }
}
