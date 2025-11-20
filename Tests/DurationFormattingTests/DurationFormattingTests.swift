import XCTest
@testable import DurationFormatting   // <- replace with whatever the target is called

final class DurationFormatterTests: XCTestCase {
    
    func testShortFormatBasic() {
        let formatter = DurationFormatting(style: .short)
        XCTAssertEqual(formatter.string(from: 65), "1m 5s")
    }
    
    func testLongFormatMaximumUnits() {
        let formatter = DurationFormatting(style: .long, maximumUnits: 2)
        XCTAssertEqual(formatter.string(from: 3661), "1 hour and 1 minute")
    }
    
    func testPositionalUnderHour() {
        let formatter = DurationFormatting(style: .positional)
        XCTAssertEqual(formatter.string(from: 125), "2:05")
    }
    
    func testPositionalOverHour() {
        let formatter = DurationFormatting(style: .positional)
        XCTAssertEqual(formatter.string(from: 3661), "1:01:01")
    }
    
    func testZero() {
        let short = DurationFormatting(style: .short)
        XCTAssertEqual(short.string(from: 0), "0s")
        
        let long = DurationFormatting(style: .long)
        XCTAssertEqual(long.string(from: 0), "0 seconds")
    }
    
    func testNegativeDurations() {
        let formatter = DurationFormatting(style: .short)
        XCTAssertEqual(formatter.string(from: -75), "-1m 15s")
    }
    
    func testMaximumUnitsRespected() {
        let formatter = DurationFormatting(style: .short, maximumUnits: 2)
        XCTAssertEqual(formatter.string(from: 3_726), "1h 2m")
    }
    
    func testExcludingSeconds() {
        let formatter = DurationFormatting(style: .short, maximumUnits: 3, includesSeconds: false)
        XCTAssertEqual(formatter.string(from: 75), "1m")
    }
    
    //TimeInterval Extenstion Tests
    
    func testTimeIntervalExtensionDefault() {
        let duration: TimeInterval = 3661
        XCTAssertEqual(duration.formattedDuration(), "1h 1m 1s")
    }
    
    func testTimeIntervalExtensionLongStyle() {
        let duration: TimeInterval = 3661
        XCTAssertEqual(duration.formattedDuration(style: .long, maximumUnits: 2), "1 hour and 1 minute")
    }
    
    func testTimeIntervalExtensionPositional() {
        let duration: TimeInterval = 125
        XCTAssertEqual(duration.formattedDuration(style: .positional), "2:05")
    }
    
    func testTimeIntervalExtensionWithoutSeconds() {
        let duration: TimeInterval = 75
        XCTAssertEqual(duration.formattedDuration(includesSeconds: false), "1m")
    }
    
    func testTimeIntervalExtensionNegative() {
        let duration: TimeInterval = -75
        XCTAssertEqual(duration.formattedDuration(), "-1m 15s")
    }

}
