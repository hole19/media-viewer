
import XCTest
@testable import hole19v2
import Nimble

class MediaViewerInteractiveImageViewTests: XCTestCase {
    
    var sut: MediaViewerInteractiveImageView!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewerInteractiveImageView(frame: CGRect(x:0, y: 0, width: 200, height: 200))
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
    
    func testThatItHasScrollView() {
        expect(self.sut.scrollView) != nil
    }

    func testThatScrollViewHasCorrectWidth() {
        sut.layoutIfNeeded()
        expect(self.sut.scrollView.frame.size.width) == 200
    }
    
    func testThatScrollViewHasCorrectHeight() {
        sut.layoutIfNeeded()
        expect(self.sut.scrollView.frame.size.height) == 200
    }
    
    func testThatScrollViewHasCorrectMinimumZoomScale() {
        expect(self.sut.scrollView.minimumZoomScale) == 1.0
    }
    
    func testThatScrollViewHasCorrectMaximumZoomScale() {
        expect(self.sut.scrollView.maximumZoomScale) == 2.0
    }
    
    func testThatScrollViewHasCorrectCurrentZoomScale() {
        expect(self.sut.scrollView.zoomScale) == 1.0
    }
    
    func testThatImageViewIsSubviewOfScrollView() {
        expect(self.sut.imageView.superview) == sut.scrollView
    }
    
    func testThatSutUIScrollViewDelegateMethodViewForZoomingInScrollViewReturnsImageView() {
        expect(self.sut.viewForZoomingInScrollView(self.sut.scrollView)) == sut.imageView
    }
    
}

