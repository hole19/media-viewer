
import XCTest
@testable import H19MediaViewer
import Nimble

class MediaViewerInfoOverlayViewTests: XCTestCase {
    
    var sut: MediaViewerInfoOverlayView!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewerInfoOverlayView(frame: CGRectMake(0,0,300,80))
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItHasCorrectDefaultHeight() {
        expect(self.sut.defaultHeight()) == 0.0
    }
}

