//
//  ScheduleServiceProtocol.swift
//  
//
//  Created by Jonas Richard Richter on 22.01.22.
//

import Foundation

protocol ScheduleServiceProtocol {
    
    /// The matriculation number of the user
    var username: String { get }
    
    /// The hash used to login to CampusDual
    var hash: String { get }
    
    /// Authentification for CampusDual
    ///
    /// - Parameters:
    ///     - for: The username used for login.
    ///     - with: The hash used for authentification.
    ///     - session: The URLSession to be used, default should be .shared
    ///     - completion: handler
    static func login(for username: String, with password: String, session: URLSession, completion: @escaping (Result<ScheduleServiceProtocol, ScheduleServiceError>) -> Void)
    
    /// Authentification for CampusDual
    ///
    /// - Parameters:
    ///     - for: The username used for login.
    ///     - with: The hash used for authentification.
    ///     - session: The URLSession to be used, default should be .shared
    /// - Returns: An authentificated ScheduleService.
    @available(macOS 12.0, watchOS 8.0, iOS 15.0, *)
    static func login(for username: String, with password: String, session: URLSession) async throws -> ScheduleServiceProtocol
    
    /// Get the all the study days in a given time period.
    ///
    /// - Parameters:
    ///     - from: The start date of the time period.
    ///     - to: The end date of the time period.
    ///     - session: The URLSession to be used, default should be .shared
    ///     - completion: handler
    func studyDays(from startDate: Date, to endDate: Date, session: URLSession, completion: @escaping (Result<[StudyDay], ScheduleServiceError>) -> Void)
    
    /// Get the all the study days in a given time period.
    ///
    /// - Parameters:
    ///     - from: The start date of the time period.
    ///     - to: The end date of the time period.
    ///     - session: The URLSession to be used, default should be .shared
    /// - Returns: An array of StudyDay's in the given time period.
    @available(macOS 12.0, watchOS 8.0, iOS 15.0, *)
    func studyDays(from startDate: Date, to endDate: Date, session: URLSession) async throws -> [StudyDay]
    
}
