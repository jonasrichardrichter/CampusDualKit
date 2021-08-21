//
//  Lesson.swift
//  
//
//  Created by Jonas Richard Richter on 11.06.21.
//

import Foundation

/// A model representing a lesson.
public struct Lesson: Codable, Hashable {
    /// The title of the lesson.
    public var  title: String
    /// The start time of the lesson.
    public var  start: Date
    /// The end time of the lesson.
    public var  end: Date
    /// The description of the lesson.
    public var  description: String
    /// The room number of the lesson.
    public var  room: String
    /// The instructor of the lesson.
    public var  instructor: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case start = "start"
        case end = "end"
        case description = "description"
        case room = "room"
        case instructor = "instructor"
    }
}
