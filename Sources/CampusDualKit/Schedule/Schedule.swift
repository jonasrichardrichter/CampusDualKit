//
//  Schedule.swift
//  
//
//  Created by Jonas Richard Richter on 11.06.21.
//

import Foundation
import Logging

/// The resource to fetch the schedule of a student.
public struct Schedule {
    
    /// The connector with which the connection should be established.
    let connector: CampusDualConnecter
    
    /// Logger from ``swift-log`` package
    let logger = Logger(label: "eu.jonasrichter.CampusDualKit.Schedule")
    
    /// Initialize the Schedule API
    /// - Parameter connector: The connector used to fetch data.
    public init(connector: CampusDualConnecter) {
        self.connector = connector
    }
    
    /// Get the schedule of a student for a given time interval.
    /// - Parameters:
    ///   - begin: The start of the time interval.
    ///   - end: The end of the time interval.
    /// - Returns: Array of all Study Days in the time interval.
    public func get(from begin: Date, to end: Date) async -> [StudyDay] {
        
        let urlSchedule = URL.init(string: "?userid=\(connector.matriculation)&hash=\(connector.hash)&start=\(begin.timeIntervalSince1970)&end=\(end.timeIntervalSince1970)", relativeTo: URL.endpoints.schedule)!
    
        
        logger.info("URL generated to endpoint 'schedule': \(urlSchedule.absoluteString)")
        
        var lessons: [Lesson] = []
        
        do {
            let (data, _) = try await URLSession.shared.data(from: urlSchedule)
            
            logger.info("Data fetched for endpoint 'schedule'")
            
            let jsonDecoder = JSONDecoder()
            
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
            
            lessons = try jsonDecoder.decode(Array<Lesson>.self, from: data)
            
            for lesson in lessons {
                logger.info("Parsed lesson: \(lesson)")
            }
        } catch {
            logger.critical("Error while parsing schedule: \(error)")
        }
        
        return sortByStudyDay(lessons: lessons)
    }
    
    /// Internal function to sort a array of Lesson into an array of StudyDay.
    /// - Parameters:
    ///   - lessons: The array of Lessons which should be sorted.
    /// - Returns: An sorted array of StudyDay with sorted lessons.
    private func sortByStudyDay(lessons: [Lesson]) -> [StudyDay] {
        
        var tempDay: String = ""
        var tempStudyDay: StudyDay?
        var returnArray: [StudyDay] = []
        
        for lesson in lessons {
            if tempDay == "" {
                
                // First case: First lesson of the array.
                
                tempDay = lesson.start.formatted(.dateTime.year().month().day())
                tempStudyDay = StudyDay(day: lesson.start, lessons: [lesson])
                
                logger.info("Created new StudyDay: \(String(describing: tempStudyDay))")
                
            } else if Calendar.current.isDate(lesson.start,
                                              inSameDayAs: try! Date(tempDay, strategy: .dateTime.year().month().day())) {
                
                // Second case: Another lesson on the same day.
                
                tempStudyDay!.lessons.append(lesson)
                
                logger.info("Updated StudyDay: \(String(describing: tempStudyDay))")
                
            } else {
                
                // Third case: First lesson of a new day.
                
                // Append to return Array and reset tempStudyDay
                returnArray.append(tempStudyDay!)
                
                logger.info("StudyDay added: \(String(describing: tempStudyDay))")
                
                tempDay = lesson.start.formatted(.dateTime.year().month().day())
                
                tempStudyDay = StudyDay(day: lesson.start, lessons: [lesson])
                
                logger.info("Created new StudyDay: \(String(describing: tempStudyDay))")
                
            }
                        
        }
        
        // Add last StudyDay to return Array
        
        returnArray.append(tempStudyDay!)
        
        logger.info("StudyDay added: \(String(describing: tempStudyDay))")
        
        return returnArray
    }
    
}
