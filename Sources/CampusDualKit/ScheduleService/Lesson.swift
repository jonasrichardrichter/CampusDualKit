//
//  Lesson.swift
//  
//
//  Created by Jonas Richard Richter on 11.06.21.
//

import Foundation

/// A model representing a lesson.
public struct Lesson: Codable, Hashable {
    
    /// The initializer for the struct.
    public init(title: String, start: Date, end: Date, description: String, room: String, instructor: String, remarks: String) {
        self.title = title
        self.start = start
        self.end = end
        self.description = description
        self.room = room
        self.instructor = instructor
        self.remarks = remarks
    }
    
    /// The title of the lesson.
    public var title: String
    /// The start time of the lesson.
    public var start: Date
    /// The end time of the lesson.
    public var end: Date
    /// The description of the lesson.
    public var description: String
    /// The room number of the lesson.
    public var room: String
    /// The instructor of the lesson.
    public var instructor: String
    /// The remarks of the lesson.
    public var remarks: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case start = "start"
        case end = "end"
        case description = "description"
        case room = "room"
        case instructor = "instructor"
        case remarks = "remarks"
    }
    
    /// An example lesson
    public static let example = Lesson(title: "Example lesson", start: Date.init(timeIntervalSince1970: 1793097900), end: Date.init(timeIntervalSince1970: 1793103300), description: "This is an example lesson", room: "1.202", instructor: "Prof. Dr. Example", remarks: "Group A")
}
