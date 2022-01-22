//
//  ScheduleServiceError.swift
//  
//
//  Created by Jonas Richard Richter on 22.01.22.
//

import Foundation

public enum ScheduleServiceError: Error {
    case invalidURL
    case wrongCredentials
    case network(Error?)
    case other(Error?)
}
