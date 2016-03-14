
import XCTest
@testable import hole19v2
import Nimble

class MediaViewerContentsViewTests: XCTestCase {
    
    var sut: MediaViewerContentsView!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewerContentsView(frame: CGRectZero)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItHasImageView() {
        expect(self.sut.imageView) != nil
    }
    
    func testThatItHasBackgroundView() {
        expect(self.sut.backgroundView) != nil
    }
    
    func testThatItHasCloseButton() {
        expect(self.sut.closeButton) != nil
    }
    
    func testThatCloseButtonSuperviewIsTheView() {
        expect(self.sut.closeButton.superview) == sut
    }
    
    func testThatImageViewCoversTheWholeView() {
        sut.layoutIfNeeded()
        expect(self.sut.imageView.frame.size) == CGSizeMake(sut.bounds.size.width, sut.bounds.size.height)
    }
    
    func testThatImageViewHasContentModeAspectFit() {
        expect(self.sut.imageView.contentMode) == UIViewContentMode.ScaleAspectFit
    }
    
    func testThatItHasOverlayView() {
        expect(self.sut.overlayView) != nil
    }

}

