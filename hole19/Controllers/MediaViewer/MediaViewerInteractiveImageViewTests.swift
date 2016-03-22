
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
    
    func testThatItHasMaximumZoomScaleWithCorrectDefaultValue() {
        expect(self.sut.maximumZoomScale) == 2.0
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
        sut.maximumZoomScale = 4.5
        
        expect(self.sut.scrollView.maximumZoomScale) == 4.5
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
    
    func testThatItHasDoubleTapGestureRecogniser() {
        expect(self.sut.zoomDoubleTapGestureRecogniser) != nil
    }
    
    func testThatItHasDoubleTapGestureRecogniserRequresTwoTaps() {
        expect(self.sut.zoomDoubleTapGestureRecogniser.numberOfTapsRequired) == 2
    }
    
    func testThatDoubleTapGestureRecogniserIsConnectedToSUT() {
        expect(self.sut.zoomDoubleTapGestureRecogniser.view) == sut
    }
    
    func testThatViewDoubleTappedWillToggleZoomFromMin() {
        sut.maximumZoomScale = 3.0
        sut.scrollView.zoomScale = 1.0
        
        sut.viewDoubleTapped(sut.zoomDoubleTapGestureRecogniser)
        
        expect(self.sut.scrollView.zoomScale) == 3.0
    }
    
    func testThatViewDoubleTappedWillToggleZoomFromMax() {
        sut.maximumZoomScale = 3.0
        sut.scrollView.zoomScale = 2.0
        
        sut.viewDoubleTapped(sut.zoomDoubleTapGestureRecogniser)
        
        expect(self.sut.scrollView.zoomScale) == 1.00
    }
    
    func testThatViewDoubleTappedWillToggleZoomAnimated() {
        let mockScroll = MockScrollView()
        sut.scrollView = mockScroll
        
        sut.viewDoubleTapped(sut.zoomDoubleTapGestureRecogniser)
        
        expect(mockScroll.numberOfTimesSetZoomScaleWasCalled) == 1
        expect(mockScroll.animatedValueOfSetZoomScale) == true
    }
}

