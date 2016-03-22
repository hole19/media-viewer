
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
    
    func testThatInterfaceAlphaChangeWillChangeBackgroundAlpha() {
        sut.interfaceAlpha = 0.66
        
        expect(self.sut.backgroundView.alpha) == 0.66
    }
    
    func testThatInterfaceAlphaChangeWillControlsAlpha() {
        sut.interfaceAlpha = 0.66
        
        expect(self.sut.controlsAlpha) == 0.66
    }
    
    func testThatControlsAlphaChangeWillCloseButtonAlpha() {
        sut.controlsAlpha = 0.66
        
        expect(self.sut.closeButton.alpha) == 0.66
    }
    
    func testThatItHasInteractiveImageView() {
        expect(self.sut.interactiveImageView) != nil
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
        expect(self.sut.interactiveImageView.frame.size) == CGSizeMake(sut.bounds.size.width, sut.bounds.size.height)
    }
    
    func testThatImageViewHasContentModeAspectFit() {
        expect(self.sut.interactiveImageView.imageView.contentMode) == UIViewContentMode.ScaleAspectFit
    }
    
    func testThatItHasOverlayView() {
        expect(self.sut.overlayView) != nil
    }
    
    func testThatItHasSingleTapGestureRecogniser() {
        expect(self.sut.controlsTapGestureRecogniser) != nil
    }
    
    func testThatSingleTapGestureRecogniserIsConnectedToSUT() {
        expect(self.sut.controlsTapGestureRecogniser.view) == sut
    }
    
    func testThatViewTappedWillToggleAlphaFrom0() {
        sut.controlsAlpha = 0.0
        
        sut.viewTapped(sut.controlsTapGestureRecogniser)
        
        expect(self.sut.controlsAlpha) == 1.0
    }
    
    func testThatViewTappedWillToggleAlphaFrom1() {
        sut.controlsAlpha = 1.0
        
        sut.viewTapped(sut.controlsTapGestureRecogniser)
        
        expect(self.sut.controlsAlpha) == 0.0
    }
}

