import XCTest
@testable import H19MediaViewer
import Nimble

class MediaViewerContentsViewTests: XCTestCase {

    var sut: MediaViewerContentsView!

    override func setUp() {
        super.setUp()

        sut = MediaViewerContentsView(frame: CGRect.zero)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testThatItHasAllowLandscapeDismissalProperyDefaultToFalse() {
        expect(self.sut.allowLandscapeDismissal) == false
    }

    func testThatItHasPannigViewModelWithCorrectBackgroundView() {
        expect(self.sut.pannedViewModel.backgroundView) == sut.backgroundView
    }

    func testThatItHasPannigViewModelWithCorrectContainerView() {
        expect(self.sut.pannedViewModel.containerView) == sut
    }

    func testThatInterfaceAlphaChangeWillChangeBackgroundAlpha() {
        sut.interfaceAlpha = 0.66

        expect(Double(self.sut.backgroundView.alpha)).to(beCloseTo(0.66))
    }

    func testThatInterfaceAlphaChangeWillControlsAlpha() {
        sut.interfaceAlpha = 0.66

        expect(self.sut.controlsAlpha) == 0.66
    }

    func testThatControlsAlphaChangeWillCloseButtonAlpha() {
        sut.controlsAlpha = 0.66

        expect(Double(self.sut.closeButton.alpha)).to(beCloseTo(0.66))
    }

    func testThatItHasScrollView() {
        expect(self.sut.scrollView).toNot(beNil())
    }

    func testThatItHasBackgroundView() {
        expect(self.sut.backgroundView).toNot(beNil())
    }

    func testThatItHasCloseButton() {
        expect(self.sut.closeButton).toNot(beNil())
    }

    func testThatCloseButtonSuperviewIsTheView() {
        expect(self.sut.closeButton.superview) == sut
    }

    func testThatScrollViewCoversTheWholeView() {
        sut.layoutIfNeeded()
        expect(self.sut.scrollView.frame.size) == CGSize(width: sut.bounds.size.width, height: sut.bounds.size.height)
    }

    func testThatItHasOverlayView() {
        sut.setupOverlayView(MediaViewerImage(image: UIImage(), infoOverlayViewClass: MediaViewerInfoOverlayView.self))

        expect(self.sut.overlayView).toNot(beNil())
    }

    func testThatItHasLongPressGestureRecogniser() {
        expect(self.sut.longPressGesture).toNot(beNil())
    }

    func testThatLongPressGestureRecogniserIsConnectedToSUT() {
        expect(self.sut.longPressGesture.view) == sut
    }

    class MockMediaViewerContentsViewDelegate: MediaViewerContentsViewActionsDelegate {
        var numberOfTimesLongPressWasDetected = 0
        func longPressActionDetectedInContentView(_ contentView: MediaViewerContentsView) {
            numberOfTimesLongPressWasDetected += 1
        }
    }

    func testThatLongPressGestureWillInformDelegate() {
        let delegate = MockMediaViewerContentsViewDelegate()
        sut.delegate = delegate

        sut.viewLongPressed(sut.longPressGesture)

        expect(delegate.numberOfTimesLongPressWasDetected) == 1
    }

    func testThatItHasSingleTapGestureRecogniser() {
        expect(self.sut.controlsTapGestureRecogniser).toNot(beNil())
    }

    func testThatSingleTapGestureRecogniserIsConnectedToSUT() {
        expect(self.sut.controlsTapGestureRecogniser.view) == sut
    }

    func testThatViewTappedWillToggleControlsAlphaFrom0() {
        sut.controlsAlpha = 0.0

        sut.viewTapped(sut.controlsTapGestureRecogniser)

        expect(self.sut.controlsAlpha) == 1.0
    }

    func testThatViewTappedWillToggleControlsAlphaFrom1() {
        sut.controlsAlpha = 1.0

        sut.viewTapped(sut.controlsTapGestureRecogniser)

        expect(self.sut.controlsAlpha) == 0.0
    }

    func testThatViewTappedWillNotToggleCloseButtonAlphaFrom0IfLandscapeAndControlsDisabledAtLandscape() {
        sut.controlsAlpha = 0.0
        sut.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        sut.allowLandscapeDismissal = false

        sut.viewTapped(sut.controlsTapGestureRecogniser)

        expect(self.sut.closeButton.alpha) == 0.0
    }

    class MockImageScroll: MediaViewerMultipleImageScrollView {

        var numerOfTimesZoomOutWasCalled = 0

        override func zoomOut() {
            numerOfTimesZoomOutWasCalled += 1
        }
    }

    func testThatViewTappedWillZoomOutIfTheViewIfZoomedIn() {
        let mockScroll = MockImageScroll()
        sut.scrollView = mockScroll

        sut.viewTapped(sut.controlsTapGestureRecogniser)

        expect(mockScroll.numerOfTimesZoomOutWasCalled) == 1
    }

    func testThatHideControlsWillHideThem() {
        sut.controlsAlpha = 1.0

        sut.hideControls()

        expect(self.sut.controlsAlpha) == 0.0
    }

    func testThatScrollViewDelegateIsSet() {
        expect(self.sut.scrollView.imageViewActionsDelgate === self.sut) == true
    }

    func testThatItHasPanGestureRecogniser() {
        expect(self.sut.panGestureRecogniser).toNot(beNil())
    }

    func testThatPanGestureRecogniserIsConnectedToScrollView() {
        expect(self.sut.panGestureRecogniser.view) == sut.scrollView
    }

    func testThatUpdateViewStateWithLandscapeWillResetBackgroundViewAlphaTo1() {
        sut.backgroundView.alpha = 0.2
        sut.updateViewStateWithLandscape(true)

        expect(self.sut.backgroundView.alpha) == 1.0
    }

    func testThatIfAllowLandscapeDismissalIsTrueControlsWillHideInLandscape() {
        sut.controlsAlpha = 1.0
        sut.updateViewStateWithLandscape(true)

        expect(self.sut.closeButton.alpha) == 0.0
    }

    func testThatIfAllowLandscapeDismissalIsTrueControlsNotWillHideInPortraint() {
        sut.controlsAlpha = 0.0
        sut.updateViewStateWithLandscape(false)

        expect(self.sut.controlsAlpha) == 1.0
    }
}
