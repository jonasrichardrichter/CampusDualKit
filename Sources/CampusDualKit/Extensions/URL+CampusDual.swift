//
//  URL+CampusDual.swift
//  
//
//  Created by Jonas Richard Richter on 22.01.22.
//

import Foundation

internal extension URL {
    enum CampusDual {
        static let baseURL = URL(string: "https://selfservice.campus-dual.de")!
        static let schedule = URL(string: "/room/json", relativeTo: Self.baseURL)!
        static let creditPoints = URL(string: "/dash/getcp", relativeTo: Self.baseURL)!
    }
}
