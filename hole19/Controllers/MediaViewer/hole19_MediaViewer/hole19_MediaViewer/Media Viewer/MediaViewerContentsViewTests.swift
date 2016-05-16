
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
    
    func testThatItHasPannigViewModelWithCorrectBackgroundView() {
        expect(self.sut.pannedViewModel.backgroundView) == sut.backgroundView
    }
    
    func testThatItHasPannigViewModelWithCorrectContainerView() {
        expect(self.sut.pannedViewModel.containerView) == sut
    }
    
    func testThatInterfaceAlphaChangeWillChangeBackgroundAlpha() {
        sut.interfaceAlpha = 0.66
        
        expect(self.sut.backgroundView.alpha).to(beCloseTo(0.66))
    }
    
    func testThatInterfaceAlphaChangeWillControlsAlpha() {
        sut.interfaceAlpha = 0.66
        
        expect(self.sut.controlsAlpha) == 0.66
    }
    
    func testThatControlsAlphaChangeWillCloseButtonAlpha() {
        sut.controlsAlpha = 0.66
        
        expect(self.sut.closeButton.alpha).to(beCloseTo(0.66))
    }
    
    func testThatItHasScrollView() {
        expect(self.sut.scrollView) != nil
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
    
    func testThatScrollViewCoversTheWholeView() {
        sut.layoutIfNeeded()
        expect(self.sut.scrollView.frame.size) == CGSizeMake(sut.bounds.size.width, sut.bounds.size.height)
    }
    
    func testThatItHasOverlayView() {
        sut.setupOverlayView(MediaViewerImage(image: UIImage(), infoOverlayViewClass: MediaViewerInfoOverlayView.self))
        
        expect(self.sut.overlayView) != nil
    }
    
    func testThatItHasLongPressGestureRecogniser() {
        expect(self.sut.longPressGesture) != nil
    }
    
    func testThatLongPressGestureRecogniserIsConnectedToSUT() {
        expect(self.sut.longPressGesture.view) == sut
    }
    
    class MockMediaViewerContentsViewDelegate: MediaViewerContentsViewActionsDelegate {
        var numberOfTimesLongPressWasDetected = 0
        func longPressActionDetectedInContentView(contentView: MediaViewerContentsView) {
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
        expect(self.sut.controlsTapGestureRecogniser) != nil
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
        expect(self.sut.panGestureRecogniser) != nil
    }
    
    func testThatPanGestureRecogniserIsConnectedToScrollView() {
        expect(self.sut.panGestureRecogniser.view) == sut.scrollView
    }

}

