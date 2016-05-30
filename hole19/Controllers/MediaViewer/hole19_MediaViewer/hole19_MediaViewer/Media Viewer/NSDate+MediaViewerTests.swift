
import XCTest
@testable import hole19v2
import Nimble

class NSDate_MediaViewerTests: XCTestCase {
    
    var sut: NSDate!
    
    override func setUp() {
        super.setUp()
        sut = NSDate.dateWith(day: 16, month: 3, year: 2015)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItWillReturnCorrectDefaultString() {
        
        expect(self.sut.defaultString()) == "Mar 16, 2015"
    }
    
    func testThatItWillReturnCorrectDefaultStringForSeptember() {
        sut = NSDate.dateWith(day: 15, month: 9, year: 2016)
        expect(self.sut.defaultString()) == "Sep 15, 2016"
    }
}

