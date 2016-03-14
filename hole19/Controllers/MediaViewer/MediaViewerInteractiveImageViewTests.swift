
import XCTest
@testable import hole19v2
import Nimble

class MediaViewerInteractiveImageViewTests: XCTestCase {
    
    var sut: MediaViewerInteractiveImageView!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewerInteractiveImageView(frame: CGRect(x:0,y: 0, width: 200, height: 200))
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItHasImageView() {
        expect(self.sut.imageView) != nil
    }
    
    func testThatImageViewHasCorrectWidth() {
        sut.layoutIfNeeded()
        expect(self.sut.imageView.frame.size.width) == 200
    }
    
    func testThatImageViewHasCorrectHeight() {
        sut.layoutIfNeeded()
        expect(self.sut.imageView.frame.size.height) == 200
    }    
}

