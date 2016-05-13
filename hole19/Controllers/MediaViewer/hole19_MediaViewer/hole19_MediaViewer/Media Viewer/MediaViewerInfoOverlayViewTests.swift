
import XCTest
@testable import hole19v2
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

    
//    func testThatItHasImageView() {
//        expect(self.sut.authorImageView) != nil
//    }
//    
//    func testThatImageViewHasCorrectWidth() {
//        sut.layoutIfNeeded()
//        expect(self.sut.authorImageView.frame.size.width) == 26.0
//    }
//    
//    func testThatImageViewHasCorrectHeight() {
//        sut.layoutIfNeeded()
//        expect(self.sut.authorImageView.frame.size.height) == 26.0
//    }
//    
//    func testThatItHasAuthorTitleLabel() {
//        expect(self.sut.authorTitleLablel) != nil
//    }
//    
//    func testThatItHasTakenByLabel() {
//        expect(self.sut.takenByTitle) != nil
//    }
//    
//    func testThatTakenByLabelHasCorrectText() {
//        expect(self.sut.takenByTitle.text) == NSLocalizedString("klMediaViewer_TakenBy", comment: "")
//    }
//    
//    func testThatItHasBlurBackgroundView() {
//        expect(self.sut.blurBackground) != nil
//    }
//    
//    func testThatBlurBackgroundViewHasVisualEffectBlur() {
//        expect(self.sut.blurBackground.effect as? UIBlurEffect) != nil
//    }
//    
//    func testThatImageViewHasCorrectCornerRadius() {
//        expect(self.sut.authorImageView.layer.cornerRadius) == 3.0
//    }
    
}

