import XCTest
@testable import H19MediaViewer
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
        expect(self.sut.imageView).toNot(beNil())
    }

    func testThatItHasMaximumZoomScaleWithCorrectDefaultValue() {
        expect(self.sut.maximumZoomScale) == 4.0
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
        expect(self.sut.scrollView).toNot(beNil())
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
        expect(self.sut.viewForZooming(in: self.sut.scrollView)) == sut.imageView
    }

    func testThatItHasDoubleTapGestureRecogniser() {
        expect(self.sut.zoomDoubleTap).toNot(beNil())
    }

    func testThatItHasDoubleTapGestureRecogniserRequresTwoTaps() {
        expect(self.sut.zoomDoubleTap.numberOfTapsRequired) == 2
    }

    func testThatDoubleTapGestureRecogniserIsConnectedToSUT() {
        expect(self.sut.zoomDoubleTap.view) == sut
    }

    func testThatViewDoubleTappedWillToggleZoomFromMin() {
        sut.maximumZoomScale = 3.0
        sut.scrollView.zoomScale = 1.0

        sut.viewDoubleTapped(sut.zoomDoubleTap)

        expect(self.sut.scrollView.zoomScale) == 3.0
    }

    func testThatViewDoubleTappedWillToggleZoomFromMax() {
        sut.maximumZoomScale = 3.0
        sut.scrollView.zoomScale = 2.0

        sut.viewDoubleTapped(sut.zoomDoubleTap)

        expect(self.sut.scrollView.zoomScale) == 1.00
    }

    func testThatViewDoubleTappedWillCallZoomIntoRectAnimated() {
        let mockScroll = MockScrollView()
        sut.scrollView = mockScroll

        sut.viewDoubleTapped(sut.zoomDoubleTap)

        expect(mockScroll.numberOfTimesZoomToRectWasCalled) == 1
        expect(mockScroll.animatedValueOfSetZoomToRect) == true
    }

    func testThatViewDoubleTappedWillZoomIntoPoint() {
        let mockScroll = MockScrollView()
        sut.scrollView = mockScroll
        mockScroll.contentSize = CGSize(width: 400, height: 400)
        mockScroll.frame = CGRect(x: 0, y: 0, width: 400, height: 400)

        let mockGestureRecogniser = TapGestureRecogniserMock()
        mockGestureRecogniser.locationInViewToReturn = CGPoint(x: 60, y: 60)

        sut.viewDoubleTapped(mockGestureRecogniser)

        expect(mockScroll.rectValueOfSetZoomToRect) == CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0)
    }

    class MockMediaViewerInteractiveImageViewDelegate: MediaViewerInteractiveImageViewDelegate {

        var numberOfTimesDismissControlsWasCalled = 0

        func hideControls() {
            numberOfTimesDismissControlsWasCalled += 1
        }
    }

    func testThatZoomingInWillSendDelegateMethodToDismissControls() {
        let delegate = MockMediaViewerInteractiveImageViewDelegate()
        sut.delegate = delegate
        sut.scrollView.zoomScale = 2.0

        sut.scrollViewDidZoom(sut.scrollView)

        expect(delegate.numberOfTimesDismissControlsWasCalled) == 1
    }

    func testThatZoomingOutWillNotSendDelegateMethodToDismissControls() {
        sut.scrollView.zoomScale = 4.0
        sut.scrollViewDidZoom(sut.scrollView)

        let delegate = MockMediaViewerInteractiveImageViewDelegate()
        sut.delegate = delegate

        sut.scrollView.zoomScale = 2.0
        sut.scrollViewDidZoom(sut.scrollView)

        expect(delegate.numberOfTimesDismissControlsWasCalled) == 0
    }

    func testThatZoomingOutWillSetZoomScaleToOne() {
        sut.scrollView.zoomScale = 2.0

        sut.zoomOut()

        expect(self.sut.scrollView.zoomScale) == 1.0
    }

    func testThatImageViewHasContentModeAspectFit() {
        expect(self.sut.imageView.contentMode) == UIView.ContentMode.scaleAspectFit
    }
}

private extension MediaViewerInteractiveImageView {
    var zoomDoubleTap: UITapGestureRecognizer {
        return zoomDoubleTapGestureRecognizer as! UITapGestureRecognizer
    }
}
