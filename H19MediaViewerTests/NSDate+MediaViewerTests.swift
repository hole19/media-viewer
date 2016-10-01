import XCTest
@testable import H19MediaViewer
import Nimble

class NSDate_MediaViewerTests: XCTestCase {

    var sut: Date!

    override func setUp() {
        super.setUp()
        sut = Date.dateWith(day: 16, month: 3, year: 2015)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testThatItWillReturnCorrectDefaultString() {

        expect(self.sut.defaultString()) == "Mar 16, 2015"
    }

    func testThatItWillReturnCorrectDefaultStringForSeptember() {
        sut = Date.dateWith(day: 15, month: 9, year: 2016)
        expect(self.sut.defaultString()) == "Sep 15, 2016"
    }
}
