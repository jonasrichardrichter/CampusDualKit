//
//  ScheduleService.swift
//  
//
//  Created by Jonas Richard Richter on 22.01.22.
//

import Foundation
import Logging

/// A service provider for fetching schedule data from CampusDual.
public struct ScheduleService {
    
    // MARK: - Properties
    
    let logger: Logger = Logger.init(for: "ScheduleService")
    
    let username: String
    let hash: String
    
    // MARK: - Authentication functions
    
    // TODO: Add possibility to login with CampusDual password
    
    /// Authentication for CampusDual
    ///
    /// - Parameters:
    ///     - for: The username used for login.
    ///     - with: The hash used for authentication.
    ///     - session: The URLSession to be used, default should be .shared
    ///     - completion: handler
    public static func login(for username: String, with password: String, session: URLSession = .shared, completion: @escaping (Result<ScheduleService, ScheduleServiceError>) -> Void) {
        
        if username.isEmpty {
            completion(.failure(.wrongCredentials))
            return
        }
        
        if password.isEmpty {
            completion(.failure(.wrongCredentials))
            return
        }
        
        // Check if credentials are correct.
        // Request current credit points, if request is successful -> Credentials are correct
        guard let url = URL(string: "?user=\(username)&hash=\(password)", relativeTo: URL.CampusDual.creditPoints) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        session.scheduleServiceDataTask(request: request, session: session) { (result: Result<Int, ScheduleServiceError>) in
            switch result {
            case .success(_):
                let scheduleService = ScheduleService(username: username, hash: password)
                
                completion(.success(scheduleService))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Authentication for CampusDual
    ///
    /// - Parameters:
    ///     - for: The username used for login.
    ///     - with: The hash used for authentication.
    ///     - session: The URLSession to be used, default should be .shared
    /// - Returns: An authenticated ScheduleService.
    @available(iOS 15.0, macOS 12.0, *)
    public static func login(for username: String, with password: String, session: URLSession = .shared) async throws -> ScheduleService {
        try await withCheckedThrowingContinuation() { continuation in
            self.login(for: username, with: password, session: session) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    // MARK: - Schedule functions
    
    /// Get the all the study days in a given time period.
    ///
    /// - Parameters:
    ///     - from: The start date of the time period.
    ///     - to: The end date of the time period.
    ///     - session: The URLSession to be used, default should be .shared
    ///     - completion: handler
    public func studyDays(from startDate: Date, to endDate: Date, session: URLSession = .shared, completion: @escaping (Result<[StudyDay], ScheduleServiceError>) -> Void) {
        
        guard let url = URL(string: "?userid=\(self.username)&hash=\(self.hash)&start=\(startDate.timeIntervalSince1970)&end=\(endDate.timeIntervalSince1970)", relativeTo: URL.CampusDual.schedule) else {
            completion(.failure(.invalidURL))
            return
        }
        
        self.logger.debug("Starting request to fetch schedule data. Request information: \(url)")
        
        let request = URLRequest(url: url)
        
        session.scheduleServiceDataTask(request: request, session: session) { (result: Result<[Lesson], ScheduleServiceError>) in
            switch result {
            case .success(let data):
                let sortedStudyDays = self.sortLessonsToStudyDays(data, startDate: startDate)
                
                completion(.success(sortedStudyDays))
            case .failure(let error):
                self.logger.error("There was an error while fetching the schedule. More information: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    /// Get the all the study days in a given time period.
    ///
    /// - Parameters:
    ///     - from: The start date of the time period.
    ///     - to: The end date of the time period.
    ///     - session: The URLSession to be used, default should be .shared
    /// - Returns: An array of StudyDay's in the given time period.
    @available(iOS 15.0, macOS 12.0, *)
    public func studyDays(from startDate: Date, to endDate: Date, session: URLSession) async throws -> [StudyDay] {
        try await withCheckedThrowingContinuation() { continuation in
            self.studyDays(from: startDate, to: endDate) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    // MARK: - Private functions
    
    /// Internal function to sort an array of lessons to an array of studyDays.
    ///
    /// - Parameters:
    ///     - _: The array to be sorted.
    /// - Returns: A sorted array of StudyDay with sorted lessons.
    private func sortLessonsToStudyDays(_ array: [Lesson], startDate: Date) -> [StudyDay] {
        
        var tempDay: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var tempStudyDay: StudyDay?
        var returnArray: [StudyDay] = []
        
        for lesson in array {
            if tempDay == "" {
                
                // Check if lesson is before start date
                
                if lesson.start < startDate {
                    continue
                }
                
                // First case: First lesson of the array.
                
                tempDay = dateFormatter.string(from: lesson.start)
                
                tempStudyDay = StudyDay(day: lesson.start, lessons: [lesson])
                
                self.logger.debug("Created new StudyDay: \(String(describing: tempStudyDay))")
                
            } else if Calendar.current.isDate(lesson.start, inSameDayAs: dateFormatter.date(from: tempDay)!) {
                
                // Second case: Another lesson on the same day.
                
                tempStudyDay!.lessons.append(lesson)
                
                self.logger.debug("Updated StudyDay: \(String(describing: tempStudyDay))")
                
            } else {
                
                // Third case: First lesson of a new day.
                
                // Append to return Array and reset tempStudyDay
                returnArray.append(tempStudyDay!)
                
                self.logger.debug("StudyDay added: \(String(describing: tempStudyDay))")
                
                tempDay = dateFormatter.string(from: lesson.start)
                
                tempStudyDay = StudyDay(day: lesson.start, lessons: [lesson])
                
                self.logger.debug("Created new StudyDay: \(String(describing: tempStudyDay))")
                
            }
            
        }
        
        // Add last StudyDay to return Array
        
        returnArray.append(tempStudyDay!)
        
        self.logger.debug("StudyDay added: \(String(describing: tempStudyDay))")
        
        return returnArray
    }
}
