//
//  StudyDay.swift
//  
//
//  Created by Jonas Richard Richter on 11.06.21.
//

import Foundation

/// A model representing a study day.
public struct StudyDay: Codable, Hashable {
    
    // The date of the study day.
    public var day: Date
    // The lessons of the study day.
    public var lessons: [Lesson]

}
