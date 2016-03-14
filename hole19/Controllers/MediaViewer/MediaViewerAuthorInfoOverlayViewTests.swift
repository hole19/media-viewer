
import XCTest
@testable import hole19v2
import Nimble

class MediaViewerAuthorInfoOverlayViewTests: XCTestCase {
    
    var sut: MediaViewerAuthorInfoOverlayView!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewerAuthorInfoOverlayView(frame: CGRectZero)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItHasImageView() {
        expect(self.sut.authorImageView) != nil
    }
    
    func testThatImageViewHasCorrectWidth() {
        sut.layoutIfNeeded()
        expect(self.sut.authorImageView.frame.size.width) == 44
    }
    
    func testThatImageViewHasCorrectHeight() {
        sut.layoutIfNeeded()
        expect(self.sut.authorImageView.frame.size.height) == 44
    }
    
    func testThatItHasTitleLabel() {
        expect(self.sut.authorTitleLablel) != nil
    }

}

