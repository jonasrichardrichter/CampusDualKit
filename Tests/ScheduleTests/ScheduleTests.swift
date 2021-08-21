//
//  ScheduleTests.swift
//  CampusDualKit
//
//  Created by Jonas Richard Richter on 29.06.21.
//

import XCTest
import CampusDualKit

class ScheduleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGettingSchedule() async throws {
        let cdConnector = await CampusDualConnecter(matriculation: "MAT", hash: "HASH")
        let schedule = Schedule(connector: cdConnector!)
        
        let lessons = await schedule.get(from: Date(), to: Date(timeIntervalSinceNow: 60 * 60 * 24 * 7 * 20))
        
        XCTAssert(lessons.count > 0)
        
    }

}
