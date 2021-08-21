//
//  ScheduleError.swift
//  
//
//  Created by Jonas Richard Richter on 11.06.21.
//

import Foundation

public enum ScheduleError: Error {
    case network(Error?)
    case server(httpCode: Int)
    case authentication
    case parse
    case cache
}
